
/* FAKTA */ 

pemain(X).

/* RULES */ 

read pemain(X).

kartu(X, Y) :-  /* WARNA, JENIS */ 
    kartu(merah, angka),
    kartu(kuning, angka),
    kartu(hijau, angka),
    kartu(biru, angka),

    kartu(merah, skip),
    kartu(kuning, skip),
    kartu(hijau, skip),
    kartu(biru, skip),

    kartu(merah, rev), /* REV -> REVERSE */  
    kartu(kuning, rev),
    kartu(hijau, rev),
    kartu(biru, rev),

    kartu(merah, drawtwo),
    kartu(kuning, drawtwo),
    kartu(hijau, drawtwo),
    kartu(biru, drawtwo),

    kartu(hitam, wild),

    kartu(hitam, drawfour),

    kartu(hitam, mimic).