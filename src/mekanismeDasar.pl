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

akhiriGiliran(Nama, StatusNow, DeckNow, SisaPemain, Discard, DrawPileNow) :-
    PemainNow = player(Nama, StatusNow, DeckNow),
    appendElem(SisaPemain, [PemainNow], ListPemainNow),
    retractall(gameStatus(_, _, _)),
    asserta(gameStatus(ListPemainNow, Discard, DrawPileNow)),
    (StatusNow == menang -> format('~w Menang!~n', [Nama]) ; true),
    cekInfo,
    !.

ambilKartu :-
    gameStatus([player(Nama, Status, Deck)|SisaPemain], Discard, DrawPile),!,
    drawKartu(1, DrawPile, Deck, DrawPileNow, DeckNow),
    format('~w mengambil 1 kartu dari deck dan mengakhiri giliran.~n', [Nama]), nl,
    akhiriGiliran(Nama, Status, DeckNow, SisaPemain, Discard, DrawPileNow).

kartuCocokSelainHitam(Deck, WarnaTerakhir, JenisTerakhir) :-
    member(kartu(W, J), Deck),
    W \== hitam,
    (W == WarnaTerakhir ; J == JenisTerakhir),!.

mainkanKartu(N) :-
    gameStatus([player(Nama, Status, Deck)|SisaPemain], [KartuTerakhir|SisaDiscard], DrawPile),
    KartuTerakhir = kartu(WarnaTerakhir, JenisTerakhir),
    length(Deck, L),
    (
        N >= 1,
        N =< L
    ->
        true
    ;
        format('Tidak ada kartu ke ~w! Pilih kartu antara 1 - ~w.~n',
            [N, L]),
        write('Pilih nomor kartu lagi: '),
        read(NBaru),
        mainkanKartu(NBaru),
        !
    ),

    getCard(Deck, N, Played),
    Played  = kartu(WarnaPilih, JenisPilih),

    (
        WarnaPilih == hitam,
        JenisPilih == wilddrawfour,
        kartuCocokSelainHitam(Deck, WarnaTerakhir, JenisTerakhir)
    ->
        write('Wild Draw Four tidak boleh digunakan. Ada kartu lain yang dapat digunakan.'), nl,
        write('Pilih nomor kartu lagi: '),
        read(NBaru),
        mainkanKartu(NBaru),
        !
    ;
        true
    ),

    (
        (
            WarnaPilih == WarnaTerakhir
        ;
            JenisPilih == JenisTerakhir
        ;
            (
                WarnaPilih == hitam,
                JenisTerakhir \== wild,
                JenisTerakhir \== wilddrawfour
            )
        )
    ->
        kartuCocok(Nama, Status, Deck, N, Played, SisaPemain, KartuTerakhir, SisaDiscard, DrawPile),
        !
    ;
        kartuTidakCocok(Nama, Deck, KartuTerakhir),
        !
    ).
kartuCocok(Nama, Status, Deck, N, Played, SisaPemain, KartuTerakhir, SisaDiscard, DrawPile) :-
    Played = kartu(WarnaPilih, JenisPilih),

    removeCard(Deck, N, DeckNow),
    (DeckNow == [] -> StatusNow = menang ; StatusNow = Status),

    format('~w mengeluarkan kartu : ~w ~w~n', [Nama, WarnaPilih, JenisPilih]),

    (JenisPilih == drawtwo ->
        SisaPemain = [player(NamaNext, StatusNext, DeckNext)|SisaLain],
        drawKartu(2, DrawPile, DeckNext, DrawPileNow, DeckNextNow),
        PemainNext = player(NamaNext, StatusNext, DeckNextNow),
        appendElem(SisaLain, [PemainNext], SisaPemainEfek),
        DiscardNow = [Played, KartuTerakhir | SisaDiscard],
        format('~w mengambil 2 kartu dari draw pile akibat drawtwo card!~n', [NamaNext])

    ; JenisPilih == rev ->
        reverseL(SisaPemain, SisaPemainEfek),
        DrawPileNow = DrawPile,
        DiscardNow = [Played, KartuTerakhir | SisaDiscard],
        write('Urutan giliran dibalik!'), nl

    ; JenisPilih == skip ->
        pindahGiliran(SisaPemain, SisaPemainEfek),
        DrawPileNow = DrawPile,
        DiscardNow = [Played, KartuTerakhir | SisaDiscard],
        write('Pemain berikutnya dilewati!'), nl

    ; JenisPilih == wild ->
        write('Pilih warna yang mau dimainkan: '), nl,
        read(WarnaBaru),
        format('Warna yang dipilih : ~w~n', [WarnaBaru]),
        PlayedNow = kartu(WarnaBaru, wild),
        SisaPemainEfek = SisaPemain,
        DrawPileNow = DrawPile,
        DiscardNow = [PlayedNow, KartuTerakhir | SisaDiscard], nl

    ; JenisPilih == wilddrawfour ->
        write('Pilih warna yang mau dimainkan: '), nl,
        read(WarnaBaru),
        format('Warna yang dipilih : ~w~n', [WarnaBaru]),

        SisaPemain = [player(NamaNext, StatusNext, DeckNext)|SisaLain],
        drawKartu(4, DrawPile, DeckNext, DrawPileNow, DeckNextNow),

        PemainNext = player(NamaNext, StatusNext, DeckNextNow),
        appendElem(SisaLain, [PemainNext], SisaPemainEfek),

        PlayedNow = kartu(WarnaBaru, wilddrawfour),
        DiscardNow = [PlayedNow, KartuTerakhir | SisaDiscard],

        format('~w mengambil 4 kartu akibat Wild Draw Four!~n', [NamaNext])

    ;
        SisaPemainEfek = SisaPemain,
        DrawPileNow = DrawPile,
        DiscardNow = [Played, KartuTerakhir | SisaDiscard]
    ),

    akhiriGiliran(Nama, StatusNow, DeckNow, SisaPemainEfek, DiscardNow, DrawPileNow).

kartuTidakCocok(Nama, Deck, KartuTerakhir) :-
    write('Kartu tidak cocok, silakan pilih kartu lain.'), nl,
    (
        adaKartu(Deck, KartuTerakhir)
    ->
        write('Pilih nomor kartu lagi: '),
        read(NBaru),
        mainkanKartu(NBaru)

    ;
        format('~w tidak punya kartu yang cocok, otomatis mengambil kartu.~n', [Nama]),
        ambilKartu
    ).

tantang :-
    gameStatus([player(NamaTantang, StatusTantang, DeckTantang)|SisaPemain], 
    [KartuTerakhir|SisaDiscard], DrawPile),
    
    (KartuTerakhir = kartu(_, wilddrawfour) ->
        true
    ;
        write('Tidak ada wild draw four yang bisa ditantang!'), nl, fail
    ),

    write('Tantangan dilakukan!'), nl,

    pemainTerakhir([player(NamaTantang, StatusTantang, DeckTantang)|SisaPemain], 
             player(NamaPelaku, StatusPelaku, DeckPelaku)),
    
    format('Memeriksa kartu ~w...~n', [NamaPelaku]),

    (SisaDiscard = [KartuSebelum|_] ->
        KartuSebelum = kartu(WarnaSebelum, JenisSebelum)
    ;
        WarnaSebelum = none, JenisSebelum = none
    ),

    (kartuCocokSelainHitam(DeckPelaku, WarnaSebelum, JenisSebelum) ->
        write('Tantangan berhasil!'), nl,
        format('~w mendapatkan 4 kartu akibat ketahuan curang.~n', [NamaPelaku]),

        cutLastElem([player(NamaTantang, StatusTantang, DeckTantang)|SisaPemain], 
                   SisaTanpaPelaku),
        drawKartu(4, DrawPile, DeckPelaku, DrawPileNow, DeckPelakuNow),
        PelakuNow = player(NamaPelaku, StatusPelaku, DeckPelakuNow),
        appendElem(SisaTanpaPelaku, [PelakuNow], ListSementara),

        retractall(gameStatus(_, _, _)),
        asserta(gameStatus(ListSementara, [KartuTerakhir|SisaDiscard], DrawPileNow)),
        cekInfo
    ;
        format('Tantangan gagal. ~w mendapatkan 6 kartu acak.~n', [NamaTantang]),

        drawKartu(6, DrawPile, DeckTantang, DrawPileNow, DeckTantangNow),
        PemainTantangNow = player(NamaTantang, StatusTantang, DeckTantangNow),
        SisaPemainNow = [PemainTantangNow|SisaPemain],
        PelakuSama = player(NamaPelaku, StatusPelaku, DeckPelaku),
        cutLastElem(SisaPemainNow, SisaTanpaPelaku2),
        appendElem(SisaTanpaPelaku2, [PelakuSama], ListFinal),

        pindahGiliran(ListFinal, ListPemainNow),
        retractall(gameStatus(_, _, _)),
        asserta(gameStatus(ListPemainNow, [KartuTerakhir|SisaDiscard], DrawPileNow)),
        cekInfo
    ).