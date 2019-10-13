SELECT 1
USE PRSOPOR INDEX PRSOPOR
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
   STORE 100 TO WCADENA
ELSE
   SET DEVI TO SCRE
   STORE 18 TO FINAL
   STORE 80 TO WCADENA
ENDIF
select PRSOPOR
go top
store 100 to wline
store 0 to wpage
do while .not. eof() 
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
      @ 2,Wcadena-18 say "FECHA :"+DTOC(DATE())
      @ 2,0 say "DOCUMENTOS QUE SOPORTAN LAS OPERACIONES"
      @ 3,WCADENA-18 SAY "PAGINA:"+STR(WPAGE,3)
      @ 5,0 SAY CHR(15)
      @ 5,0 SAY "+----------+------------------------------+----------+----+"
      @ 6,0 SAY "|CODIGO    |DESCRIPCION                   |COMPROMETE|PAGA|"
      @ 7,0 SAY "+----------+------------------------------+---------------+"
      STORE 8 TO WLINE
   ENDIF
   @ WLINE,01 SAY CODIGO
   @ WLINE,12 SAY DESCRI
   @ WLINE,47 SAY COMPROMETE
   @ WLINE,55 SAY PAGA
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