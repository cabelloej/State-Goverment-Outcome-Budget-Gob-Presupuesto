
SELECT 1
USE PRCTAS INDEX PRCTAS1
@ 5,35 clear to 08,60
@ 5,35       to 08,60
@ 5,40 SAY "FORMULACION"
@ 06,36 SAY "A¥O      :"
@ 07,36 SAY "ORIGEN   :"
@ 06,47 GET WPREANO
@ 07,47 GET WPREORI
READ
IF READKEY() = 12 .OR. READKEY() = 268
   CLOSE DATA
   CLOSE INDEX
   RETURN
ENDIF
STORE WPREANO+WPREORI TO WCLAVE
IF LEN(RTRIM(LTRIM(WCLAVE))) <> 5
   STORE "SELECCIONE A¥O Y ORIGEN DEL PLAN DE CUENTAS" TO MES
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
   STORE 40 TO FINAL
   STORE 80 TO WCADENA
ELSE
   SET DEVI TO SCRE
   STORE 18 TO FINAL
   STORE 80 TO WCADENA
ENDIF
select PRCTAS
go top
IF WCLAVE = SPACE(5)
   *** INICIO ES EL TOPE
ELSE
   FIND &WCLAVE
   IF EOF()
      STORE "LA SELECCION DE CLASIFICADOR DE PRESUPUESTOS ES INVALIDA" TO MES
      DO AVISO WITH MES
      CLOSE DATA
      CLOSE INDEX
      RETURN
   ENDIF 
ENDIF
store 100 to wline
store 0 to wpage
do while .not. eof() 
   IF WPREANO <> SPACE(2) .AND. PREANO <> WPREANO
      EXIT
   ENDIF   
   IF WPREORI <> SPACE(3) .AND. PREORI <> WPREORI
      EXIT
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
      @ 1,0 say chr(14)+(qqww)
      @ 2,Wcadena-16 say "FECHA :"+DTOC(DATE())
      @ 2,0 say "PARTIDAS DEL PRESUPUESTO"
      @ 3,WCADENA-16 SAY "PAGINA:"+STR(WPAGE,3)
      @ 3,0 SAY "A¥O:"+WPREANO+" ORIGEN:"+WPREORI
      *@ 5,0 SAY CHR(15)
      @ 5,0 SAY "+----+--+--+--+---+----------------------------------------+-------------------+"
      @ 6,0 SAY "|PART|GE|ES|SE|ORD|CONCEPTO DEL GASTO                      |           RECURSOS|"
      @ 7,0 SAY "+----+--+--+--+---+----------------------------------------+-------------------+"
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
   @ wline,19 say wdescri1
   if wdescri2 <> space(30)
      store wline+1 to wline
      @ wline,19 say wdescri2
   endif
   if wdescri3 <> space(30)
      store wline+1 to wline
      @ wline,19 say wdescri3
   endif
   if wdescri4 <> space(30)
      store wline+1 to wline
      @ wline,19 say wdescri4
   endif
   @ WLINE,63 SAY orig+incr+tras-dism picture "##,###,###,###.##"
   store wline +1 to wline
*  @ wline,0 say replicate("-",WCADENA)
   SKIP
ENDDO
IF WSALIDA = "M"
   store "OPRIMA <ENTER> PARA SALIR" TO MES
   DO AVISO WITH MES
ELSE
   SET DEVI TO SCRE
  * EJECT
ENDIF
CLOSE DATA
CLOSE INDEX
RETURN
