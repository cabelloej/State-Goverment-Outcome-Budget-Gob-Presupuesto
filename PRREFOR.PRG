select 1
use prctas   index prctas1
select 2
use prparti  index prparti
select 3
use prunid   index prunid
select 4
use prbenef index prbenef1,prbenef2
select 5
use prsopor index prsopor
select 6
use prcomp index prcomp1,prcomp2,prcomp3
select 7
use prtras index prtras1,prtras2
STORE .T. TO TRASPASA
DO WHILE TRASPASA
   @ 0,0 CLEAR
   @ 0,0 SAY QQWW
   @ 0,70 SAY "REFORMULAR"
   @ 01,00 SAY "+--------------------------------------------+---------------------------------+"
   @ 02,00 SAY "| O R I G E N   D E   R E F O R M U L A C.   |E S T A D O   D E   C U E N T A  |"
   @ 03,00 SAY "|A¥-ORI PART-GE-ES-SE-ORD                    +---------------------------------+"
   @ 04,00 SAY "|                                            |MONTO MODIFICADO :               |"
   @ 05,00 SAY "|                                            |COMPROMISOS      :               |"
   @ 06,00 SAY "|                                            |                  ---------------|"
   @ 07,00 SAY "|                                            |DISPONIBLE                       |"
   @ 08,00 SAY "|                                            |                                 |"
   @ 09,00 SAY "+--------------------------------------------+---------------------------------+"
   @ 10,00 SAY "| D E S T I N O   D E   R E F O R M U L A C. |E S T A D O   D E   C U E N T A  |"
   @ 11,00 SAY "|A¥-ORI PART-GE-ES-SE-ORD                    +---------------------------------+"
   @ 12,00 SAY "|                                            |MONTO MODIFICADO :               |"
   @ 13,00 SAY "|                                            |COMPROMISOS      :               |"
   @ 14,00 SAY "|                                            |                  ---------------|"
   @ 15,00 SAY "|                                            |DISPONIBLE                       |"
   @ 16,00 SAY "|                                            |                                 |"
   @ 17,00 SAY "+---------------------------+----------------+---------------------------------+"
   @ 18,00 SAY "|OFICIO:                    |FECHA:          |MONTO A REFORMULAR:              |"
   @ 19,00 SAY "+---------------------------+----------------+---------------------------------+"
   **** O R I G E N  ******
   STORE "INGRESE EL No. DE CUENTA ORIGEN. ?=VER CTAS, <ESC>=SALIR" TO MES
   DO MENSAJE WITH MES
   SELECT prctas
   STORE WPREANO TO WPREANO1
   STORE WPREORI TO WPREORI1
   STORE WPARTID TO WPARTID1
   STORE WGENERI TO WGENERI1
   STORE WESPECI TO WESPECI1
   STORE WESPECI TO WSUBESP1
   STORE WORDINA TO WORDINA1
   @ 4,01  GET WPREANO1
   @ 4,04  GET WPREORI1
   @ 4,08  GET WPARTID1
   @ 4,13  GET WGENERI1
   @ 4,16  GET WESPECI1
   @ 4,19  GET WSUBESP1
   @ 4,22  GET WORDINA1
   READ
   STORE WPREANO1 TO WPREANO
   STORE WPREORI1 TO WPREORI
   STORE WPARTID1 TO WPARTID
   STORE WGENERI1 TO WGENERI
   STORE WESPECI1 TO WESPECI
   STORE WSUBESP1 TO WSUBESP
   STORE WORDINA1 TO WORDINA
   DO WARMACOD0
   STORE WCUENTA0 TO WCUENTA1
   IF AT("?",WCUENTA1) > 0
      SAVE SCRE TO S11
      @ 1,0 CLEAR
      CLEAR TYPEAHEAD
      DO PRFORMU
      RESTORE SCRE FROM S11
      STORE WCUENTA0 TO WCUENTA1
      STORE SUBSTR(WCUENTA1,1,2)  TO WPREANO1
      STORE SUBSTR(WCUENTA1,3,3)  TO WPREORI1
      STORE SUBSTR(WCUENTA1,06,4) TO WPARTID1
      STORE SUBSTR(WCUENTA1,10,2) TO WGENERI1
      STORE SUBSTR(WCUENTA1,12,2) TO WESPECI1
      STORE SUBSTR(WCUENTA1,14,2) TO WSUBESP1
      STORE SUBSTR(WCUENTA1,16,3) TO WORDINA1
      @ 4,01  SAY WPREANO1
      @ 4,04  SAY WPREORI1
      @ 4,08  SAY WPARTID1
      @ 4,13  SAY WGENERI1
      @ 4,16  SAY WESPECI1
      @ 4,19  SAY WSUBESP1
      @ 4,22  SAY WORDINA1
   ENDIF
   IF WCUENTA1= SPACE(18).OR.READKEY()=12.OR.READKEY()=268
      CLOSE DATA
      CLOSE INDEX
      RETURN
   ENDIF
   STORE LEN(RTRIM(WCUENTA1))   TO WLARCOD1
   IF WLARCOD1 <> 18
      STORE "ESTE NUMERO DE CUENTA NO MANEJA MONTOS" TO MES
      DO AVISO WITH MES
      LOOP
   ENDIF
   SELECT prctas
   FIND &WCUENTA1
   IF EOF()
      STORE "CODIGO NO EXISTE. <ENTER>" TO MES
      DO AVISO WITH MES
      LOOP
   ENDIF
   *** CODIGO ORIGEN VALIDO
   STORE WCUENTA1 TO WNOCTA1
   STORE DESCRI1  TO WDESCTA11
   STORE DESCRI2  TO WDESCTA12
   STORE DESCRI3  TO WDESCTA13
   STORE DESCRI4  TO WDESCTA14
   STORE ORIG+TRAS+INCR-DISM   TO WMODI1
   STORE COMP                  TO WASIGCOMP1
   STORE WMODI1-WASIGCOMP1     TO WDISPONE1
   @ 04,64 SAY STR(WMODI1,15,2)
   @ 05,64 SAY STR(WASIGCOMP1,15,2)
   @ 07,64 SAY STR(WDISPONE1,15,2)
   @ 05,1  SAY WDESCTA11
   @ 06,1  SAY WDESCTA12
   @ 07,1  SAY WDESCTA13
   @ 08,1  SAY WDESCTA14
   ********** D E S T I N O  *********
   STORE "INGRESE EL No. DE CUENTA DESTINO. ?=VER CTAS, <ESC>=SALIR" TO MES
   DO MENSAJE WITH MES
   SELECT prctas
   STORE WPREANO TO WPREANO2
   STORE WPREORI TO WPREORI2
   STORE WPARTID TO WPARTID2
   STORE WGENERI TO WGENERI2
   STORE WESPECI TO WESPECI2
   STORE WESPECI TO WSUBESP2
   STORE WORDINA TO WORDINA2
   @ 12,01  GET WPREANO2
   @ 12,04  GET WPREORI2
   @ 12,08  GET WPARTID2
   @ 12,13  GET WGENERI2
   @ 12,16  GET WESPECI2
   @ 12,19  GET WSUBESP2
   @ 12,22  GET WORDINA2
   READ
   STORE WPREANO2 TO WPREANO
   STORE WPREORI2 TO WPREORI
   STORE WPARTID2 TO WPARTID
   STORE WGENERI2 TO WGENERI
   STORE WESPECI2 TO WESPECI
   STORE WSUBESP2 TO WSUBESP
   STORE WORDINA2 TO WORDINA
   DO WARMACOD0
   STORE WCUENTA0 TO WCUENTA2
   IF AT("?",WCUENTA2) > 0
      SAVE SCRE TO S11
      @ 1,0 CLEAR
      CLEAR TYPEAHEAD
      DO PRFORMU
      RESTORE SCRE FROM S11
      STORE WCUENTA0 TO WCUENTA2
      STORE SUBSTR(WCUENTA2,1,2)  TO WPREANO2
      STORE SUBSTR(WCUENTA2,3,3)  TO WPREORI2
      STORE SUBSTR(WCUENTA2,06,4) TO WPARTID2
      STORE SUBSTR(WCUENTA2,10,2) TO WGENERI2
      STORE SUBSTR(WCUENTA2,12,2) TO WESPECI2
      STORE SUBSTR(WCUENTA2,14,2) TO WSUBESP2
      STORE SUBSTR(WCUENTA2,16,3) TO WORDINA2
      @ 12,01  SAY WPREANO2
      @ 12,04  SAY WPREORI2
      @ 12,08  SAY WPARTID2
      @ 12,13  SAY WGENERI2
      @ 12,16  SAY WESPECI2
      @ 12,19  SAY WSUBESP2
      @ 12,22  SAY WORDINA2
   ENDIF
   IF WCUENTA2= SPACE(18).OR.READKEY()=12.OR.READKEY()=268
      CLOSE DATA
      CLOSE INDEX
      RETURN
   ENDIF
   STORE LEN(RTRIM(WCUENTA2))   TO WLARCOD2
   IF WLARCOD2 <> 18
      STORE "ESTE NUMERO DE CUENTA NO MANEJA MONTOS" TO MES
      DO AVISO WITH MES
      LOOP
   ENDIF
   SELECT prctas
   FIND &WCUENTA2
   IF EOF()
      STORE "CODIGO NO EXISTE. <ENTER>" TO MES
      DO AVISO WITH MES
      LOOP
   ENDIF
   *** CODIGO DESTINO VALIDO
   STORE WCUENTA2 TO WNOCTA2
   STORE DESCRI1 TO WDESCTA21
   STORE DESCRI2 TO WDESCTA22
   STORE DESCRI3 TO WDESCTA23
   STORE DESCRI4 TO WDESCTA24
   STORE ORIG+TRAS+INCR-DISM TO WMODI2
   STORE COMP                TO WASIGCOMP2
   STORE WMODI2-WASIGCOMP2   TO WDISPONE2
   @ 12,64 SAY STR(WMODI2,15,2)
   @ 13,64 SAY STR(WASIGCOMP2,15,2)
   @ 15,64 SAY STR(WDISPONE2,15,2)
   @ 13,1  SAY WDESCTA21
   @ 14,1  SAY WDESCTA22
   @ 15,1  SAY WDESCTA23
   @ 16,1  SAY WDESCTA24
   select prtras
   find &WCUENTA1
   do while .not. eof() .and. origen = WCUENTA1
      if destino = WCUENTA2
         store fecha to wfecha
         store monto to wmonto
         store "TRASPASO EXISTE POR Bs."+STR(WMONTO,15,2)+" DESEA ELIMINAR? (S/N)" TO TEX
         STORE "NS" TO WCH
         DO PREGUNTA
         IF WCH = "S"
            do recloc
            REPLACE USERNAME   WITH SYS(30)
            REPLACE USERDATE   WITH DATE()
            DELETE
            *** ACTUALIZAR CTAS.
            SELECT prctas
            FIND &WCUENTA1
            IF EOF()
               STORE "REGISTRO ORIGEN DESAPARECIDO, (LA CTA. NO FUE ACTUALIZADA). OPRIMA <ENTER>" TO MES
               DO AVISO WITH MES
               CLOSE DATA
               CLOSE INDEX
               RETURN
            ELSE
               STORE RECNO() TO WREGIS1
            ENDIF
            FIND &WCUENTA2
            IF EOF()
               STORE "REGISTRO DESTINO DESAPARECIDO, (LA CTA. NO FUE ACTUALIZADA). OPRIMA <ENTER>" TO MES
               DO AVISO WITH MES
               CLOSE DATA
               CLOSE INDEX
               RETURN
            ELSE
               STORE RECNO() TO WREGIS2
            ENDIF
            GO WREGIS1
            STORE WCUENTA1   TO WNOCTA
            STORE FECHAREFOR TO WFECHA
            STORE .T.        TO WFLAGMES
            STORE "TRAS"     TO WCAMPO
            STORE WMONTO     TO WMONTOPROC
            DO ACTUALIZA
            GO WREGIS2
            STORE WCUENTA2   TO WNOCTA
            STORE FECHAREFOR TO WFECHA
            STORE WMONTO*-1  TO WMONTOPROC
            DO ACTUALIZA
         ENDIF
         CLOSE DATA
         CLOSE INDEX
         RETURN
      endif
      skip
   enddo
   select prctas
   IF WDISPONE1 = 0
      STORE "NO HAY DISPONIBILIDAD EN LA CUENTA ORIGEN. <ENTER>" TO MES
      DO AVISO WITH MES
      LOOP
   ENDIF
   STORE SPACE(10) TO WOFICIO
   STORE DATE()    TO WFECHA
   DO WHILE WOFICIO = SPACE(10)
      @ 18,8 GET WOFICIO
      READ
   ENDDO
   @ 18,35 GET WFECHA
   READ

   STORE WDISPONE1 TO WMONTO
   STORE .T. TO WPIDE
   DO WHILE WPIDE
      @ 18,64 GET WMONTO PICTURE "############.##"
      READ
      IF READKEY()=12.OR.READKEY()=268
         CLOSE DATA
         CLOSE INDEX
         RETURN
      ENDIF
      IF WMONTO = 0
         STORE "EL MONTO DE LA REFORMULACION DEBE SER MAYOR QUE CERO (0). <ENTER>" TO MES
         DO AVISO WITH MES
         LOOP
      ENDIF
      IF WMONTO > WDISPONE1
         STORE "NO PUEDE REFORMULAR MAS DE LO DISPONIBLE EN LA CTA. ORIGEN. <ENTER>" TO MES
         DO AVISO WITH MES
         LOOP
      ENDIF
      STORE .F. TO WPIDE
   ENDDO
   STORE "CONFORME? (S/N)" TO TEX
   STORE "SN" TO WCH
   DO PREGUNTA
   IF WCH = "S"
      SELECT prtras
      APPEND BLANK
      do recloc
      REPLACE ORIGEN     WITH WCUENTA1
      REPLACE DESTINO    WITH WCUENTA2
      REPLACE OFICIO     WITH WOFICIO
      REPLACE FECHA      WITH WFECHA
      REPLACE MONTO      WITH WMONTO
      REPLACE USERNAME   WITH SYS(30)
      REPLACE USERDATE   WITH DATE()
      unlock
      *** ACTUALIZAR CTA ORIGEN.
      STORE WCUENTA1   TO WNOCTA
      STORE .T.        TO WFLAGMES
      STORE "TRAS"     TO WCAMPO
      STORE WMONTO *-1 TO WMONTOPROC
      DO ACTUALIZA
      **** ACTUALIZAR CTA DESTINO
      STORE WCUENTA2 TO WNOCTA
      STORE "TRAS"   TO WCAMPO
      STORE WMONTO   TO WMONTOPROC
      DO ACTUALIZA
      UNLOCK ALL
   ENDIF
ENDDO
CLOSE DATA
CLOSE INDEX
RETURN
