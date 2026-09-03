;--- BDIFF.INC  ---

VER    EQU <'0.5'>
PLVL   EQU <'.0'>
LMOD   EQU <'.2609'>
ENDL   EQU 13,10
TSEP   EQU ':'
DSEP   EQU '-'
BLEN   EQU 128d ;rozmiar bufora
MAXD   EQU 0ffffh ;limit programu dla znalezionych roznic
STDOUT EQU 1
COMPDT EQU VER,PLVL,LMOD

DATEREC RECORD year:7,month:4,day:5
TIMEREC RECORD hour:5,minute:6,second:5
FL      RECORD f0:1,f1:1,f2:1

DLIM  UNION
 wMax DW ?
 bMax DB ?
DLIM  ENDS

CNT   UNION
dCnt  DD ?
       STRUC
 wCntL DW ?
 wCntH DW ?
       ENDS
bCnt  DB ?
CNT   ENDS

SIZEF STRUC
  fsL DW ?
  fsH DW ?
SIZEF ENDS

DIVAX MACRO val
      IFB <val>
       .ERR 'There is no divisor.'
        ELSEIF val EQ 0
        .ERR 'The divisor cannot be zero.'
      ENDIF
      push bx
      mov bx,val
      div bx
      pop bx
      ENDM
