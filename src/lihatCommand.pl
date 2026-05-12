% menampilkan command yang bisa dipilih pemain
/* belum pakai state definisi conditional
 state pemain, (pasti) akan direvisi/ditambahkan
lagi setelah diskusi lebih lanjut */

lihatCommand :-
    nl,
    write('Aksi utama yang tersedia:'), nl,
    (
        bisaMainKartu ->
        write('1. mainKartu'), nl
    ;
        true
    ),
    (
        bisaAmbilKartu ->
        write('2. ambilKartu'), nl
    ;
        true
    ),
    (
        bisaTantang ->
        write('3. tantang'), nl
    ;
        true
    ),

    nl,
    write('Aksi pendukung yang tersedia'), nl,
    write('1. lihatCommand'), nl,
    write('2. lihatKartu'), nl,
    write('3. cekInfo'), nl.