:- include('factsRules.pl').
:- dynamic(game_status/3).   

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

ambilNKartu(0, Pile, [], Pile) :- !.
ambilNKartu(N, [H|T], [H|Kartu], Sisa) :-
    N > 0,
    N1 is N - 1,
    ambilNKartu(N1, T, Kartu, Sisa).

bagikanKartu([], DrawPile, [], DrawPile).
bagikanKartu([player(Nama, Status, [])|T], DrawPile,
             [player(Nama, Status, Tangan)|ListBaru], DrawPileBaru) :-
    write('Membagikan ke '), write(Nama), nl,         % debug
    ambilNKartu(7, DrawPile, Tangan, DrawPileSisa),
    write('Tangan '), write(Nama), write(': '), write(Tangan), nl, % debug
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
isUniquePemain(Nama, [player(H,_,_)|T], X) :-
    Nama \== H,
    isUniquePemain(Nama, T, Y),
    X is 1, !.
isUniquePemain(Nama, [player(H,_,_)|T], X) :-
    X is 0.

loopInputNama(0, L, L) :- !.
loopInputNama(N, L, PlayerFinal) :-
    N > 0,
    write('Masukkan nama pemain: '),
    read(Nama),
    isUniquePemain(Nama, L, X),
    ( X == 1 ->  N1 is N - 1, append(L, [player(Nama, main, [])], L1), loopInputNama(N1, L1, PlayerFinal);
        write('Nama sudah digunakan! Silakan input ulang.'), nl, loopInputNama(N, L, PlayerFinal)).
    
inisialisasiGame :-
    jumlahPemain(N),
    loopInputNama(N, [], ListPlayer),
    deckLengkap(DeckMentah),
    shuffleKartu(DeckMentah, DrawPileAwal),
    bagikanKartu(ListPlayer, DrawPileAwal, ListTerisi, DrawPileSisa),
    DrawPileSisa = [KartuPertama|DrawPileFinal],
    DiscardPile = [KartuPertama],
    retractall(game_status(_, _, _)),
    asserta(game_status(ListTerisi, DiscardPile, DrawPileFinal)),  
    write('Game siap!'), nl,
    tampilStatus.

cekStatus(player(_, menang, []), menang) :- !.
cekStatus(player(_, kalah,  _), kalah)  :- !.
cekStatus(player(_, main,  []), menang).   % deck habis → menang
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
    retractall(game_status(_, _, _)),
    asserta(game_status(ListPlayer, DiscardPile, DrawPile)).

tampilStatus :-
    game_status(ListPlayer, DiscardPile, DrawPile),
    write('=== GAME STATUS ==='), nl,
    write('Kartu teratas discard : '), write(DiscardPile), nl,
    length(DrawPile, JmlDraw),
    write('Sisa DrawPile         : '), write(JmlDraw), write(' kartu'), nl,
    write('Pemain                :'), nl,
    tampilListPlayer(ListPlayer).

tampilListPlayer([]).
tampilListPlayer([player(Nama, Status, Deck)|T]) :-
    length(Deck, JmlKartu),
    write('  - '), write(Nama),
    write(' | status: '), write(Status),
    write(' | kartu: '), write(Deck), nl,
    tampilListPlayer(T).
