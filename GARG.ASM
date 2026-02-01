;GetParam:PROC rev. B
;parsuj linie:  <filespec1> <filespec2> [/B=nn] [/H]
;CY=blad, ax=kod bledu

INCLUDE INC\head.inc

           .MODEL SMALL
           .CODE

PUBLIC GetParam

           JUMPS
GetParam   PROC
           mov ax,@DATA
           mov es,ax
           mov si,80h
           cmp BYTE PTR [si],0
           je @@err1 ;nie ma argumentow
           inc si
pcl:
           cmp BYTE PTR [si],20h
           je pcl-1
           cmp BYTE PTR [si],9
           je pcl-1
           cmp BYTE PTR [si],'/'
           je switch
           cmp BYTE PTR [si],0dh
           je @@eop
           cmp BYTE PTR [si],20h
           jl @@err2 ;nieznany znak w linii

           mov cx,63 ;max. dlugosc dla filecpec
           xor ax,ax ;znacznik
           test es:[param],MASK f1
           jnz @@cf2
           or es:[param],MASK f1
           mov di,OFFSET es:fspec1
           jmp gfs
    @@cf2:
           test es:[param],MASK f2
           jnz @@err2 ;nieznany znak
           or es:[param],MASK f2
           mov di,OFFSET es:fspec2

gfs:       ;pobierz filespec
           cmp BYTE PTR [si],20h
           jle pcl
           movsb
           loop gfs
           jmp @@err3 ;nieprawidlowa sciezka/nazwa pliku

switch:
           inc si
           cmp BYTE PTR [si],'?'
           je @@err1 ;pokaz help

           lodsb
           or al,20h
           cmp al,'b'
           jne caseH
           cmp es:[maxDiff.bMAX],0 ;sprawdzic w sciezce /b=0 i /b=3 jednocz.
           jne @@err2 ;juz podano
           cmp BYTE PTR [si],'='
           jne @@b
           inc si
      @@b:
           lodsw
           cmp al,'0'
           jb @@err4 ;nieprawidlowa liczba
           cmp al,'9'
           ja @@err4
           cmp ah,20h ;jesli ah<=20h to 1 cyfra
           jbe @@sd   ;
           cmp ah,'0'
           jb @@err4
           cmp ah,'9'
           ja @@err4
           sub ax,3030h
           mov bl,10
           mov bh,ah
           mul bl
           add al,bh
     @@wr:
           mov es:[maxDiff.bMax],al ;DO INNEJ ZMIENNEJ
           cmp BYTE PTR [si],20h
           ja @@err4
           jmp pcl
     @@sd:
           dec si ;wyrownaj ofset
           sub al,30h
           jmp @@wr

caseH:
           cmp al,'h'
           jne @@err2
           cmp es:[optH],2 ;tylko 1
           je @@err2
           mov es:[optH],2
           cmp BYTE PTR [si],20h
           ja @@err2
           jmp pcl
;----------------------------------------------------------------------------
@@err1:    ;bez argumentow lub /?
           mov ax,1
           jmp @@err
@@err2:    ;nieprawidlowy argument / nieznany znak w linii komend
           mov ax,2
           jmp @@err
@@err3:    ;nieprawidlowa sciezka / nazwa pliku
           mov ax,3
           jmp @@err
@@err4:    ;nieprawidlowa wartosc dla /b
           mov ax,4
@@err:
           stc
           ret
@@eop:
           cmp es:[param],11b
           jne @@err1
           xor ax,ax  ;i 'clc'
           ret
           ENDP

           .DATA

EXTRN optH:WORD
EXTRN fSpec1,fSpec2
EXTRN maxDiff:DLIM,param:FL

           END
