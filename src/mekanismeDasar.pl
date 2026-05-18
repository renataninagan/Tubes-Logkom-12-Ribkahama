:- include('cekInfo.pl').
:- include('primitif.pl').

pindahGiliran([Pemain|SisaPemain], ListPemainNow) :-
    appendElem(SisaPemain, [Pemain], ListPemainNow).

adaKartu(Deck, kartu(Warna, Jenis)) :-
    member(kartu(W, J), Deck),
    (W == Warna ; J == Jenis ; W == hitam),!.

drawKartu(0, DrawPile, Deck, DrawPile, Deck) :- !.
drawKartu(N, [KartuAtas|SisaDraw], Deck, DrawPileSisa, DeckSisa) :-
    N > 0,
    appendElem(Deck, [KartuAtas], DeckNow),
    N1 is N - 1,
    drawKartu(N1, SisaDraw, DeckNow, DrawPileSisa, DeckSisa).

akhiriGiliran(Nama, Status, DeckNow, SisaPemain, Discard, DrawPileNow) :-
    PemainNow = player(Nama, Status, DeckNow),
    appendElem(SisaPemain, [PemainNow], ListPemainNow),
    retractall(gameStatus(_, _, _)),
    asserta(gameStatus(ListPemainNow, Discard, DrawPileNow)),
    (StatusNow == menang -> format('~w Menang!~n', [Nama]) ; true),
    cekInfo.

ambilKartu :-
    gameStatus([player(Nama, Status, Deck)|SisaPemain], Discard, DrawPile),!,
    drawKartu(1, DrawPile, Deck, DrawPileNow, DeckNow),
    format('~w mengambil 1 kartu dari deck dan mengakhiri giliran.~n', [Nama]), nl,
    akhiriGiliran(Nama, Status, DeckNow, SisaPemain, Discard, DrawPileNow).

mainkanKartu(N) :-
    gameStatus([player(Nama, Status, Deck)|SisaPemain], [KartuTerakhir|SisaDiscard], DrawPile),

    length(Deck, L),
    (N >= 1, N =< L -> true ; format('Tidak ada kartu ke ~w! Pilih kartu antara 1 - ~w.~n', [N, L]), fail),

    getCard(Deck, N, Played),
    Played  = kartu(WarnaPilih, JenisPilih),
    KartuTerakhir = kartu(WarnaTerakhir, JenisTerakhir),
    ((WarnaPilih == WarnaTerakhir ; JenisPilih == JenisTerakhir ; WarnaPilih == hitam) ->  
    kartuCocok(Nama, Status, Deck, N, Played, SisaPemain, KartuTerakhir, SisaDiscard, DrawPile);   kartuTidakCocok(Nama, Deck, KartuTerakhir)).

kartuCocok(Nama, Status, Deck, N, Played, SisaPemain, KartuTerakhir, SisaDiscard, DrawPile) :-
    Played = kartu(WarnaPilih, JenisPilih),

    removeCard(Deck, N, DeckNow),
    (DeckNow == [] -> StatusNow = menang ; StatusNow = Status),
    
    format('~w mengeluarkan kartu : ~w ~w~n', [Nama, WarnaPilih, JenisPilih]),
    (JenisPilih == drawtwo ->  SisaPemain = [player(NamaNext, StatusNext, DeckNext)|SisaLain],
        drawKartu(2, DrawPile, DeckNext, DrawPileNow, DeckNextNow), 
        PemainNext = player(NamaNext, StatusNext, DeckNextNow),
        appendElem(SisaLain, [PemainNext], SisaPemainEfek),
        format('~w mengambil 2 kartu dari draw pile akibat drawtwo card!~n', [NamaNext]);   
    JenisPilih == rev -> reverseL(SisaPemain, SisaPemainEfek),
        DrawPileNow = DrawPile,
        write('Urutan giliran dibalik!'), nl;   
        SisaPemainEfek = SisaPemain,
        DrawPileNow = DrawPile),

    akhiriGiliran(Nama, Status, DeckNow, SisaPemain, Discard, DrawPileNow).
    
kartuTidakCocok(Nama, Deck, KartuTerakhir) :-
    write('Kartu tidak cocok! Pilih kartu lain.'), nl,
    (\+ adaKartu(Deck, KartuTerakhir) -> format('~w tidak punya kartu yang cocok, otomatis mengambil kartu.~n', [Nama]),ambilKartu; true),fail.
