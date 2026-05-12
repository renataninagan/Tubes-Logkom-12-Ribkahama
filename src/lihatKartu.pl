% menampilkan kartu pemain

lihatKartu(ListKartu) :-
    tampilkanKartu(ListKartu, 1).

tampilkanKartu([], _).

tampilkanKartu([Kartu | Rest], No) :-
    write(No),
    write('. '),
    write(Warna),
    write('-'),
    write(Jenis),
    nl,

    Noke is No + 1,
    tampilkanKartu(Rest, Noke).