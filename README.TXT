---------------------------------------------------------------------[F2508]-
 BDIFF v0.4 * 1996 'marikaz'
 Porownuje dwa pliki i wyswietla raport przedstawiajacy znalezione roznice.

 PROGRAM JEST W WERSJI BETA I MOZE ZAWIERAC NIEDOSTRZEZONE DOTYCHCZAS BLEDY!
-----------------------------------------------------------------------------

Uzycie:
-------
 BDIFF.EXE [/B=nn] [/H] <Filespec1> <filespec2>

 /B=nn      Przerwij po znalezieniu nn roznic.
            nn=0..99, domyslnie 0 (nie przerywaj).
 /H         Wyswietl ofset w pliku w liczbah heksadecymalnych
 Filespec1  \ Sciezki+nazwy porownywanych plikow. Dla biezacej lokalizacji
 Filespec2  / sciezke mozna pominac.

Raport wyswietla nastepujace dane:
- Sciezki do plikow,
- date i czas modyfikacji,
- rozmiar,
- ofset w pliku w ktorym wystapila roznica, offset mozna wyswietlic
  w wartosciach hex. po podaniu opcji /H
- wartosc bajtu w 1 i 2 pliku w hex.

Uwagi:
------
 - Jesli pliki maja rozne rozmiary, to porownywanie zakonczy sie na
   ostatnim bajcie krotszego.
 - Raport mozna przekierowac do pliku w standardowy dla DOS sposob.
 - Program po znalezieniu 65536 roznic przerywa dalsze porownywanie
   z oczywistych chyba powodow.

Kompilacja:
-----------
 - W programie wystepuja odwolania do makr zawartych w pliku fileio.mac,
   ktorego nie ma w repozytorium. Makra wykonuja standardowe operacje na
   plikach.

Kompilacja i testy: TASM, DOSBox 0.74-3
