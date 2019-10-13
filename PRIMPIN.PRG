SELECT 1
USE PRCTAS   INDEX PRCTAS1
SELECT 2
USE PRPARTI  INDEX PRPARTI
SELECT 3
USE PRUNID   INDEX PRUNID
SELECT 4
USE PRBENEF  INDEX PRBENEF1
SELECT 5
USE PRSOPOR  INDEX PRSOPOR
SELECT 6
USE PRINCRE  INDEX PRINCRE
@ 4,00 clear to 10,40
@ 4,00       to 10,40
@ 4,10 SAY " INCREMENTOS "
@ 06,01 say "A¥O      :"
@ 08,01 say "ORIGEN   :"
@ 06,12 GET WPREANO
@ 08,12 GET WPREORI
READ
IF READKEY() = 12 .OR. READKEY() = 268
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
   STORE 132 TO WCADENA
ELSE
   SET DEVI TO SCRE
   STORE 18 TO FINAL
   STORE 80 TO WCADENA
ENDIF

STORE WPREANO+WPREORI TO WCLAVE
IF LEN(RTRIM(LTRIM(WCLAVE))) <> 5
   STORE "LA SELECCION DE CODIGOS DEL INCREMENTO ES INVALIDA. OPRIMA <ENTER>" TO MES
   DO AVISO WITH MES
   CLOSE DATA
   CLOSE INDEX
   RETURN
ENDIF
SELECT PRINCRE
IF WCLAVE = SPACE(5)
   *** INICIO ES EL TOPE
   GO TOP
ELSE
   FIND &WCLAVE
   IF EOF()
      STORE "LA SELECCION DE CODIGOS DEL PLAN DE CUENTAS EN INVALIDA. OPRIMA <ENTER>" TO MES
      DO AVISO WITH MES
      CLOSE DATA
      CLOSE INDEX
      RETURN
   ENDIF 
ENDIF
store 100 to wline
store 0 to wpage
STORE 0 TO WTOTINF
do while .not. eof() 
   IF WPREANO <> SPACE(2) .AND. PREANO <> WPREANO
      SELECT PRINCRE
      SKIP
      LOOP
   ENDIF   
   IF WPREORI <> SPACE(3) .AND. PREORI <> WPREORI
      SELECT PRINCRE
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
      @ 1,0 say rtrim(qqww)
      @ 1,Wcadena-16 say "FECHA :"+DTOC(DATE())
      @ 2,0 say "INCREMENTOS AL PRESUPUESTO ORIGINAL"
      @ 2,WCADENA-16 SAY "PAGINA:"+STR(WPAGE,3)
      @ 3,0 SAY "A"+CHR(165)+"O:"+WPREANO+" ORIGEN:"+WPREORI
      @ 5,0 SAY "----+--+--+--+---+--------------------------------------------+-----------------"
      @ 6,0 SAY "PART|GE|ES|SE|ORD|CONCEP DEL GASTO                            |RECURSO  ASIGNADO"
      @ 7,0 SAY "----+--+--+--+---+--------------------------------------------+-----------------"
      STORE 8 TO WLINE
   ENDIF
   @ WLINE,00 SAY PARTID
   @ WLINE,05 SAY GENERI
   @ WLINE,08 SAY ESPECI
   @ WLINE,11 SAY SUBESP
   @ WLINE,14 SAY ORDINA
   STORE SPACE(18) TO WCTAINCRE
   DO ARMAINC
   SELECT PRCTAS
   FIND &WCTAINCRE
   IF EOF()
      STORE "NO REG.EN PLAN DE CTAS." TO WDESCRI1
      STORE SPACE(25) TO WDESCRI2,WDESCRI3,WDESCRI4
   ELSE
      store descri1 to wdescri1
      store descri2 to wdescri2
      store descri3 to wdescri3
      store descri4 to wdescri4
   ENDIF
   SELECT PRINCRE
   @ wline,18 say wdescri1
   if wdescri2 <> space(30)
      store wline+1 to wline
      @ wline,18 say wdescri2
   endif
   if wdescri3 <> space(30)
      store wline+1 to wline
      @ wline,18 say wdescri3
   endif
   if wdescri4 <> space(30)
      store wline+1 to wline
      @ wline,18 say wdescri4
   endif
   @ WLINE,63 SAY MONTO picture "##,###,###,###.##"
   STORE WTOTINF+MONTO TO WTOTINF
   store wline +1 to wline
   @ wline,0 say replicate("-",WCADENA)
   SKIP
ENDDO
store wline +1 to wline
@ WLINE,18 SAY "T O T A L   I N F O R M E :"
@ WLINE,63 SAY WTOTINF picture "##,###,###,###.##"
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
