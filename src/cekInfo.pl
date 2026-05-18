/* Basis untuk tulisPemain */
tulisPemain(Urutan, JumlahPemain,_) :-
    Urutan > JumlahPemain,
    !.

/* Rekurens tulisPemain */
tulisPemain(Urutan, JumlahPemain, [Nama | SisaNama]) :-
    write('Nama pemain'), write(Urutan), write(': '), write(Nama), nl,
    player(Nama, DaftarKartu),
    getLen(DaftarKartu, X),
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
    nl,
    gameStatus(ListPlayer, DiscardPile, DrawPile),
    DiscardPile = [kartu(W,J)|_],
    nl, write('=== STATUS TERKINI ==='), nl,
    ListPlayer = [player(Nama, StatusBaru, Deck)|SisaPemain],
    write('Kartu discard top    : '), write(W), write('-'), write(J),nl, nl,
    write('Urutan pemain        : '), nl,
    tampilListPlayer(ListPlayer), nl,
    write('Giliran '), write(Nama), nl.

tampilListPlayer([]).
tampilListPlayer([player(Nama, Status, Deck)|T]) :-
    write('-  '), write(Nama),
    getLen(Deck, JmlKartu),nl,
    write('Status                 : '), write(Status),nl,
    write('Jumlah Kartu di Tangan : '), write(JmlKartu), nl,
    tampilListPlayer(T).
