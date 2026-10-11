;--- BDIFF.INC
;    stale, typy, makra ---

VER    EQU '1.0'
ENDL   EQU 13,10
TSEP   EQU ':'
DSEP   EQU '-'
BLEN   EQU 128d ;rozmiar bufora
TNBL   EQU 128d
MAXD   EQU 0ffffh ;limit programu dla znalezionych roznic
STDOUT EQU 1

DATEREC RECORD year:7,month:4,day:5
TIMEREC RECORD hour:5,minute:6,second:5
FL      RECORD f0:1,f1:1,f2:1

DLIM  UNION
 wMax DW ?
 bMax DB ?
DLIM  ENDS

SIZEF STRUC
  fsL DW ?
  fsH DW ?
SIZEF ENDS

CNT   UNION
dCnt  DD ?
       STRUC
 wCntL DW ?
 wCntH DW ?
       ENDS
bCnt  DB ?
CNT   ENDS

DIVAX MACRO val
       IFB <val>
        .ERR 'Brak dzielnika.'
        EXITM ;nie kontynuuj po bledach
         ELSEIF val EQ 0
         .ERR 'Dzielenie przez 0'
         EXITM
       ENDIF
      push bx
      mov bx,val
      div bx
      pop bx
      ENDM

CURSOR MACRO cmd,mem
HIDE  = 0
SHOW  = 1
SHAPE = 2
        IFB <cmd>
        .ERR 'Nie podano opcji.'
         EXITM
        ENDIF
        IF cmd EQ 0
         mov ah,1
         mov cx,2020h
         int 10h
        ENDIF
        IF cmd EQ 1
         IFB <mem>
          .ERR 'Brak danej mem.'
          EXITM
         ENDIF
         push ax ;errorlevel
         mov ah,1
         mov cx,mem
         int 10h
         pop ax
        ENDIF
        IF cmd EQ 2
         mov ah,3
         mov bh,0
         int 10h
        ENDIF
       ENDM
