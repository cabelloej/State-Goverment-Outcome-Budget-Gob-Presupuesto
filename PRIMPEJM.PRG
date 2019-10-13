SELECT 1
USE PRCTAS INDEX PRCTAS1

@ 4,00 clear        to 18,77
@ 4,00              to 18,77
STORE "  "          TO WTIPO
STORE "N"           TO WRESUMIDO
STORE MONTH(DATE()) TO WALMES
@ 06,01 say "A¥O      :"
@ 08,01 say "ORIGEN   :"
@ 10,01 say "PARTIDA  :"
@ 12,01 say "RESUMIDO?:"
@ 14,01 say "AL MES   :"
@ 06,12 GET WPREANO
@ 08,12 GET WPREORI
@ 10,12 GET WPARTID PICTURE "#.##"
@ 12,12 GET WRESUMIDO
@ 14,12 GET WALMES  PICTURE "##"
READ
IF READKEY() = 12 .OR. READKEY() = 268
   CLOSE DATA
   CLOSE INDEX
   RETURN
ENDIF
IF WALMES<1.OR.WALMES>12
   STORE "ERROR EN MES, VERIFIQUE" TO MES
   DO AVISO WITH MES
   CLOSE DATA
   CLOSE INDEX
   RETURN
ENDIF
STORE ALLTRIM(STR(WALMES,2)) TO WMESSTR
store "SELECCIONE: (I)MPRESORA, (S)ALIR" TO TEX
STORE "IS" TO WCH
DO PREGUNTA
STORE WCH TO WSALIDA
IF WSALIDA = "S"
   RETURN
ENDIF
IF WSALIDA = "I"
   SET DEVI TO PRINT
   *SET PRINT TO EDUARDO.TXT
   STORE 55 TO FINAL
   STORE 132 TO WCADENA
ELSE
   SET DEVI TO SCRE
   STORE 18 TO FINAL
   STORE 80 TO WCADENA
ENDIF
select PRCTAS
go top
store 100 to wline
store 0 to wpage
do while .not. eof() 
   IF WPREANO <> SPACE(2) .AND. WPREANO <> PREANO
      SELECT 1
      SKIP
      LOOP
   ENDIF
   IF WPREORI <> SPACE(3) .AND. WPREORI <> PREORI
      SELECT 1
      SKIP
      LOOP
   ENDIF
   IF WPARTID <> "    " .AND. WPARTID <> PARTID
      SELECT 1
      SKIP
      LOOP
   ENDIF
   STORE SPACE(18) TO WCUENTA0
   DO ARMACOD0
   IF WRESUMIDO="S".AND.LEN(ALLTRIM(WCUENTA0))=18
      SELECT 1
      SKIP
      LOOP
   ENDIF

   store wline + 1 to wline
   if wline > FINAL
      STORE WPAGE + 1 TO WPAGE
      if wpage > 1 .AND. WSALIDA = "M" 
         store "SELECCIONE: (C)ONTINUAR, (S)ALIR" TO tex
         STORE "CS" TO WCH
         DO PREGUNTA
         IF WCH = "S"
            exit
         ENDIF
      endif
      @ 00,0 clear
      @ 01,0 SAY CHR(18)
      @ 01,0 say CHR(14)+rtrim(qqww)
      @ 01,Wcadena-16 say "FECHA :"+DTOC(DATE())
      @ 02,0 say "EJECUCION PRESUPUESTARIA AL MES :"+STR(WALMES,2)
      @ 02,WCADENA-16 SAY "PAGINA:"+STR(WPAGE,3)
      @ 04,0 SAY "A¥O:"+WPREANO+"  ORIGEN:"+WPREORI
      @ 05,0 SAY CHR(15)
      @ 05,0 SAY;
"                                              +-----------------------------------------------------------+-----------------------------------------------------------+-----------------------------------------------------------+"
      @ 06,0 SAY;
"                                              |                       M E N S U A L                       |                      A C U M U L A D A                    |                         A N U A L                         |"
      @ 07,0 SAY;
"+---------------------------------------------+--------------+--------------+--------------+--------------+--------------+--------------+--------------+--------------+--------------+--------------+--------------+--------------+"
      @ 08,0 SAY;
"|CODIGO DE LA CUENTA                          |  PRESUPUESTO |    PAGOS     | COMPROMISOS  |DISPONIBILIDAD| PRESUPUESTO  |     PAGOS    | COMPROMISOS  |DISPONIBILIDAD| PRESUPUESTO  |    PAGOS     | COMPROMISOS  |DISPONIBILIDAD|"
      @ 09,0 SAY;
"|DESCRIPCION DE LA CUENTA                     |  MODIFICADO  |              |  POR PAGAR   |              | MODIFICADO   |              |  POR PAGAR   |              | MODIFICADO   |              |  POR PAGAR   |              |"
      @ 10,0 SAY;
"+---------------------------------------------+--------------+--------------+--------------+--------------+--------------+--------------+--------------+--------------+--------------+--------------+--------------+--------------+"
      STORE 11 TO WLINE
   ENDIF
   @ WLINE,01 SAY PARTID
   @ WLINE,06 SAY GENERI
   @ WLINE,09 SAY ESPECI
   @ WLINE,12 SAY SUBESP
   @ WLINE,15 SAY ORDINA
   store wline+1 to wline
   @ wline,01 say descri1
   if descri2 <> space(44)
      store wline+1 to wline
      @ wline,01 say descri2
   endif
   if descri3 <> space(44)
      store wline+1 to wline
      @ wline,01 say descri3
   endif
   if descri4 <> space(44)
      store wline+1 to wline
      @ wline,01 say descri4
   endif
   store 0 to wtrashas,wincrhas,wdismhas,wcomphas,wpagahas,wdosahas
   store 0 to wtrasmes,wincrmes,wdismmes,wcompmes,wpagames,wdosames
   do calcta
   do caldosavo
   store (ORIG/12)          + ((WTRASHAS+WINCRHAS-WDISMHAS)/WALMES) to wmodimes
   store ((ORIG/12)*WALMES) +  (WTRASHAS+WINCRHAS-WDISMHAS)         to wmodihas
   store ORIG+TRAS+INCR-DISM                                        to wmoditot

   @ WLINE,047  SAY WMODIMES                picture "###########.##"
   @ WLINE,062  SAY WPAGAMES                picture "###########.##"
   @ WLINE,077  SAY WCOMPMES-WPAGAMES       picture "###########.##"
   @ WLINE,092  SAY WMODIMES-WCOMPMES       picture "###########.##"

   @ WLINE,107  SAY WMODIHAS                picture "###########.##"
   @ WLINE,122  SAY WPAGAHAS                picture "###########.##"
   @ WLINE,137  SAY WCOMPHAS-WPAGAHAS       picture "###########.##"
   @ WLINE,152  SAY WMODIHAS-WCOMPHAS       picture "###########.##"

   @ WLINE,167  SAY WMODITOT                picture "###########.##"
   @ WLINE,182  SAY PAGA                    picture "###########.##"
   @ WLINE,197  SAY COMP-PAGA               picture "###########.##"
   @ WLINE,212  SAY WMODITOT-COMP           picture "###########.##"
   store wline +1 to wline
   SKIP
ENDDO
IF WSALIDA = "M"
   store "OPRIMA <ENTER> PARA SALIR" TO MES
   DO AVISO WITH MES
ELSE
   SET DEVI TO SCRE
   EJECT
ENDIF
CLOSE DATA
CLOSE INDEX
RETURN
***********
PROC CALCTA
***********
STORE "TRAS" TO WCAMPO
DO CALCAMPO
STORE "INCR" TO WCAMPO
DO CALCAMPO
STORE "DISM" TO WCAMPO
DO CALCAMPO
STORE "COMP" TO WCAMPO
DO CALCAMPO
STORE "PAGA" TO WCAMPO
DO CALCAMPO
RETURN
*************
PROC CALCAMPO
*************
STORE 0             TO WCONT
STORE "W"+WCAMPO+"MES"  TO WENMES
STORE "W"+WCAMPO+"HAS"  TO WACUM
DO WHILE WCONT<WALMES
   STORE WCONT+1 TO WCONT
   STORE ALLTRIM(STR(WCONT,2))  TO WCONTSTR
   STORE WCAMPO+WCONTSTR        TO WCAMPOMES
   STORE &WCAMPOMES             TO &WENMES
   STORE &WACUM+&WCAMPOMES      TO &WACUM
ENDDO
RETURN
**************
PROC CALDOSAVO
**************
STORE 0             TO WCONT
DO WHILE WCONT<WALMES
   STORE WCONT+1 TO WCONT
   STORE ALLTRIM(STR(WCONT,2))  TO WCONTSTR
   STORE "TRAS"+WCONTSTR        TO WTRASDOS
   STORE "INCR"+WCONTSTR        TO WINCRDOS
   STORE "DISM"+WCONTSTR        TO WDISMDOS
   STORE (ORIG+&WTRASDOS+&WINCRDOS-&WDISMDOS)/12 TO WDOSAMES
   STORE WDOSAHAS+WDOSAMES      TO WDOSAHAS
ENDDO
RETURN




