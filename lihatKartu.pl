% menampilkan kartu pemain

lihatKartu :-
    gameStatus([player(_,_,ListKartu)|_], DiscardPile, DrawPile),
    tampilkanKartu(ListKartu, 1).

tampilkanKartu([], _).

tampilkanKartu([kartu(Warna, Jenis) | Rest], No) :-
    write(No),
    write('. '),
    write(Warna),
    write('-'),
    write(Jenis),
    nl,

    Noke is No + 1,
    tampilkanKartu(Rest, Noke).