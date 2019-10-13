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
USE PRCOMP   INDEX PRCOMP1,PRCOMP2,PRCOMP3

STORE DATE()           TO WDESDE
STORE DATE()           TO WHASTA

STORE SPACE(12)        TO WEMPRE
@ 04,00 clear          to 19,40
@ 04,00                to 19,40
@ 04,10 SAY " COMPROMISOS "

@ 06,01 say "A¥O      :"
@ 08,01 SAY "ORIGEN   :"
@ 10,01 say "PARTIDA  :"
@ 12,01 say "DESDE    :"
@ 14,01 SAY "HASTA    :"
@ 16,01 SAY "DOCUMENTO:"
@ 18,01 SAY "BENEFIC. :"

@ 06,12 GET WPREANO
@ 08,12 GET WPREORI
@ 10,12 GET WPARTID
@ 10,17 GET WGENERI
@ 10,20 GET WESPECI
@ 10,23 GET WSUBESP
@ 10,26 GET WORDINA
@ 12,12 GET WDESDE
@ 14,12 GET WHASTA
READ
IF READKEY() = 12 .OR. READKEY() = 268
   CLOSE DATA
   CLOSE INDEX
   RETURN
ENDIF
IF WDESDE > WHASTA
   STORE "ERROR EN FECHAS, VERIFIQUE. <ENTER>" TO MES
   DO AVISO WITH MES
   CLOSE DATA
   CLOSE INDEX
   RETURN
ENDIF
@ 16,12 GET WCOMPRO
READ
*****************
STORE SPACE(12) TO WEMPRE,WDESEMPRE
STORE .T. TO VIENDOEMPRE
DO WHILE VIENDOEMPRE
   STORE "CODIGO DE BENEFICIARIO (?=Ver)" TO MES
   DO MENSAJE WITH MES
   @ 18,12 GET WEMPRE
   READ
   IF WEMPRE = SPACE(12)
      exit
   ENDIF
   IF AT("?",WEMPRE) > 0
      SELECT PRBENEF
      SAVE SCRE TO S11
      @ 4,0 CLEAR
      DO PRBENEF
      store codigo to wempre
      RESTORE SCRE FROM S11
      @ 14,12 say WEMPRE
   ENDIF
   SELECT PRBENEF
   FIND &WEMPRE
   IF EOF()
      STORE "BENEFICIARIO NO DEFINIDO EN MAESTRO DE BENEFICIARIOS" TO MES
      DO AVISO WITH MES
   ELSE
      STORE DESCRI TO WDESEMPRE
      STORE .F. TO VIENDOEMPRE
   ENDIF
ENDDO
@ 14,12 say WDESEMPRE


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
   STORE 20 TO FINAL
   STORE 80 TO WCADENA
ENDIF
SELECT PRCOMP
go top
store 100 to wline
store 0 to wpage
store 0 to wtotalinf
do while .not. eof()
   select PRCOMP
   if wpreano <> space(2) .and. wpreano <> substr(codigopre,1,2)
      select PRCOMP
      skip
      loop
   endif
   if wpreori <> space(3) .and. wpreori <> substr(codigopre,3,3)
      select PRCOMP
      skip
      loop
   endif
   if wpartid <> space(4) .and. wpartid <> substr(codigopre,6,4)
      select PRCOMP
      skip
      loop
   endif
   if wgeneri <> space(2) .and. wgeneri <> substr(codigopre,10,2)
      select PRCOMP
      skip
      loop
   endif
   if wespeci <> space(2) .and. wespeci <> substr(codigopre,12,2)
      select PRCOMP
      skip
      loop
   endif
   if wsubesp <> space(2) .and. wsubesp <> substr(codigopre,14,2)
      select PRCOMP
      skip
      loop
   endif
   if wordina <> space(3) .and. wordina <> substr(codigopre,16,3)
      select PRCOMP
      skip
      loop
   endif
   if wempre <> space(12) .and. wempre <> benefi
      select prcomp
      skip
      loop
   endif
   if wcompro<> space(12) .and. wcompro<> soporte
      select prcomp
      skip
      loop
   endif
   if FECHA >=wdesde .and. FECHA<=whasta
      * pasa bien
   else
      select prcomp
      skip
      loop
   endif
   if monto = 0
      select prcomp
      skip
      loop
   endif
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
      @ 2,0 say "COMPROMISOS"
      @ 2,WCADENA-16 SAY "PAGINA:"+STR(WPAGE,3)
      @ 3,0 say "PRESUPUESTO: "+WPREANO+"-"+WPREORI+" PARTIDA : "+WPARTID+"-"+WGENERI+"-"+WESPECI+"-"+WSUBESP+"-"+WORDINA+" SOPORTE: "+WCOMPRO
      @ 4,0 SAY "----------------------------------------+----------+----------+-----------------"
      @ 5,0 SAY "PARTIDA                                 |DOCUMENTO |FECHA     |            MONTO"
      @ 6,0 SAY "----------------------------------------+----------+----------+-----------------"
      STORE 7 TO WLINE
   ENDIF
   SELECT PRCOMP
   STORE BENEFI TO WEMPRESA
   SELECT PRBENEF
   FIND &WEMPRESA
   IF EOF()
      STORE "NO REGISTRADA EN BENEFIC." TO WDESEMP
   ELSE
      STORE DESCRI TO WDESEMP
   ENDIF
   SELECT PRCOMP

   @ wline,00 say substr(CODIGOPRE,06,4)+"-"+;
                  substr(CODIGOPRE,10,2)+"-"+;
                  substr(CODIGOPRE,12,2)+"-"+;
                  substr(CODIGOPRE,14,2)+"-"+;
                  substr(CODIGOPRE,16,3)
   @ WLINE,40 SAY SOPORTE
   @ WLINE,52 SAY FECHA
   @ WLINE,63 SAY MONTO PICTURE "##,###,###,###.##"
   store wline+1 to wline 
   @ WLINE,00 SAY WDESEMP
   store wline +1 to wline
   @ wline,0 say replicate("-",WCADENA)
   store wtotalinf + monto to wtotalinf
   SKIP
ENDDO
if wtotalinf > 0
   store wline + 1 to wline
   @ wline,0 say "T O T A L   I N F O R M E :"
   @ WLINE,63 SAY WTOTALINF  PICTURE "##,###,###,###.##"
endif
IF WSALIDA = "M"
   store "OPRIMA <ENTER> PARA SALIR" TO MES
   DO AVISO WITH MES
ELSE
   set devi to scre
   EJECT
ENDIF
CLOSE DATA
CLOSE INDEX
RETURN
