;--------------------------------------+
;Compare:PROC                          |
;porownaj i wypelnij formularz raportu

INCLUDE INC\head.inc

        .MODEL SMALL
        .CODE

EXTRN  Conv2Hex:PROC, Write2Scr:PROC
EXTRN  vProc:WORD
PUBLIC Compare

Compare PROC ;we: cx=ilosc bajtow
        LOCALS
        push bx
        mov bx,[diffCnt.wCntL]
comp:
        push cx
        mov cx,2
  @@gb:
        lodsb
        xchg ah,al
        xchg di,si
        loop @@gb
        pop cx
        cmp ah,al
        je @@ev
        call DiffSrv ; al=f1, ah=f2, proc. musi odtworzyc cx
        inc bx
        jc @@prt ;- limit programu dla znalezionych roznic
        cmp [maxDiff.wMax],bx
        je @@ust ;- limit uzytkownika dla znalezionych roznic
  @@ev:
        add [currOffs.wCntL],1
        adc [currOffs.wCntH],0
        loop comp
        xor ax,ax
        clc
        jmp @@ret
@@prt:
        mov ax,2
        stc
        jmp @@ret
@@ust:
        mov ax,1
        stc
@@ret:
        mov [diffCnt.wCntL],bx
        pop bx
        ret
Compare ENDP

DiffSrv PROC
        LOCALS
        push cx si di
        mov di,OFFSET _b1
        call Conv2Hex
        xchg al,ah
        mov di,OFFSET _b2
        call Conv2Hex
        mov ax,[currOffs.wCntL]
        mov dx,[currOffs.wCntH]
        mov di,OFFSET _offs+9
        call vProc
        mov cx,FORM0L
        mov dx,OFFSET form0
        call Write2Scr
        pop di si cx
        ret
DiffSrv ENDP

        .DATA

EXTRN _offs,_b1,_b2,optH:WORD
EXTRN form0
EXTRN maxDiff:CNT,currOffs:CNT,diffCnt:CNT
EXTRN FORM0L:ABS:WORD

        END
