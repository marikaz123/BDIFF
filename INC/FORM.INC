;----/ RAPORT /-------------------------------------------------/ BDIFF /---

rhead  DB 'BDIFF v',VER,' *** (c)1996 ''marikaz''',13,10
       RHEADL = ($-rhead)

file1  DB 13,10,'1. '
_cspc1 DB 63 DUP(20h),13,10
       DB 3 DUP(20h)
       DB 'zmodyfikowany: '
  _cd1 DB 'RRRR/MM/DD '
  _ct1 DB '00:00:00',', '
       DB 'rozmiar: '
_size1 DB 10 DUP(20h)
       DB 13,10,13,10
       FILE1L = ($-file1)

file2  DB '2. '
_cspc2 DB 63 DUP(20h),13,10
       DB 3 DUP(20h)
       DB 'zmodyfikowany: '
  _cd2 DB 'RRRR/MM/DD '
  _ct2 DB '00:00:00',', '
       DB 'rozmiar: '
_size2 DB 10 DUP(20h)
       DB 13,10
       FILE2L = ($-file2)

dhead  DB 13,10,'   Znalezione roznice:',13,10,13,10
       DB '       OFFSET    1    2',13,10
       DB '   ----------  ---  ---',13,10
       DHEADL = ($-dhead)

form0  LABEL
       DB 3 DUP(20h)
_offs  DB '0000000000'
       DB 3 DUP (20h)
   _b1 DB '  '
       DB 3 DUP (20h)
   _b2 DB '  '
       DB 13,10
       FORM0L = ($-form0)

;-----/ INFO i BLEDY /-------------------------------------------------------

;brak argumentow albo /?
hErrMsg DB 'Porownaj binarnie dwa pliki i wyswietl roznice.',13,10,13,10
        DB '   BDIFF.EXE [/d] [/b[=]nn] [drive:][path]<file1> [drive:][path]<file2>',13,10,13,10
        DB '/b[=]nn      Przerwij po znalezieniu nn roznic, nn=0..99',13,10
        DB '             nn=0 nie przerywaj (domyslnie).',13,10
        DB '/d           Wyswietl ofsety w liczbach dziesietnych.',13,10
        DB 'file1,file2  Nazwy porownywanych plikow.',13,10
        HEM = ($-hErrMsg)

;nieznany argument albo przypadkowy znak w linii (?)
pErrMsg DB 'Nieprawidlowa skladnia lub przypadkowy znak w linii polecen.',13,10
        DB 'Wpisz BDIFF.EXE /?',13,10
        PEM = ($-pErrMsg)

;nieprawidlowa liczba dla argumentu /b (4)
bErrMsg DB 'Nieprawidlowa wartosc dla opcji /B.',13,10
        BEM = ($-bErrMsg)

;nieprawidlowa sciezka lub nazwa pliku (3)
xErrMsg DB 'Blad w nazwie sciezki lub pliku.',13,10
        XEM = ($-xErrMsg) ;parser linii komend

eErrMsg DB 'Jeden z plikow jest pusty.',13,10
        EEM = ($-eErrMsg)

fErrMsg DB 'Blad i/o operacji na pliku.',13,10
        FEM = ($-fErrMsg)  ;przerwanie

sErrMsg DB 'Nie znaleziono sciezki lub pliku.',13,10
        SEM = ($-sErrMsg) ;lseek

;---/ KOMUNIKATY /-----------------------------------------------------------

ndMsg DB 13,10,'   Nie znaleziono roznic.',13,10
      NDM = ($-ndMsg)

dsMsg DB 13,10,'   Pliki maja rozne rozmiary.'
      DSM = ($-dsMsg)

tmMsg DB 13,10,'   Znaleziono zbyt wiele roznic, '
      DB 'dalsze porownywanie jest pozbawione sensu.',13,10
      TMM = ($-tmMsg)
