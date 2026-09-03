COMMENT #-------------------------------------------------------------------+

  BDIFF v0.5 *** (c)1996 'marikaz'
  Porownaj bimarnie dwa pliki i pokaz roznice.
  Compare the two files as binary files and print out the differences.

  Skladnia:
  BDIFF.EXE [/d] [/b[=]nn] [drive:][path]<file1> [drive:][path]<file2>

+-----------------------------------------------------------------/ F2509 /-#

INCLUDE .\INC\bdiff.inc
INCLUDE ..\..\_MAC\fileio.mac  ;obsl. plikow

        .MODEL SMALL
        .CODE

EXTRN  GetParam:PROC,Compare:PROC
EXTRN  ConvDate:PROC,ConvTime:PROC
EXTRN  Write2Scr:PROC,CpyStr:PROC
EXTRN  Long2HexR:PROC,Long2DecR:PROC
EXTRN  Long2Dec:PROC,TrueName:PROC
;EXTRN ToLower:PROC

PUBLIC vProc

        JUMPS
Start:
        call GetParam
        mov dx,@DATA
        mov ds,dx
        jc param_err
        mov bx,optD
        mov dx,cs:[vProc+bx]
        mov cs:[vProc],dx
        mov si,OFFSET fSpec1
        call TrueName
        ;call ToLower
        mov si,OFFSET fSpec2
        call Truename
        ;call ToLower
        FFIND fSpec1 ;FFIND (FINDFIRST) <fileSpec>,[fileAttribute]
        jc not_exists
        mov ah,2fh
        int 21h ;ES:BX -> DTA
        mov ax,es:[bx+18h]
        mov di,OFFSET _cd1
        call ConvDate
        mov ax,es:[bx+16h]
        mov di,OFFSET _ct1
        call ConvTime
        mov ax,es:[bx+1ah]
        mov [f1Size.fsL],ax
        mov dx,es:[bx+1ch]
        mov [f1Size.fsH],dx
        mov di,OFFSET _size1
        or ax,0
        jne f1snz
        or dx,0
        jz empty_file
f1snz:
        mov di,OFFSET _size1
        call Long2Dec

        FFIND fSpec2
        jc not_exists
        mov ax,es:[bx+18h]
        mov di,OFFSET _cd2
        call ConvDate
        mov ax,es:[bx+16h]
        mov di,OFFSET _ct2
        call ConvTime
        mov ax,es:[bx+1ah]
        mov [f2Size.fsL],ax
        mov dx,es:[bx+1ch]
        mov [f2Size.fsH],dx
        mov di,OFFSET _size2
        or ax,0
        jne f2snz
        or dx,0
        jz empty_file
f2snz:
        mov di,OFFSET _size2
        call Long2Dec
        mov si,OFFSET fspec1
        mov di,OFFSET _cspc1
        call CpyStr
        mov si,OFFSET fspec2
        mov di,OFFSET _cspc2
        call CpyStr
        mov dx,OFFSET rhead
        mov cx,RHEADL
        call Write2Scr
        mov dx,OFFSET file1
        mov cx,FILE1L
        call Write2Scr
        mov dx,OFFSET file2
        mov cx,FILE2L
        call Write2Scr
        mov dx,OFFSET dhead
        mov cx,DHEADL
        call Write2Scr
        ;---
        FOPEN fspec1,RE ;FOPEN <fileSpec>,[accessMode]
        jc err_file_io
        mov hTmp,ax
        FOPEN fspec2,RE
        jc err_file_io
        mov bx,ax
do:
        xchg bx,hTmp
        FREAD f1Buff,BLEN ;FREAD <buffer>,[fsize]
        jc err_file_io
        mov dx,ax
        cmp ax,0
        je eof
        xchg htmp,bx
        FREAD f2Buff,BLEN
        jc err_file_io
        cmp ax,0
        je eof

        mov cx,ax  ;dx=file1, ax=file2
        cmp dx,ax  ;roznica w rozmiarze? cmp al,'0'
        jae cmpr   ;ok?
        mov cx,dx
  cmpr:
        lea si,f1buff
        lea di,f2buff
        call Compare ;i: si=buf1,di=buf2 o: cy, ax=1 user lim.,ah=2 prg. lim.
        jnc do
eof:
        FCLOSE ;FCLOSE [handle]
        xchg bx,htmp
        FCLOSE
        mov bx,ax ;status w bx
        jmp messages
exit:
        mov ah,4ch
        int 21h

;-----/ komunikaty /---------
param_err:
        cmp al,4
        je cl_opt_b
        cmp al,3
        je cl_inv_path
        cmp al,2
        je cl_inv_arg

        mov dx,OFFSET rHead
        mov cx,RHEADL
        call Write2Scr
        mov dx,OFFSET hErrMsg
        mov cx,HEM
        call Write2Scr
        mov al,1
        jmp exit

messages:
        cmp [diffCnt.wCntL],0 ;przekrecony licznik?
        jne chk_sizes
        mov dx,OFFSET ndMsg
        mov cx,NDM
        call Write2Scr
        jmp exit ;???
chk_sizes:
        mov ax,[f1Size.fsL]
        mov dx,[f1Size.fsH]
        cmp [f2Size.fsL],ax
        jne dfs
        cmp [f2Size.fsH],dx
        jne dfs
        jmp chk_stat
   dfs:
        mov dx,OFFSET dsMsg
        mov cx,DSM
        call Write2Scr
chk_stat: ;ax=1 uzytkownik, ax=2 program
        cmp bx,2
        jne user_brk
        mov dx,OFFSET tmMsg
        mov cx,TMM
        call Write2Scr
user_brk:
        jmp exit

cl_opt_b:
        mov dx,OFFSET bErrMsg
        mov cx,BEM
        call Write2Scr
        mov al,4
        jmp exit

cl_inv_path:
        mov dx,OFFSET xErrMsg
        mov cx,XEM
        call Write2Scr
        jmp exit

cl_inv_arg:
        mov dx,OFFSET pErrMsg
        mov cx,PEM
        call Write2Scr
        jmp exit

empty_file:
        mov dx,OFFSET eErrMsg
        mov cx,EEM
        call Write2Scr
        mov al,2
        jmp exit

not_exists:
        mov dx,OFFSET sErrMsg
        mov cx,SEM
        call Write2Scr
        mov al,3
        jmp exit

err_file_io:
        mov dx,OFFSET fErrMsg
        mov cx,FEM
        call Write2Scr
        mov al,4
        jmp exit

        EVEN
vProc   DW Long2HexR,Long2DecR ;moze przeniesc

        .DATA

PUBLIC  fSpec1,fSpec2,optD
PUBLIC  _b1,_b2,form0,_offs,FORM0L
PUBLIC  maxDiff,currOffs,diffCnt,param

hTmp DW 1
optD DW 0

currOffs CNT  <0>
diffCnt  CNT  <0>
maxDiff  DLIM <?,-1> ;-1 jako znacznik
param    FL   <0,0,0> ;f0 rezerwowy...

fSpec1 DB 79 DUP(0),0
fSpec2 DB 79 DUP(0),0

INCLUDE .\INC\form.inc

IFDEF VDT
 DB 13,10,'Version ',COMPDT
ENDIF

f1Size SIZEF<>
f2Size SIZEF<>
f1Buff DB BLEN DUP(?)
f2Buff DB BLEN DUP(?)

        .STACK

        END Start
