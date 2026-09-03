-----------------------------------------------------------------------------

 *** BDIFF v0.5 ***                                      (c)1996 'marikaz'

 Porownuje dwa pliki i wyswietla raport przedstawiajacy znalezione roznice.

-----------------------------------------------------------------------------

        Uzycie:
        -------
BDIFF.EXE [/b[=]nn] [/d] [drive:][path]<file1> [drive:][path]<file2>

/b[=]nn      Przerwij po znalezieniu nn roznic,
             nn=0..99, domyslnie 0 (nie przerywaj).
/d           Wyswietlaj ofsety w liczbah dec.
file1,file2  Nazwy porownywanych plikow.


        Raport:
        -------
- Nazwy i sciezki do plikow,
- data i czas modyfikacji,
- rozmiar,
- ofset, na ktorym wystapila roznica,
- wartosc bajtu (hex.) w 1 i 2 pliku, gdzie wystapila roznica.

        Uwagi:
        ------
- Jesli pliki maja rozne rozmiary, to porownywanie zakonczy sie
  oczywiscie na ostatnim bajcie krotszego.
- Raport mozna przekierowac do pliku w standardowy dla DOS sposob.
- Program po znalezieniu 65535 roznic przerywa dalsze dzialania.

        Kompilacja:
        -----------
- W programie wystepuja odwolania do makr zawartych w pliku fileio.mac,
  ktorego nie ma w repozytorium. Makra wykonuja standardowe operacje na
  plikach.
- Kompilacje i testy tej wersji: TASM 5.0, DOSBox 0.74-3
