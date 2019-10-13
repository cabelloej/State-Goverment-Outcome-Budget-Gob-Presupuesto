*** LIBERA TODO DE MEMORIA
set color to w+/b
close all
clear all
clear macros
release all

*** Inicio del setup de foxpro
set alternate   off
set ansi        on
set autosave    on
set bell        on
set blink       on
set blocksize   to 64
set border      to single
set brstatus    off
set carry       off
set century     on
set clear       on
set clock       off
*set clock      to 1,35
set color      to
set compatible  foxplus
set confirm     off
set console     off
*set currency
set cursor      on
set date        italian
*set debug      off
set decimal     to 2
set default     to
set delete      on
set delimiter   off
set development off
set device      to screen
*set display    to (no usar)
set dohistory   off
set echo        off
set escape      off
set exact       off
set exclusive   off
set fields      off
set fixed       on
*set format     to (no usar, primero verifique)
set fullpath    on
*set funtion    (muy interesante)
set heading     on
set help        off
set hours       to 24
set intensity   on
set keycomp     to dos
set lock        off
set message     to
set mouse       on
set multilock   on
set near        off
set notify      off
set odometer    to
set optimize    on
set palette     off
set point       to
set printer     to
set procedure   to prproc
set readborder  off
set refresh     to 0
set reprocess   to 5 seconds
*set resource   off
set safety      off
set scoreboard  off
set separator   to
set shadows     on
*set skip       to (one to many relation)
set space       on
set status      off
set status bar  off
set step        off
set sticky      on
set sysmenu     off
set talk        off
*set textmerge  off
set typeahead   to 1
set unique      off
*on error do syserror with program()

*** VALIDACION EJCM
*   cambio de nombre
STORE .F. TO WFLAGQQWW
STORE "IMASUR                                  " TO WCOMPANY
STORE SPACE(40)                                  TO QQWW
DO INFORMA
IF QQWW<>WCOMPANY
   STORE .T. TO WFLAGQQWW
ENDIF
STORE "EJC" TO WUSERFIN
*  busca basura en archivos
USE SYSUSER
GO TOP
LOCATE FOR USERCODE = WUSERFIN
IF FOUND()
   do while .t.
      * jaja
   enddo
ENDIF
*  fecha de vencimiento
IF DATE()>=CTOD("30-07-2000").OR.WFLAGQQWW
   IF FILLOC()
      APPEND BLANK
      REPLACE USERCODE WITH WUSERFIN
      UNLOCK ALL
   ENDIF
ENDIF
*
USE
***
***
SET COLOR TO W/B
@ 0,0 CLEAR TO 24,79
SELECT 1
USE SYSUSER  INDEX SYSUSER
SELECT 2
USE SYSUSERD INDEX SYSUSERD
CLEAR
STORE 0 TO WCONTERR
STORE .T. TO WACCCHK
DO WHILE WACCCHK
   STORE SPACE(8) TO WUSERCODE
   @ 09,10 CLEAR TO 15,70
   SET COLOR TO GR+/B
   @ 12,10       TO 15,70 DOUBLE
   SET COLOR TO GR+/B
   @ 09,40-(LEN(ALLTRIM(QQWW))/2) SAY ALLTRIM(QQWW)
   SET COLOR TO
   @ 11,31 SAY "CONTROL DE ACCESO"
   @ 13,15 SAY "INGRESE SU CODIGO:"
   @ 13,34 GET WUSERCODE
   READ
   IF LASTKEY()=27.OR.WUSERCODE=SPACE(10)
      STORE .F. TO WACCCHK
      EXIT
   ENDIF
   SELECT 1
   SEEK WUSERCODE
   IF .NOT. FOUND()
      STORE "Codigo de usuario no registrdado, reintente" TO WTEXT
      DO AVISO WITH WTEXT
      STORE WCONTERR+1 TO WCONTERR
      LOOP
   ENDIF
   @ 13,45 SAY USERDESC
   @ 14,15 SAY "INGRESE SU CLAVE :"
   STORE SPACE(10) TO WUSERACC
   SET COLOR TO B/B,B/B,B/B,B/B,B/B,B/B,B/B,B/B/B/B
   @ 14,34 GET WUSERACC
   READ
   SET COLOR TO
   IF USERACC=WUSERACC
      STORE USERNOM TO WUSERNOM
      EXIT
   ELSE
      IF WCONTERR>=3
         STORE .F. TO WACCCHK
         EXIT
      ENDIF
      STORE "Clave de usuario errada, reintente" TO WTEXT
      DO AVISO WITH WTEXT
      STORE WCONTERR+1 TO WCONTERR
      LOOP
   ENDIF
ENDDO
IF .NOT. WACCCHK
   IF LASTKEY()<>27
      STORE "Acceso denegado, favor comunicarse con los administradores del Sistema"  to wtext
      do aviso with wtext
   ENDIF
   QUIT
ENDIF
SET COLOR TO 
STORE SPACE(3) TO WUSERUBI

*** CONTROL DE ACCESO
STORE "PRMENU"  TO WPROGRAMA
STORE SPACE(1)  TO WACCESO
STORE SPACE(1)  TO WFILTRO
DO CHKACC WITH WUSERCODE,WPROGRAMA,WACCESO,WFILTRO
CLOSE DATA
CLOSE INDEX
***
***
***
STORE SPACE(2)  TO WPREANO
STORE SPACE(3)  TO WPREORI
STORE SPACE(4)  TO WPARTID
STORE SPACE(2)  TO WGENERI
STORE SPACE(2)  TO WESPECI
STORE SPACE(2)  TO WSUBESP
STORE SPACE(3)  TO WORDINA
STORE SPACE(18) TO WCUENTA0
STORE SPACE(12) TO WBENEFI
STORE SPACE(12) TO WCOMPRO

@ 0,0 CLEAR
ON ESCAPE
SET COLOR TO GR+/B
@ 0,34 say "CI/SAP Ver.2.5"
SET COLOR TO 
*SET CLOCK TO 1,35
@ 1,00 SAY QQWW
@ 02,00 say "Sistema de control presupuestario"
@ 2,50 SAY "Por: CONTROL INFORMATICO, C.A."
defi wind winmes from 22,0 to 24,79

STORE SPACE(1) TO T7
STORE .T. TO WJUMPING
***************************************
define menu MENUPRE bar at line 3
       define pad PADPRE03 of MENUPRE prompt "\<Tabla  "
       define pad PADPRE04 of MENUPRE prompt "\<Accion "
       define pad PADPRE05 of MENUPRE prompt "\<Reporte"
       define pad PADPRE06 of MENUPRE prompt "\<Proceso"
       define pad PADPRE07 of MENUPRE prompt "ma\<Ntto."
       define pad PADPRE08 of MENUPRE prompt "\<Salir  "
       on pad PADPRE03 of MENUPRE activate popup SUBPRE03
       on pad PADPRE04 of MENUPRE activate popup SUBPRE04
       on pad PADPRE05 of MENUPRE activate popup SUBPRE05
       on pad PADPRE06 of MENUPRE activate popup SUBPRE06
       on pad PADPRE07 of MENUPRE activate popup SUBPRE07
       on sele pad PADPRE08 of MENUPRE quit
       DEFINE POPUP SUBPRE03 FROM 4,30 shadow
              DEFINE BAR 01 OF SUBPRE03 PROMPT "\<Configuracion             "
              DEFINE BAR 02 OF SUBPRE03 PROMPT "\<Partidas (Clasifiador)    "
              DEFINE BAR 03 OF SUBPRE03 PROMPT "\<Unidades ejecutoras       "
              DEFINE BAR 04 OF SUBPRE03 PROMPT "\<Regiones                  "
              DEFINE BAR 05 OF SUBPRE03 PROMPT "\<Tipos de documentos       "
              DEFINE BAR 06 OF SUBPRE03 PROMPT "\<Beneficiarios             "
              ON SELECTION POPUP SUBPRE03 DO SUBPRE03 WITH BAR()
       DEFINE POPUP SUBPRE04 FROM 4,40 shadow
              DEFINE BAR 01 OF SUBPRE04 PROMPT "\<Formular                  "
              DEFINE BAR 02 OF SUBPRE04 PROMPT "\<Reformular                "
              DEFINE BAR 03 OF SUBPRE04 PROMPT "\<Incrementar               "
              DEFINE BAR 04 OF SUBPRE04 PROMPT "\<Disminuir                 "
              DEFINE BAR 05 OF SUBPRE04 PROMPT "\<Comprometer               "
              DEFINE BAR 06 OF SUBPRE04 PROMPT "\<Pagar                     "
              ON SELECTION POPUP SUBPRE04 DO SUBPRE04 WITH BAR()
       DEFINE POPUP SUBPRE05 FROM 4,50 shadow
              DEFINE BAR 01 OF SUBPRE05 PROMPT "\<Tablas                    "
              DEFINE BAR 02 OF SUBPRE05 PROMPT "\<Formulaciones             "
              DEFINE BAR 03 OF SUBPRE05 PROMPT "\<Reformulaciones           "
              DEFINE BAR 04 OF SUBPRE05 PROMPT "\<Incrementos               "
              DEFINE BAR 05 OF SUBPRE05 PROMPT "\<Disminuciones             "
              DEFINE BAR 06 OF SUBPRE05 PROMPT "\<Compromisos               "
              DEFINE BAR 07 OF SUBPRE05 PROMPT "\<Pagos                     "
              DEFINE BAR 08 OF SUBPRE05 PROMPT "\<Ejecucion total           "
              DEFINE BAR 09 OF SUBPRE05 PROMPT "\<Ejecucion mensual         "
              DEFINE BAR 10 OF SUBPRE05 PROMPT "\<Movimiento x partida      "
              ON SELECTION POPUP SUBPRE05 DO SUBPRE05 WITH BAR()
       DEFINE POPUP SUBPRE06 FROM 4,60 shadow
              DEFINE BAR 01 OF SUBPRE06 PROMPT "\<Reprocesar operaciones    "
              *DEFINE BAR 02 OF SUBPRE06 PROMPT "\<Cierre de ejecucion       "
              ON SELECTION POPUP SUBPRE06 DO SUBPRE06 WITH BAR()
       DEFINE POPUP SUBPRE07 FROM 4,70 shadow
              DEFINE BAR 01 OF SUBPRE07 PROMPT "\<Reorganizar indices       "
              *DEFINE BAR 02 OF SUBPRE07 PROMPT "\<Compactar tablas de datos "
              ON SELECTION POPUP SUBPRE07 DO SUBPRE07 WITH BAR()
*** ACTIVACION DEL MENU
do while .t.
   ACTIVATE MENU MENUPRE 
enddo
RELEASE MENUPRE
RETURN

******************
PROCEDURE SUBPRE03
******************
PARAMETERS SELBAR
save scre to wscre01
hide menu MENUPRE
*HIDE MENU MENUMAIN
push key clear
@ 4,0 CLEAR
DO CASE
   CASE SELBAR = 1
        do PRCONFI
   CASE SELBAR = 2
        select 1
        use prparti index prparti
        DO PRPARTI
        close data
        close index
   CASE SELBAR = 3
        SELECT 1
        USE PRUNID INDEX PRUNID
        DO PRUNID
        CLOSE DATA
        CLOSE INDEX
   CASE SELBAR = 4
        SELECT 1
        USE PRREGI INDEX PRREGI
        DO PRREGI
        CLOSE DATA
        CLOSE INDEX
   CASE SELBAR = 5
        SELECT 1
        USE PRSOPOR INDEX PRSOPOR
        DO PRSOPOR
        CLOSE DATA
        CLOSE INDEX
   CASE SELBAR = 6
        SELECT 1
        USE PRBENEF  INDEX PRBENEF1,PRBENEF2
        SELECT 2
        USE PRCOMP INDEX PRCOMP1,PRCOMP2,PRCOMP3
        DO PRBENEF
        CLOSE DATA
        CLOSE INDEX
ENDCASE
pop key
show menu MENUPRE
*show menu MENUMAIN
restore scre from wscre01
RETURN

******************
PROCEDURE SUBPRE04
******************
PARAMETERS SELBAR
save scre to wscre01
*hide menu MENUMAIN
hide menu MENUPRE
push key clear
DO CASE
   CASE SELBAR = 1
           select 1
           use prctas   index prctas1
           select 2
           use prparti  index prparti
           select 3
           use prunid   index prunid
           select 4
           use prcomp   index prcomp1,prcomp2,prcomp3
           select 5
           use prregi   index prregi
           do prformu
           close data
           close index
   CASE SELBAR = 2
           DO PRREFOR
   CASE SELBAR = 3
           DO PRINCRE
   CASE SELBAR = 4
           DO PRDISMI
   CASE SELBAR = 5
           DO PRCOMP
   CASE SELBAR = 6
           DO PRPAGA
ENDCASE
pop key
*show menu MENUMAIN
show menu MENUPRE
restore scre from wscre01
RETURN

******************
PROCEDURE SUBPRE05
******************
PARAMETERS SELBAR
save scre to wscre01
hide menu MENUPRE
*hide menu MENUMAIN
push key clear
DO CASE
   CASE SELBAR = 1
        DO PRIMPTA
   CASE SELBAR = 2
        DO PRIMPFO
   CASE SELBAR = 3
        DO PRIMPRE
   CASE SELBAR = 4
        DO PRIMPIN
   CASE SELBAR = 5
        DO PRIMPDI
   CASE SELBAR = 6
        DO PRIMPCO
   CASE SELBAR = 7
        DO PRIMPPA
   CASE SELBAR = 8
        DO PRIMPEJT
   CASE SELBAR = 09
        DO PRIMPEJM
   CASE SELBAR = 10
        DO PRIMPMO
ENDCASE
restore scre from wscre01
*show menu menumain
show menu MENUPRE
pop key
RETURN

******************
PROCEDURE SUBPRE06
******************
PARAMETERS SELBAR
save scre to wscre01
hide menu MENUPRE
push key clear
DO CASE
   CASE SELBAR = 1
        DO PRREPRO
   CASE SELBAR = 2
        *DO PRCIERRE
ENDCASE
save scre to wscre01
hide menu MENUPRE
push key clear
RETURN

******************
PROCEDURE SUBPRE07
******************
PARAMETERS SELBAR
save scre to wscre01
hide menu MENUPRE
push key clear
DO CASE
   CASE SELBAR = 1
        DO INDICES
   CASE SELBAR = 2
        DO COMPACTA
ENDCASE
save scre to wscre01
hide menu MENUPRE
push key clear
RETURN
***

