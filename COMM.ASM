;---------------------------+
; BDIFF - wspolne procedury |

INCLUDE .\INC\bdiff.inc

          .MODEL SMALL
          .CODE

PUBLIC Long2DecR,Long2HexR,Long2Dec
PUBLIC ConvDate,ConvTime,Conv2Hex
PUBLIC Write2Scr,CpyStr,TrueName
;PUBLIC ToLower
loc_0  DW  ?

;---------------------+
;we: cx=liczba bajtow |
;    dx=ofset bufora
Write2Scr PROC
          push bx
          mov bx,STDOUT
          mov ah,40h
          int 21h
          pop bx
          ret
Write2Scr ENDP

;----------------------+
;ds:si = cag zrodlowy  |
;ds:di = docelowy
CpyStr PROC
       LOCALS
       mov al,[si]
       or al,al
       jz @@x
       mov [di],al
       inc si
       inc di
       jmp CpyStr
  @@x:
       ret
CpyStr ENDP

;--------------------------------------------+
;we: ax = czas w formacie MBR                |
;    ds:di = wskaznik na ciag docelowy

ConvTime  PROC
          LOCALS
          mov cs:[loc_0],ax
          and ax,MASK hour
          mov cl,hour
          shr ax,cl
          call @@cv2d
          mov BYTE PTR [di],TSEP
          inc di
          and ax,MASK minute
          mov cl,minute
          shr ax,cl
          call @@cv2d
          mov BYTE PTR [di],TSEP
          inc di
          and ax,MASK second
          shl al,1
@@cv2d:
          aam
          or ax,3030h
          xchg al,ah
          mov [di],ax
          add di,2
          mov ax,cs:[loc_0] ;odtworz ax
          ret
ConvTime  ENDP

;-----------------------------+
;we: ax = data w formacie MBR |
;ds:di = wskaznik na cel
ConvDate  PROC
          LOCALS
          mov cs:[loc_0],ax
          and ax,MASK year
          mov cl,year
          shr ax,cl
          cmp ax,20d
          jb @@19c
          mov [di],'02'
          jmp @@20c
   @@19c:
          mov [di],'91'
   @@20c:
          add ax,1980d
          xor dx,dx
          mov cx,100d
          div cx
          mov al,dl
          add di,2
          call @@cv2d
          mov BYTE PTR [di],DSEP
          inc di
          and ax,MASK month
          mov cl,month
          shr ax,cl
          call @@cv2d
          mov BYTE PTR [di],DSEP
          inc di
          and ax,MASK day
@@cv2d:
          aam
          or ax,3030h
          xchg al,ah
          mov [di],ax
          add di,2
          mov ax,cs:[loc_0]
          ret
ConvDate  ENDP

;----------------------------------+
;konwertuj bajt w AL na ciag ascii |
;we: al = bajt
;    ds:di = wsk. na bufor
Conv2Hex  PROC
          LOCALS
          push ax cx
          xor ah,ah
          mov cl,4
          shl ax,cl
          shr al,cl
          mov cx,2
    @@cv:
          xchg al,ah
          and al,0fh  ;konwersja do ascii
          cmp al,10   ;           .
          sbb al,69h  ;     .
          das         ; .
          loop @@cv  ;x2
          xchg ah,al
          mov [di],ax
          pop cx ax
          ret
Conv2Hex  ENDP

;-----------------------------------+
;konwertuj podwojne slowo w DX:AX   |
;do dziesietnego stringa (rev.dir.)
;we: dx:ax = wartosc do konwersji
;    ds:di = wsk. na koniec bufora
;wy: ds:di = pierwszy bajt bufora
Long2DecR PROC
          LOCALS
          push ax bx cx dx
@@cv:
          mov cx,ax
          mov ax,dx
          xor dx,dx
          DIVAX 10
          mov bx,ax
          mov ax,cx
          DIVAX 10
          or dl,30h
          mov [di],dl
          mov dx,bx
          dec di
          or dx,dx
          jne @@cv
          or ax,ax
          jne @@cv
          inc di ;*
          pop dx cx bx ax
          ret
Long2DecR ENDP

;--------------------------------------+
;konwertuj podw. slowo w DX:AX         |
;na ciag cyfr hex. w ascii (rev.dir)
;we: dx:ax = wartosc do konwersji
;    ds:di = wsk. na koniec bufora
;wy: ds:di = wsk. na poczatek bufora
Long2HexR PROC
          LOCALS
          push ax bx cx dx si
@@cv:
          mov cx,ax
          mov ax,dx
          xor dx,dx
          DIVAX 16
          mov bx,ax
          mov ax,cx
          DIVAX 16
          add dl,'0'
          cmp dl,'9'
          jbe @@hx
          add dl,7 ;cyfry hex. > 9
    @@hx:
          mov [di],dl
          mov dx,bx
          dec di
          or dx,dx
          jne @@cv
          or ax,ax
          jne @@cv
          inc di ;*
          pop si dx cx bx ax
          ret
Long2HexR ENDP

;----------------------------------+
;konwertuj podwojne slowo w DX:AX  |
;do ciagu dec. w ascii
;we: ds:di = wsk.na bufor docelow.
Long2Dec PROC
         LOCALS
         push ax bx dx bp
         mov si,di
         mov bx,10
         xor cx,cx
         cmp dx,0
         jne @@cv
         cmp ax,0
         jne @@cv
         mov BYTE PTR [di],'0'
         inc di
         jmp @@ex
@@cv:
         push ax
         mov ax,dx
         xor dx,dx
         div bx
         mov bp,ax
         pop ax
         div bx
         push dx
         inc cx
         mov dx,bp
         or dx,dx
         jne @@cv
         or ax,ax
         jne @@cv
@@fb:
         pop ax
         or al,'0'
         mov [di],al
         inc di
         loop @@fb
@@ex:
         mov cx,di
         sub cx,si
         pop bp dx bx ax
         ret
Long2Dec ENDP

;---------------------------------------------+
;Zamien filespec na truename                  |
;we: ds:si = wskaznik na filespec i truename
;            (ten sam bufor)
;wy: nie ma
TrueName PROC
         push es
         mov ax,@DATA
         mov es,ax
         mov di,si
         mov ah,60h
         int 21h
         pop es
         ret
TrueName ENDP

COMMENT #
;-------------------------------------+
;Zamien na male litery                |
;we: ds:di = wskaznik na ciag ascii
;            !zakonczony zerem!
;wy: nie ma
ToLower  PROC
         LOCALS
         push cx si
@@tl:
         cmp BYTE PTR [si],0 ;null
         jz @@ex
         cmp BYTE PTR [si],'A'
         jb @@skip
         cmp BYTE PTR [si],'Z'
         ja @@skip
         or BYTE PTR [si],20h
@@skip:
         inc si
         jmp @@tl
@@ex:
         pop si cx
         ret
ToLower  ENDP
#
         END
