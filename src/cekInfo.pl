/* Basis untuk tulisPemain */
tulisPemain(Urutan, JumlahPemain,, []) :-
    Urutan > JumlahPemain,
    !.

/* Rekurens tulisPemain */
tulisPemain(Urutan, JumlahPemain, [Nama | SisaNama]) :-
    write('Nama pemain'), write(Urutan), write(': '), write(Nama), nl,
    player(Nama, DaftarKartu),
    length(DaftarKartu, X),
    write('Jumlah kartu : '), write(X), nl, nl,
    NextUrutan is Urutan + 1,
    tulisPemain(NextUrutan, JumlahPemain, SisaNama).

/* Basis untuk tulisListUrutan */
tulisListUrutan([NamaTerakhir]) :-
    write(NamaTerakhir), write('.'), nl, !.

/* Rekurens tulisListUrutan */ 
tulisListUrutan([Nama | Sisa]) :-
    write(Nama), write(' - '),
    tulisListUrutan(Sisa). 

cekInfo :-
    gameStatus(ListPlayer, DiscardPile, DrawPile),
    write('Kartu discard top: '), write(DiscardPile), nl, nl,
    write('Urutan pemain: '), 
    tampilListPlayer(ListPlayer), nl,
    tulisPemain(1, JumlahPemain, ListUrutan).
