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
SELECT 7
USE PRPAGA   INDEX PRPAGA1,PRPAGA2,PRPAGA3


SET COLOR TO W+/B
@ 0,0 CLEAR
@ 0,0 SAY QQWW
@ 0,69 SAY "COMPROMETER"
@ 01,00 SAY "+A¥-ORI PART-GE-ES-SE-ORD -------------------+---------------------------------+"
@ 02,00 SAY "|                                            |MONTO MODIFICADO :               |"
@ 03,00 SAY "|                                            |COMPROMISOS      :               |"
@ 04,00 SAY "|                                            |                 +---------------|"
@ 05,00 SAY "|                                            |DISPONIBLE                       |"
@ 06,00 SAY "|                                            |                                 |"
@ 07,00 SAY "+----+------------+--------------------------+-----------------+---------------+"
@ 08,00 SAY "|RENG|No.DE COMPR.|CODIGO Y NOMBRE DEL BENEFICIARIO            |          MONTO|"
@ 09,00 SAY "+----+------------+--------------------------------------------+---------------+"
@ 10,00 SAY "|    |            |                                            |               |"
@ 11,00 SAY "|    |            |                                            |               |"
@ 12,00 SAY "|    |            |                                            |               |"
@ 13,00 SAY "|    |            |                                            |               |"
@ 14,00 SAY "|    |            |                                            |               |"
@ 15,00 SAY "|    |            |                                            |               |"
@ 16,00 SAY "|    |            |                                            |               |"
@ 17,00 SAY "|    |            |                                            |               |"
@ 18,00 SAY "|    |            |                                            |               |"
@ 19,00 SAY "|    |            |                                            |               |"
@ 20,00 SAY "+----+------------+--------------------------------------------+---------------+"
@ 21,00 SAY "|    |            |                                            |               |"
@ 22,00 SAY "+----+------------+--------------------------------------------+---------------+"
SAVE SCRE TO S10
STORE "INGRESE EL No. DE CUENTA A PROCESAR. ?=VER CTAS, <ESC>=SALIR" TO MES
DO MENSAJE WITH MES
SELECT PRCTAS
@ 2,01  GET WPREANO
@ 2,04  GET WPREORI
@ 2,08  GET WPARTID
@ 2,13  GET WGENERI
@ 2,16  GET WESPECI
@ 2,19  GET WSUBESP
@ 2,22  GET WORDINA
READ
STORE SPACE(18) TO WCUENTA0
DO WARMACOD0
IF AT("?",WCUENTA0) > 0
   SAVE SCRE TO S11
   @ 1,0 CLEAR
   CLEAR TYPEAHEAD
   SELECT PRCTAS
   DO PRFORMU
   RESTORE SCRE FROM S11
   STORE SUBSTR(WCUENTA0,1,2)  TO WPREANO
   STORE SUBSTR(WCUENTA0,3,3)  TO WPREORI
   STORE SUBSTR(WCUENTA0,06,4) TO WPARTID
   STORE SUBSTR(WCUENTA0,10,2) TO WGENERI
   STORE SUBSTR(WCUENTA0,12,2) TO WESPECI
   STORE SUBSTR(WCUENTA0,14,2) TO WSUBESP
   STORE SUBSTR(WCUENTA0,16,3) TO WORDINA
ENDIF
IF WCUENTA0= SPACE(18).OR.READKEY()=12.OR.READKEY()=268
   CLOSE DATA
   CLOSE INDEX
   RETURN
ENDIF
STORE LEN(RTRIM(WCUENTA0)) TO WLARCOD
IF WLARCOD  <> 18
   STORE "ESTE NUMERO DE CUENTA NO MANEJA MONTOS "+STR(WLARCOD,2) TO MES
   DO AVISO WITH MES
   CLOSE DATA
   CLOSE INDEX
   return
ENDIF
SELECT PRCTAS
FIND &WCUENTA0
IF EOF()
   STORE "CODIGO NO EXISTE. <ENTER>" TO MES
   DO AVISO WITH MES
   CLOSE DATA
   CLOSE INDEX
   return
ENDIF
* do recloc
*** CODIGO VALIDO
STORE WCUENTA0 TO WNOCTA
STORE DESCRI1 TO WDESCTA1
STORE DESCRI2 TO WDESCTA2
STORE DESCRI3 TO WDESCTA3
STORE DESCRI4 TO WDESCTA4
*** INICIO DE OPERACION DE COMPROMISOS
STORE .T. TO ASIGNANDO
DO WHILE ASIGNANDO
   restore scre from s10
   SELECT PRCTAS
   STORE ORIG+TRAS+INCR-DISM  TO WMODI
   STORE ASIG+COMP            TO WASIGCOMP
   STORE CAUS+PAGA            TO WCAUSPAGA
   STORE WMODI-WASIGCOMP      TO WDISPONIBLE
   STORE 0 TO WEDDY
   @ 2,01  SAY WPREANO
   @ 2,04  SAY WPREORI
   @ 2,08  SAY WPARTID
   @ 2,13  SAY WGENERI
   @ 2,16  SAY WESPECI
   @ 2,19  SAY WSUBESP
   @ 2,22  SAY WORDINA
   @ 02,64 SAY WMODI       PICTURE "####,###,###.##"
   @ 03,64 SAY WASIGCOMP   PICTURE "####,###,###.##"
   @ 05,64 SAY WDISPONIBLE PICTURE "####,###,###.##"
   @ 03,1  SAY WDESCTA1
   @ 04,1  SAY WDESCTA2
   @ 05,1  SAY WDESCTA3
   @ 06,1  SAY WDESCTA4
   SELECT PRCOMP
   FIND &WCUENTA0
   STORE 100 TO WLINE
   STORE 0 TO WPAGINA
   store space(4) to wreng
   DO WHILE .NOT. EOF()  .AND. CODIGOPRE = WCUENTA0
      STORE WLINE + 1 TO WLINE
      store renglon to wreng
      IF WLINE > 19
         IF WPAGINA > 0
            STORE "OPRIMA <ENTER> PARA CONTINUAR, <ESC> PARA SALIR" TO MES
            DO AVISO WITH MES
         ENDIF
         IF READKEY()=12 .OR. READKEY()=268
            do while .not. eof() .and. codigopre=wcuenta0
               store renglon to wreng
               skip
            enddo
            EXIT
         ENDIF
         STORE WPAGINA + 1 TO WPAGINA
         STORE 10 TO WLINSTART
         DO WHILE WLINSTART <= 19
            @ WLINSTART,00 SAY "|    |            |                                            |               |"
            STORE WLINSTART + 1 TO WLINSTART
         ENDDO
         STORE 10 TO WLINE
      ENDIF
      IF BENEFI  <> SPACE(12)
         STORE BENEFI  TO WCODEM
         SELECT PRBENEF
         FIND &WCODEM
         IF EOF()
            STORE "NO REGISTRADA EN MAESTRO" TO WDESEM
         ELSE
            STORE DESCRI TO WDESEM
         ENDIF
      ELSE
         STORE "NO DEFINIDA EN COMPROMISOS" TO WDESEM
      ENDIF
      SELECT PRCOMP
      @ WLINE,1 SAY RENGLON
      @ WLINE,6 SAY SOPORTE
      @ WLINE,19 SAY WCODEM
      @ WLINE,32 SAY WDESEM
      @ WLINE,64 SAY STR(MONTO,15,2)
      STORE WEDDY + MONTO TO WEDDY
      SKIP
   ENDDO
   @ 21,64 SAY STR(WEDDY,15,2)
   @ 21,6 SAY SPACE(12)
   @ 21,19 SAY SPACE(45)
   STORE wreng TO WRENGLON
   STORE .T. TO VIENDORENG
   STORE "NUMERO DE RENGLON A PROCESAR. <ENTER>=SALIR" TO MES
   DO MENSAJE WITH MES
   @ 21,1 GET WRENGLON
   READ
   IF WRENGLON = SPACE(4) .or. readkey()=12 .or. readkey()=268
      STORE .F. TO ASIGNANDO
      LOOP
   ENDIF
   *** BUSQUEDA DEL COMPROMISO EN LA CTA.
   SELECT PRCOMP
   STORE WCUENTA0+WRENGLON TO WCLAVE
   FIND &WCLAVE
   IF EOF()
      STORE " RENGLON NO REGISTRADO EN ESTA CUENTA. INGRESAR ? (S/N)" TO TEX
      STORE "SN" TO WCH
      DO PREGUNTA
      IF WCH = "N"
         LOOP
      ENDIF
      STORE SPACE(12) TO WCOMPRO
      STORE SPACE(3)  TO WTIPCOM
      STORE SPACE(8)  TO WNUMCOM
      STORE .T.       TO WVIENDOCOMP
      DO WHILE WVIENDOCOMP
         STORE "INGRESE EL TIPO Y NUMERO DEL COMPROMISO ?=VER TIPOS" TO MES
         DO mensaje WITH MES
         @ 21,6 GET WTIPCOM
         READ
         IF readkey()=12.or.readkey()=268
            STORE .F. TO WVIENDOCOMP
            EXIT
         ENDIF
         IF WTIPCOM=SPACE(3).OR.AT("?",WTIPCOM)>0
            SAVE SCRE TO SCREEJC
            SELECT PRSOPOR
            DO PRSOPOR
            STORE CODIGO TO WTIPCOM
            RESTORE SCRE FROM SCREEJC
         ENDIF
         SELECT PRSOPOR
         FIND &WTIPCOM
         IF EOF()
            STORE "TIPO DE COMPROMISO NO EXISTE, REINTENTE" TO MES
            DO AVISO WITH MES
         ELSE
            IF COMPROMETE <> "S"
               STORE "ERROR, NO SE PUEDE COMPROMETER CON ESTE TIPO DE DOCUMENTO" TO MES
               DO AVISO WITH MES
               LOOP
            ENDIF
         ENDIF
         STORE "TIPO DE DOCUMENTO: "+DESCRI TO MES
         DO MENSAJE WITH MES
         @ 21,10 GET WNUMCOM
         READ
         IF WNUMCOM=SPACE(10).or.readkey()=12.or.readkey()=268
            LOOP
         ENDIF
         STORE WTIPCOM+"-"+WNUMCOM TO WCOMPRO
         *SELECT PRCOMP
         *SET ORDER TO 3
         *FIND &WCOMPRO
         *SET ORDER TO 1
         *IF EOF()
         *   EXIT
         *ELSE
         *   STORE "DOCUMENTO DE COMPROMISO YA EXISTE "  TO MES
         *   DO AVISO WITH MES
         *   LOOP
         *ENDIF
         EXIT
      ENDDO
      IF .NOT. WVIENDOCOMP
         LOOP
      ENDIF
      STORE .T. TO VIENDOEMPRE
      DO WHILE VIENDOEMPRE
         STORE "CODIGO DE BENEFICIARIO (?=Ver BENEFICIARIOS)" TO MES
         DO MENSAJE WITH MES
         @ 21,19 GET WBENEFI
         READ
         IF LASTKEY()=27
            STORE .F. TO VIENDOEMPRE
            STORE .F. TO ASIGNANDO
            LOOP
         ENDIF
         IF AT("?",WBENEFI) > 0  .OR. WBENEFI=SPACE(12)
            SELECT PRBENEF
            SAVE SCRE TO S11
            @ 4,0 CLEAR
            STORE SPACE(12) TO WSEL
            DO PRBENEF
            STORE WSEL TO WBENEFI
            RESTORE SCRE FROM S11
         ENDIF
         SELECT PRBENEF
         FIND &WBENEFI
         IF EOF()
            STORE "BENEFICIARIO NO DEFINIDO EN MAESTRO" TO MES
            DO AVISO WITH MES
         ELSE
            STORE DESCRI TO WDESEMPRE
            @ 21,32 SAY SUBST(WDESEMPRE,1,20)
            STORE .F. TO VIENDOEMPRE
         ENDIF
         SELECT PRCOMP
      ENDDO
      IF .NOT. ASIGNANDO
         LOOP
      ENDIF
      STORE WDISPONIBLE  TO WMONTOCOMP
      STORE .T. TO VIENDOMONTO
      DO WHILE VIENDOMONTO
         @ 21,64 GET WMONTOCOMP PICTURE "############.##"
         READ
         if readkey()=12.or.readkey()=268
            close data
            close index
            return
         endif
         IF WMONTOCOMP <=0
            LOOP
         ENDIF
         IF WMONTOCOMP > WDISPONIBLE
            STORE "EL MONTO DEL COMPROMISO SOBREPASA LA DISPONIBILIDAD" TO MES
            DO AVISO WITH MES
            STORE WDISPONIBLE TO WMONTOCOMP
            LOOP
         ELSE
            STORE .F. TO VIENDOMONTO
         ENDIF
      ENDDO
      STORE WDESCTA1         TO WDESCON1
      STORE WDESCTA2         TO WDESCON2
      STORE WDESCTA3         TO WDESCON3
      STORE WDESCTA4         TO WDESCON4
      SAVE SCRE TO S12
      @ 12,25 CLEAR TO 18,78
      @ 12,25       TO 18,78
      @ 12,39 SAY "DESCRIPCION DEL COMPROMISO"
      @ 13,27 GET WDESCON1
      @ 14,27 GET WDESCON2
      @ 15,27 GET WDESCON3
      @ 16,27 GET WDESCON4
      @ 17,27 SAY "FECHA:"
      READ
      STORE DATE() TO WCOMPROME
      DO MENSAJE WITH MES
      @ 17,34 GET WCOMPROME
      READ
      STORE "CONFORME? (S/N)" TO TEX
      STORE "SN" TO WCH
      DO PREGUNTA
      IF WCH = "N"
         LOOP
      ENDIF
      SELECT PRCOMP
      DO FILLOC
      APPEND BLANK
      UNLOCK
      do recloc
      REPLACE CODIGOPRE  WITH WCUENTA0
      REPLACE RENGLON    WITH WRENGLON
      REPLACE SOPORTE    WITH WCOMPRO
      REPLACE BENEFI     WITH WBENEFI
      REPLACE MONTO      WITH WMONTOCOMP
      REPLACE FECHA      WITH WCOMPROME
      REPLACE DESCRI1    WITH WDESCON1
      REPLACE DESCRI2    WITH WDESCON2
      REPLACE DESCRI3    WITH WDESCON3
      REPLACE DESCRI4    WITH WDESCON4
      REPLACE USERNAME   WITH SYS(30)
      REPLACE USERDATE   WITH DATE()
      UNLOCK
      FLUSH
      SELECT PRCTAS
      do recloc
      *** ACTUALIZA CTA.
      STORE WCUENTA0   TO WNOCTA
      STORE .T.        TO WFLAGMES
      STORE WCOMPROME  TO WFECHA
      STORE "COMP"     TO WCAMPO
      STORE WMONTOCOMP TO WMONTOPROC
      DO ACTUALIZA
      unlock
      SELECT PRCOMP
   ELSE
      SELECT PRCOMP
      STORE RECNO()              TO WQUEFUE
      STORE SUBSTR(SOPORTE,1,3) TO WTIPCOM
      STORE SUBSTR(SOPORTE,5,8) TO WNUMCOM
      STORE WTIPCOM+"-"+WNUMCOM  TO WCOMPRO,WLASTCOMPRO
      STORE BENEFI               TO WBENEFI
      STORE MONTO                TO WMONTOCOMP
      STORE DESCRI1              TO WDESCON1
      STORE DESCRI2              TO WDESCON2
      STORE DESCRI3              TO WDESCON3
      STORE DESCRI4              TO WDESCON4
      STORE FECHA                TO WCOMPROME
      SELECT PRBENEF
      FIND &WBENEFI
      IF EOF()
         STORE "NO REGISTRADO EN MAESTRO" TO WDESEM
      ELSE
         STORE DESCRI TO WDESEM
      ENDIF
      SELECT PRCOMP
      @ 21,6  SAY WCOMPRO
      @ 21,19 SAY WBENEFI
      @ 21,32 SAY WDESEM
      @ 21,64 SAY STR(MONTO,15,2)
      SAVE SCRE TO S12
      @ 12,25 CLEAR TO 18,78
      @ 12,25       TO 18,78
      @ 12,39 SAY "DESCRIPCION DEL COMPROMISO"
      @ 13,27 SAY WDESCON1
      @ 14,27 SAY WDESCON2
      @ 15,27 SAY WDESCON3
      @ 16,27 SAY WDESCON4
      @ 17,27 SAY "FECHA:"
      @ 17,34 SAY WCOMPROME
      STORE "OPCIONES: (M)ODIFICAR, (E)LIMINAR, (S)ALIR" TO TEX 
      STORE "SME" TO WCH
      DO PREGUNTA
      STORE WCH TO WOPASICON
      IF WOPASICON = "S"
         RESTORE SCRE FROM S12
         LOOP
      ENDIF
      select PRCOMP
      IF WOPASICON = "E" 
         IF WCOMPRO <> SPACE(12)
            SELECT PRPAGA
            SET ORDER TO 3
            FIND &WCOMPRO
            SET ORDER TO 1
            IF .NOT. EOF()
               store "ERROR DE OPERACION: COMPROMISOS CON GASTOS REGISTRADOS. <ENTER>" TO MES
               do aviso with mes
               store 100 to wline
               loop
            endif
            SELECT PRCOMP
         endif
         STORE "ESTA SEGURO QUE DESEA ELIMINAR? (S/N)" TO TEX
         STORE "NS" TO WCH
         DO PREGUNTA
         IF WCH = "N"
            store 100 to wline
            LOOP
         ELSE
            SELECT PRCTAS
            do recloc
            *** ACTUALIZA CTA.
            STORE WCUENTA0  TO WNOCTA
            STORE .T.       TO WFLAGMES
            STORE WCOMPROME TO WFECHA
            STORE "COMP"    TO WCAMPO
            STORE WMONTOCOMP*-1 TO WMONTOPROC
            DO ACTUALIZA
            unlock
            SELECT PRCOMP
            GO WQUEFUE
            do recloc
            REPLACE USERNAME   WITH SYS(30)
            REPLACE USERDATE   WITH DATE()
            DELETE
            unlock 
            FLUSH
            store 100 to wline
            LOOP
         ENDIF
      ENDIF
      *** MODIFICACION DEL COMPROMISO.
      IF WOPASICON = "M"
         STORE .T. TO WVIENDOCOMP
         DO WHILE WVIENDOCOMP
            STORE "INGRESE EL TIPO Y NUMERO DEL COMPROMISO ?=VER TIPOS" TO MES
            DO mensaje WITH MES
            @ 21,6 GET WTIPCOM
            READ
            IF readkey()=12.or.readkey()=268
               STORE .F. TO WVIENDOCOMP
               EXIT
            ENDIF
            IF WTIPCOM=SPACE(3).OR.AT("?",WTIPCOM)>0
               SAVE SCRE TO SCREEJC
               SELECT PRSOPOR
               DO PRSOPOR
               STORE CODIGO TO WTIPCOM
               RESTORE SCRE FROM SCREEJC
            ENDIF
            SELECT PRSOPOR
            FIND &WTIPCOM
            IF EOF()
               STORE "TIPO DE COMPROMISO NO EXISTE, REINTENTE" TO MES
               DO AVISO WITH MES
               LOOP
            ELSE
               IF COMPROMETE <> "S"
                  STORE "ERROR, NO SE PUEDE COMPROMETER CON ESTE TIPO DE DOCUMENTO" TO MES
                  DO AVISO WITH MES
                  LOOP
               ENDIF
            ENDIF
            STORE "TIPO DE DOCUMENTO: "+DESCRI TO MES
            DO MENSAJE WITH MES
            @ 21,10 GET WNUMCOM
            READ
            IF WNUMCOM=SPACE(8).or.readkey()=12.or.readkey()=268
               LOOP
            ENDIF
            STORE WTIPCOM+"-"+WNUMCOM TO WCOMPRO
            *** SI CAMBIA DE CODIGO DE COMPROMISO, VERIFICA QUE NO EXISTAN
            *** CAUSADOS PARA EL CODIGO VIEJO
            IF WCOMPRO <> WLASTCOMPRO
               SELECT PRPAGA
               SET ORDER TO 3
               FIND &WLASTCOMPRO
               SET ORDER TO 1
               IF .NOT. EOF()
                  store "ERROR DE OPERACION: CODIGO ANTERIOR DE COMPROMISOS CON GASTOS CAUSADOS" TO MES
                  do aviso with mes
                  store 100 to wline
                  loop
               endif
            endif
            *** SI CAMBIA DE CODIGO DE COMPROMISO, VERIFICA QUE NO EXISTA
            *** COMO COMPROMISO YA REGISTRADO
            *SELECT PRCOMP
            *SET ORDER TO 3
            *FIND &WCOMPRO
            *SET ORDER TO 1
            *IF EOF()
            *   GO WQUEFUE
            *   EXIT
            *ELSE
            *   IF RECNO() <> WQUEFUE
            *      STORE "DOCUMENTO DE COMPROMISO YA EXISTE "  TO MES
            *      DO AVISO WITH MES
            *      LOOP
            *   ENDIF
            *   GO WQUEFUE
            *   EXIT
            *ENDIF
            ***
            EXIT
         ENDDO
         IF .NOT. WVIENDOCOMP
            LOOP
         ENDIF
         STORE .T. TO VIENDOEMPRE
         DO WHILE VIENDOEMPRE
            STORE "CODIGO DE BENEFICIARIO (?=Ver BENEFICIARIOS)" TO MES
            DO MENSAJE WITH MES
            @ 21,19 GET WBENEFI
            READ
            IF LASTKEY()=27
               STORE .F. TO VIENDOEMPRE
               STORE .F. TO ASIGNANDO
               LOOP
            ENDIF
            IF AT("?",WBENEFI) > 0 .OR. WBENEFI=SPACE(12)
               SELECT PRBENEF
               SAVE SCRE TO S11
               @ 4,0 CLEAR
               STORE SPACE(12) TO WSEL
               DO PRBENEF
               STORE WSEL TO WBENEFI
               RESTORE SCRE FROM S11
            ENDIF
            SELECT PRBENEF
            FIND &WBENEFI
            IF EOF()
               STORE "BENEFICIARIO NO DEFINIDO EN MAESTRO" TO MES
               DO AVISO WITH MES
            ELSE
               STORE DESCRI TO WDESEMPRE
               @ 21,32 SAY WDESEMPRE
               STORE .F. TO VIENDOEMPRE
            ENDIF
         ENDDO
         IF .NOT. ASIGNANDO
            LOOP
         ENDIF
         STORE .T. TO VIENDOMONTO
         STORE WMONTOCOMP TO WLASTMONTO
         STORE WDISPONIBLE + WMONTOCOMP TO WDISPONIBLE
         DO WHILE VIENDOMONTO
            STORE "MONTO DISPONIBLE PARA COMPROMETER :"+STR(WDISPONIBLE,15,2) TO MES
            DO MENSAJE WITH MES
            @ 21,64 GET WMONTOCOMP PICTURE "############.##"
            READ
            IF READKEY()=12.OR.READKEY()=268
               close data
               close index
               RETURN
            ENDIF
            IF WMONTOCOMP > WDISPONIBLE
               STORE "EL MONTO DEL COMPROMISO SOBREPASA LA DISPONIBILIDAD" TO MES
               DO AVISO WITH MES
               STORE WLASTMONTO TO WMONTOCOMP
               LOOP
            ELSE
               STORE .F. TO VIENDOMONTO
            ENDIF
         ENDDO
         @ 13,27 GET WDESCON1
         @ 14,27 GET WDESCON2
         @ 15,27 GET WDESCON3
         @ 16,27 GET WDESCON4
         READ
         @ 17,34 GET WCOMPROME
         READ
         STORE "CONFORME? (S/N)" TO TEX
         STORE "SN" TO WCH
         DO PREGUNTA
         IF WCH = "N"
            LOOP
         ENDIF
         SELECT PRCOMP
         do recloc
         REPLACE SOPORTE    WITH WCOMPRO
         REPLACE BENEFI     WITH WBENEFI
         REPLACE MONTO      WITH WMONTOCOMP
         REPLACE DESCRI1    WITH WDESCON1
         REPLACE DESCRI2    WITH WDESCON2
         REPLACE DESCRI3    WITH WDESCON3
         REPLACE DESCRI4    WITH WDESCON4
         REPLACE FECHA      WITH WCOMPROME
         REPLACE USERNAME   WITH SYS(30)
         REPLACE USERDATE   WITH DATE()
         unlock
         FLUSH
         SELECT PRCTAS
         do recloc
         *** ACTUALIZA CTA.
         STORE WCUENTA0      TO WNOCTA
         STORE .T.           TO WFLAGMES
         STORE WCOMPROME     TO WFECHA
         STORE "COMP"        TO WCAMPO
         STORE WLASTMONTO*-1 TO WMONTOPROC
         DO ACTUALIZA
         STORE WCUENTA0      TO WNOCTA
         STORE "COMP"        TO WCAMPO
         STORE WMONTOCOMP    TO WMONTOPROC
         DO ACTUALIZA
         unlock
         SELECT PRCOMP
      ENDIF
   ENDIF
   RESTORE SCRE FROM S12
ENDDO
RESTORE SCRE FROM S10
close data
close index
RETURN
