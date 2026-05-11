/* Mendapatkan jumlah pemain */
readJumlahPemain(X) :-
    write('Masukkan jumlah pemain: '),
    read(Input),
    cekInputJumlah(Input, X).

/* Predikat bantuan untuk cek input jumlah pemain */
cekInputJumlah(Input, Input) :-
    integer(Input), 
    Input >= 2, 
    Input =< 4, 
    !.

/* Jika input tidak memenuhi ketentuan, jalankan cekInputJumlah yang ini */
cekInputJumlah(_, X) :-
    write('Mohon masukkan angka antara 2-4.'), nl,
    readJumlahPemain(X).

/* Basis untuk predikat readNama (Berhenti jika list sudah kosong dan urutan lebih dari jumlah)*/
readNama(Urutan, Jumlah, _, []) :-
    Urutan > Jumlah,
    !.

/* Rekurens readNama dengan cek input nama terlebih dahulu */
readNama(Urutan, Jumlah, ListInputNama, [Nama | SisaNama]) :-
    write('Masukkan nama pemain '), write(Urutan), write(': '),
    cekInputNama(ListInputNama, Nama), 
    NextUrutan is Urutan + 1,
    readNama(NextUrutan, Jumlah, [Nama | ListInputNama], SisaNama).

/* Predikat bantuan untuk cek input nama apakah sudah pernah di inputkan sebelumnya atau tidak */
cekInputNama(ListInputNama, Nama) :-
    read(Input),
    (   member(Input, ListInputNama) 
    ->  write('Nama sudah digunakan. Masukkan nama lain: '),
        cekInputNama(ListInputNama, Nama) 
    ;   
        Nama = Input 
    ).

/* Mengacak giliran untuk para pemain */
beriUrutanGiliran(ListNama, ListUrutan) :-
    use_module(library(random)),
    random_permutation(ListNama, ListUrutan),
    write('Urutan pemain: '), 
    tulisListUrutan(ListUrutan).

/* Basis untuk predikat bantuan */
tulisListUrutan([NamaTerakhir]) :-
    write(NamaTerakhir), write('.'), nl, !.

/* Rekurens tulisListUrutan */ 
tulisListUrutan([Nama | Sisa]) :-
    write(Nama), write(' - '),
    tulisListUrutan(Sisa). 


/* Fungsi main untuk start game */
startGame :-
    readJumlahPemain(Jumlah),
    readNama(1, Jumlah, [], ListNama),
    beriUrutanGiliran(ListNama, _ListUrutan),
    write('Setiap pemain mendapatkan 7 kartu acak.'), nl.