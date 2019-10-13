SELECT 4
USE PRPAGA INDEX PRPAGA1,PRPAGA2
SELECT 7
USE PRBENEF  INDEX PRBENEF1

@ 04,00 CLEAR TO 18,40
@ 04,00       TO 18,40
@ 04,10 SAY " PAGOS "
@ 06,01 SAY "A¥O       :"
@ 08,01 SAY "ORIGEN    :"
@ 10,01 SAY "PARTIDA   :"
@ 12,01 SAY "DESDE     :"
@ 14,01 SAY "HASTA     :"
@ 16,01 SAY "COMPROMISO:"

store DATE()    to WDESDE
store DATE()    to WHASTA
store space(12) to wcontrat
store 0 to wtotinf

@ 06, 13 GET WPREANO
@ 08, 13 GET WPREORI
@ 10,12 GET WPARTID
@ 10,17 GET WGENERI
@ 10,20 GET WESPECI
@ 10,23 GET WSUBESP
@ 10,26 GET WORDINA
@ 12, 13 GET WDESDE
@ 14, 13 GET WHASTA
@ 16, 13 GET WCONTRAT
READ
IF LASTKEY()=27
   CLOSE DATA
   CLOSE INDEX
   RETURN
ENDIF
IF WDESDE>WHASTA
   STORE "ERROR EN FECHAS, VERIFIQUE" TO MES
   DO AVISO WITH MES
   CLOSE DATA
   CLOSE INDEX
   RETURN
ENDIF

store "SELECCIONE LA SALIDA: (M)ONITOR, (I)MPRESORA, (S)ALIR" TO TEX
STORE "MIS" TO WCH
DO PREGUNTA
STORE WCH TO WSALIDA
IF WSALIDA = "S"
   CLOSE DATA
   CLOSE INDEX
   RETURN
ENDIF
IF WSALIDA = "I"
   SET DEVI TO PRINT
   STORE 55 TO FINAL
   STORE 80 TO WCADENA
ELSE
   SET DEVI TO SCRE
   STORE 18 TO FINAL
   STORE 80 TO WCADENA
ENDIF
select PRPAGA
go top
store 100 to wline
store 0 to wpage
do while .not. eof()
   if wpreano <> space(2) .and. wpreano <> substr(codigopre,1,2)
      select 4
      skip
      loop
   endif
   if wpreori <> space(3) .and. wpreori <> substr(codigopre,3,3)
      select 4
      skip
      loop
   endif
   if wpartid <> space(4) .and. wpartid <> substr(codigopre,6,4)
      select 4
      skip
      loop
   endif
   if wgeneri <> space(2) .and. wgeneri <> substr(codigopre,10,2)
      select 4
      skip
      loop
   endif
   if wespeci <> space(2) .and. wespeci <> substr(codigopre,12,2)
      select 4
      skip
      loop
   endif
   if wsubesp <> space(2) .and. wsubesp <> substr(codigopre,14,2)
      select 4
      skip
      loop
   endif
   if wordina <> space(3) .and. wordina <> substr(codigopre,16,3)
      select 4
      skip
      loop
   endif
   IF WCONTRAT <> SPACE(12) .AND. WCONTRAT <> CONTRATO
      SELECT 4
      SKIP
      LOOP
   ENDIF 
   IF WDESDE<>CTOD("  -  -    ").AND.FECHAPAGA<WDESDE
      SELECT PRPAGA
      SKIP
      LOOP
   ENDIF
   IF WHASTA<>CTOD("  -  -    ").AND.FECHAPAGA>WHASTA
      SELECT PRPAGA
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
      @ 00,00 clear
      @ 01,00 SAY rtrim(qqww)
      @ 01,Wcadena-16 say "FECHA :"+DTOC(DATE())
      @ 02,00 SAY "PAGOS"
      @ 02,WCADENA-16 SAY "PAGINA:"+STR(WPAGE,3)
      @ 03,00 SAY "A¥O: "+WPREANO+" ORIGEN: "+WPREORI

      @ 05,00 SAY "+------------------+------------+------------+----------+-----------------+"
      @ 06,00 SAY "|NUMERO DE CUENTA  |COMPROMISO  |RECIBO      |FECHA     |     MONTO PAGADO|"
      @ 07,00 SAY "+------------------+------------+------------+----------+-----------------+"
      store 08 to wline
   ENDIF
   @ WLINE,01 SAY SUBSTR(CODIGOPRE,06,4)+"-"
   @ WLINE,06 SAY SUBSTR(CODIGOPRE,10,2)+"-"
   @ WLINE,09 SAY SUBSTR(CODIGOPRE,12,2)+"-"
   @ WLINE,12 SAY SUBSTR(CODIGOPRE,14,2)+"-"
   @ WLINE,15 SAY SUBSTR(CODIGOPRE,16,3)
   @ WLINE,20 SAY CONTRATO
   @ WLINE,33 SAY RECIBO
   @ WLINE,46 SAY FECHAPAGA
   @ WLINE,56 SAY MONTOPAGA PICTURE "###,###,###,###.##"
   store wtotinf+montopaga to wtotinf
   SKIP
ENDDO
store wline+2 to wline
@ wline,0 say "TOTAL REPORTE:"
@ WLINE,56 SAY WTOTINF PICT "###,###,###,###.##"
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
