:- include('factsRules.pl').
:- include('mekanismeDasar.pl').
:- dynamic(gameStatus/3).   
:- dynamic(isStart/1).  

adaDiDeck(H, [H|_]).
adaDiDeck(H, [_|T]) :- adaDiDeck(H, T).

deckLengkap(Deck) :- ambilDeck([], Deck).

ambilDeck(A, Deck) :- kartu(Warna, Jenis), \+ (adaDiDeck(kartu(Warna, Jenis), A)),!, ambilDeck([kartu(Warna, Jenis)|A], Deck).
ambilDeck(A, A).

shuffleKartu([], []).
shuffleKartu(Deck, [H|T]) :-
    length(Deck, Len),
    random(0, Len, Idx),
    nth0(Idx, Deck, H),
    select(H, Deck, Sisa),
    shuffleKartu(Sisa, T).

awalBagiKartu(0, Pile, [], Pile) :- !.
awalBagiKartu(N, [H|T], [H|Kartu], Sisa) :-
    N > 0,
    N1 is N - 1,
    awalBagiKartu(N1, T, Kartu, Sisa).

bagikanKartu([], DrawPile, [], DrawPile).
bagikanKartu([player(Nama, Status, [])|T], DrawPile,
             [player(Nama, Status, KartuDiTangan)|ListBaru], DrawPileBaru) :-
    write('Membagikan ke '), write(Nama), nl,
    awalBagiKartu(7, DrawPile, KartuDiTangan, DrawPileSisa),
    write('kartuDiTangan '), write(Nama), write(': '), write(KartuDiTangan), nl,
    bagikanKartu(T, DrawPileSisa, ListBaru, DrawPileBaru).

verifikasiJumlahPemain(X, 1) :- X >= 2, X =< 4.
verifikasiJumlahPemain(X, 0) :- X < 2.
verifikasiJumlahPemain(X, 0) :- X > 4.

jumlahPemain(X) :-
    write('Masukkan jumlah pemain (2-4) : '),
    read(Jumlah),
    verifikasiJumlahPemain(Jumlah, Y),
    Y =:= 1,
    X is Jumlah, !.

jumlahPemain(X) :-
    write('Jumlah pemain tidak valid. Silakan input ulang.'), nl,
    jumlahPemain(X).

isUniquePemain(_, [], 1).
isUniquePemain(Nama, [player(Nama,_,_)|_], 0) :- !.
isUniquePemain(Nama, [player(H,_,_)|T], X) :-
    Nama \== H,
    isUniquePemain(Nama, T, X).

loopInputNama(0, L, L) :- !.
loopInputNama(N, L, PlayerFinal) :-
    N > 0,
    write('Masukkan nama pemain: '),
    read(Nama),
    isUniquePemain(Nama, L, X),
    ( X == 1 ->  N1 is N - 1, append(L, [player(Nama, main, [])], L1), loopInputNama(N1, L1, PlayerFinal);
        write('Nama sudah digunakan! Silakan input ulang.'), nl, loopInputNama(N, L, PlayerFinal)).
    
inisialisasiGame :-
    \+ (isStart(true)),!,
    jumlahPemain(N),
    loopInputNama(N, [], ListPlayer),
    deckLengkap(DeckAwal),
    shuffleKartu(DeckAwal, DrawPileAwal),
    bagikanKartu(ListPlayer, DrawPileAwal, ListTerisi, DrawPileSisa),
    DrawPileSisa = [KartuPertama|DrawPileFinal],
    DiscardPile = [KartuPertama],
    retractall(gameStatus(_, _, _)),
    asserta(gameStatus(ListTerisi, DiscardPile, DrawPileFinal)),
    write('Game siap!'), nl,
    ( ListTerisi = [player(GiliranNow,_,_)|_] -> true ; GiliranNow = 'nullllll' ),
    asserta(isStart(true)),
    tampilStatus.

cekStatus(player(_, menang, []), menang) :- !.
cekStatus(player(_, kalah,  _), kalah)  :- !.
cekStatus(player(_, main,  []), menang).  
cekStatus(player(_, main,   _), main).

updateStatusList([], []).
updateStatusList([H|T], [player(Nama, StatusBaru, Deck)|T2]) :-
    H = player(Nama, _, Deck),
    cekStatus(H, StatusBaru),
    updateStatusList(T, T2).

listPemainAktif([], []).
listPemainAktif([H|T], [H|L]) :-
    H = player(_, main, _), !,
    listPemainAktif(T, L).
listPemainAktif([_|T], L) :-
    listPemainAktif(T, L).

listPemenang([], []).
listPemenang([H|T], [H|L]) :-
    H = player(_, menang, _), !,
    listPemenang(T, L).
listPemenang([_|T], L) :-
    listPemenang(T, L).

updateGame(ListPlayer, DiscardPile, DrawPile) :-
    retractall(gameStatus(_, _, _)),
    asserta(gameStatus(ListPlayer, DiscardPile, DrawPile)).

tampilStatus :-
    nl, write('=== STATUS TERKINI ==='), nl,
    gameStatus(ListPlayer, DiscardPile, DrawPile),
    ListPlayer = [player(Nama, StatusBaru, Deck)|SisaPemain],
    write('Turn sekarang         : '), write(Nama), nl,
    DiscardPile = [Teratas|Sisa],
    write('Kartu teratas discard : '), write(Teratas), nl,
    length(DrawPile, JmlDraw),
    write('Sisa DrawPile         : '), write(JmlDraw), write(' kartu'), nl,
    write('Pemain                :'), nl,
    tampilListPlayer(ListPlayer).

tampilListPlayer([]).
tampilListPlayer([player(Nama, Status, Deck)|T]) :-
    write('-  '), write(Nama),
    length(Deck, JmlKartu),nl,
    write('Status               : '), write(Status),nl,
    write('Sisa Kartu di Tangan : '), write(Deck), nl,
    tampilListPlayer(T).
