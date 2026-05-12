tulisPemain(Urutan, JumlahPemain,, [NamaTerakhir]) :-
    Urutan > JumlahPemain,
    !.

tulisPemain(Urutan, JumlahPemain, [Nama | SisaNama]) :-
    write('Nama pemain'), write(Urutan), write(': '), write(Nama), nl,
    player(Nama, DaftarKartu),
    length(DaftarKartu, X),
    write('Jumlah kartu : '), write(X), nl, nl,
    NextUrutan is Urutan + 1,
    tulisPemain(NextUrutan, JumlahPemain, SisaNama).


cek_info :-
    urutanPemain(ListUrutan),
    jumlahPemain(JumlahPemain), 
    write('Kartu discard top: '), write(kartu_angka(H)), nl, nl,
    write('Urutan pemain: '), 
    tulisListUrutan(ListUrutan), nl,
    tulisPemain(1, JumlahPemain, ListUrutan).