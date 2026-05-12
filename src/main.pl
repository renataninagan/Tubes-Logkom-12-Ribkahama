:- include('startGame.pl ').
 
startgame :-
    nl,
    write('==============================='), nl,
    write('  Selamat datang di Permainan UNI!'), nl,
    write('==============================='), nl,
    nl,
    write('Aturan :'), nl,
    write('  - Cocokkan warna atau angka kartu teratas'), nl,
    write('  - Ketik DrawPile untuk ambil kartu dari DrawPile'), nl,
    write('  - Pemain  yang kartunya habis maka MENANG'), nl,
    write('  - Jika DrawPile habis dan tidak bisa main, KALAH'), nl,
    nl,
    inisialisasiGame,
    nl,
    write('--- Mulai bermain ---'), nl.
 