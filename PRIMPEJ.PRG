SELECT 1
USE PRCTAS INDEX PRCTAS1

@ 4,00 clear to 16,77
@ 4,00       to 16,77
STORE "  " TO WTIPO
@ 06,01 say "A¥O      :"
@ 08,01 say "ORIGEN   :"
@ 10,01 say "PARTIDA  :"
@ 06,12 GET WPREANO
@ 08,12 GET WPREORI
@ 10,12 GET WPARTID PICTURE "#.##"
READ
IF READKEY() = 12 .OR. READKEY() = 268
   CLOSE DATA
   CLOSE INDEX
   RETURN
ENDIF
store "SELECCIONE: (I)MPRESORA, (S)ALIR" TO TEX
STORE "IS" TO WCH
DO PREGUNTA
STORE WCH TO WSALIDA
IF WSALIDA = "S"
   RETURN
ENDIF
IF WSALIDA = "I"
   SET DEVI TO PRINT
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
      @ 0,0 clear
      @ 1,0 SAY CHR(18)
      @ 1,0 say rtrim(qqww)
      @ 1,Wcadena-16 say "FECHA :"+DTOC(DATE())
      @ 2,0 say "EJECUCION PRESUPUESTARIA"
      @ 2,WCADENA-16 SAY "PAGINA:"+STR(WPAGE,3)

      @ 4,0 SAY "A¥O:"+WPREANO+"  ORIGEN:"+WPREORI
      @ 5,0 SAY CHR(15)
      @ 5,0 SAY "+----+--+--+--+---+---------------------------------------------+--------------+--------------+--------------+--------------+--------------+--------------+--------------+"
      @ 6,0 SAY "|PART|GE|ES|SE|ORD|DESCRIPCION                                  |  PRE.ORIGINAL| REFORMULACION|  INCR.y DISM.|PRE.MODIFICADO|   COMPROMISOS|         PAGOS|    DISPONIBLE|"
      @ 7,0 SAY "+----+--+--+--+---+---------------------------------------------+--------------+--------------+--------------+--------------+--------------+--------------+--------------+"
      STORE 8 TO WLINE
   ENDIF
   @ WLINE,01 SAY PARTID
   @ WLINE,06 SAY GENERI
   @ WLINE,09 SAY ESPECI
   @ WLINE,12 SAY SUBESP
   @ WLINE,15 SAY ORDINA
   store descri1 to wdescri1
   store descri2 to wdescri2
   store descri3 to wdescri3
   store descri4 to wdescri4
   @ wline,20 say wdescri1
   if wdescri2 <> space(44)
      store wline+1 to wline
      @ wline,20 say wdescri2
   endif
   if wdescri3 <> space(44)
      store wline+1 to wline
      @ wline,20 say wdescri3
   endif
   if wdescri4 <> space(44)
      store wline+1 to wline
      @ wline,20 say wdescri4
   endif
   @ WLINE,65   SAY ORIG                picture "###########.##"
   @ WLINE,80   SAY TRAS                picture "###########.##"
   @ WLINE,95   SAY INCR-DISM           picture "###########.##"
   @ WLINE,110  SAY ORIG+TRAS+INCR-DISM picture "###########.##"
   @ WLINE,125  SAY COMP                picture "###########.##"
   @ WLINE,140  SAY PAGA                PICTURE "###########.##"
   @ WLINE,155  SAY (ORIG+TRAS+INCR-DISM) - (COMP) picture "###########.##"
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

