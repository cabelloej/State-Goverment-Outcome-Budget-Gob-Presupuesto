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
USE PRTRAS INDEX PRTRAS1

store 0 to wtotinf
@ 4,0 clear to 15,40
@ 4,0 to 15,40
@ 4,12   say "REFORMULACIONES"
@ 6,01   SAY "A¥O:"   GET WPREANO PICTURE "!!"
@ 6,10   SAY "ORIGEN:" GET WPREORI PICTURE "!!!"
@ 8, 01  say "ORIGEN  DE LA REFORMULACION"
@ 9, 01  say "A¥-ORG-PART-GE-ES-SE-ORD"
@ 12,01  SAY "DESTINO DE LA REFORMULACION"
@ 13,01  say "A¥-ORG-PART-GE-ES-SE-ORD"
READ
store wpreano+wpreori to wtopcta
if len(rtrim(ltrim(wtopcta))) <> 5
   store "IDENTIFICADOR DE CUENTAS ESTA INCOMPLETO, OPRIMA <ENTER>" TO MES
   DO AVISO WITH MES
   CLOSE DATA
   CLOSE INDEX
   RETURN
ENDIF
store "INDIQUE CODIGO ORIGEN DE LA REFORMULACION, <ENTER> = TODOS" TO MES
DO MENSAJE WITH MES
store wpreano to wpr1
store wpreori to wpr2
store wpartid to wpr3
store wgeneri to wpr4
store wespeci to wpr5
store wsubesp to wpr6
store wordina to wpr7
@ 10 ,01  SAY WPREANO
@ 10 ,04  SAY WPREORI
@ 10 ,08  GET WPARTID
@ 10 ,13  GET WGENERI
@ 10 ,16  GET WESPECI
@ 10 ,19  GET WSUBESP
@ 10 ,22  GET WORDINA
READ
IF LASTKEY()=27
   CLOSE DATA
   CLOSE INDEX
   RETURN
ENDIF
DO WARMACOD0
STORE WCUENTA0 TO WCTAORI
SELECT PRCTAS
SEEK WCTAORI
IF EOF()
   STORE "CUENTA NO EXISTE" TO MES
   DO AVISO WITH MES
   CLOSE DATA
   CLOSE INDEX
   RETURN
ENDIF
IF substr(WCUENTA0,6,13) <> SPACE(13)
   SELECT PRTRAS
   FIND &WCUENTA0
   IF EOF()
      STORE "ESTA CUENTA NO ES ORIGEN DE NINGUNA REFORMULACION, OPRIMA <ENTER>" TO MES
      DO AVISO WITH MES
      CLOSE DATA
      CLOSE INDEX
      RETURN
   ENDIF
ENDIF
store "INDIQUE CODIGO DESTINO DE LA REFORMULACION, <ENTER> = TODOS" TO MES
DO MENSAJE WITH MES
store wpr1 to wpreano 
store wpr2 to wpreori
store wpr3 to wpartid
store wpr4 to wgeneri
store wpr5 to wespeci
store wpr6 to wsubesp
store wpr7 to wordina
@ 14,01  SAY WPREANO
@ 14,04  SAY WPREORI
@ 14,08  GET WPARTID
@ 14,13  GET WGENERI
@ 14,16  GET WESPECI
@ 14,19  GET WSUBESP
@ 14,22  GET WORDINA
READ
IF LASTKEY()=27
   CLOSE DATA
   CLOSE INDEX
   RETURN
ENDIF
DO WARMACOD0
STORE WCUENTA0 TO WCTADES
SELECT PRCTAS
SEEK WCTADES
IF EOF()
   STORE "CUENTA NO EXISTE" TO MES
   DO AVISO WITH MES
   CLOSE DATA
   CLOSE INDEX
   RETURN
ENDIF
store "SELECCIONE LA SALIDA: (M)ONITOR, (I)MPRESORA, (S)ALIR" TO TEX
STORE "IS" TO WCH
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
select PRTRAS
GO TOP
store 100 to wline
store 0 to wpage
do while .not. eof() 
   if SUBSTR(wctaori,6,13) <> space(13) .and. wctaori <> origen
     select PRTRAS
     skip
     loop
   endif
   if SUBSTR(wctades,6,13) <> space(13) .and. wctades <> destino
     select PRTRAS
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
      @ 2,0 say "REFORMULACIONES"
      @ 2,WCADENA-16 SAY "PAGINA:"+STR(WPAGE,3)
      @ 3,0 SAY "A¥O:"+WPREANO+"  ORIGEN:"+WPREORI
      @ 4,0 SAY "PARTIDA ORIG.: "+WCTAORI+" PARTIDA DEST.: "+WCTADES
      @ 5,0 SAY CHR(15)
      @ 6,0 SAY " O R I G E N                                   D E S T I N O     "
      @ 7,0 SAY "+----+--+--+--+---+---------------------------+----+--+--+--+---+---------------------------+-----------------+----------+----------+"
      @ 8,0 SAY "|PART|GE|ES|SE|ORD|                           |PART|GE|ES|SE|ORD|                           |            MONTO|OFICIO    |FECHA     |"
      @ 9,0 SAY "+----+--+--+--+---+---------------------------+----+--+--+--+---+---------------------------+-----------------+----------+----------+"
      STORE 10 TO WLINE
   ENDIF
   @ WLINE,01 SAY SUBSTR(ORIGEN,06,4)+"-"
   @ WLINE,06 SAY SUBSTR(ORIGEN,10,2)+"-"
   @ WLINE,09 SAY SUBSTR(ORIGEN,12,2)+"-"
   @ WLINE,12 SAY SUBSTR(ORIGEN,14,2)+"-"
   @ WLINE,15 SAY SUBSTR(ORIGEN,16,3)

   @ WLINE,01+46 SAY SUBSTR(DESTINO,06,4)+"-"
   @ WLINE,06+46 SAY SUBSTR(DESTINO,10,2)+"-"
   @ WLINE,09+46 SAY SUBSTR(DESTINO,12,2)+"-"
   @ WLINE,12+46 SAY SUBSTR(DESTINO,14,2)+"-"
   @ WLINE,15+46 SAY SUBSTR(DESTINO,16,3)

   store origen  to wori
   store destino to wdes
   select prctas
   find &wori
   if eof()
      store "NO REGISTRADO EN PLA DE CTAS." to wdes11
      store space(1) to wdes12
      store space(1) to wdes13
      store space(1) to wdes14
   else
      store descri1 to wdes11
      store descri2 to wdes12
      store descri3 to wdes13
      store descri4 to wdes14
   endif
   find &wdes
   if eof()
      store "NO REGISTRADO EN PLA DE CTAS." to wdes21
      store space(1) to wdes21
      store space(1) to wdes22
      store space(1) to wdes23
      store space(1) to wdes24
   else
      store descri1 to wdes21
      store descri2 to wdes22
      store descri3 to wdes23
      store descri4 to wdes24
   endif
   select prtras
   @ WLINE,93  SAY MONTO  picture "##,###,###,###.##"
   @ WLINE,111 SAY OFICIO
   @ WLINE,122 SAY FECHA
   store wline + 1 to wline
   @ wline,01 say wdes11
   @ wline,47 say wdes21
   if wdes12 <> space(30) .or. wdes22 <> space(30)
      store wline + 1 to wline
      @ wline,01 say wdes12
      @ wline,47 say wdes22
   endif
   if wdes13 <> space(30) .or. wdes23 <> space(30) 
      store wline + 1 to wline
      @ wline,01 say wdes13
      @ wline,47 say wdes23
   endif
   if wdes14 <> space(30) .or. wdes24 <> space(30)
      store wline + 1 to wline
      @ wline,01 say wdes14
      @ wline,47 say wdes24
   endif
   store wline +1 to wline
   @ wline,0 say replica("-",wcadena)  
   store wtotinf + monto to wtotinf 
   select prtras
   SKIP
ENDDO
if wtotinf>0
   store wline+1 to wline
   @ wline ,0 say "TOTAL INFORME Bs."
   @ WLINE,93  SAY wtotinf picture "##,###,###,###.##"
endif
IF WSALIDA = "M"
   store "OPRIMA <ENTER> PARA SALIR" TO MES
   DO AVISO WITH MES
ELSE
   @ WLINE,0 SAY CHR(18)
   SET DEVI TO SCRE
   EJECT
ENDIF
CLOSE DATA
CLOSE INDEX
RETURN
