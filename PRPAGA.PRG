SELECT 1
USE PRCTAS INDEX PRCTAS1
SELECT 2
USE PRCOMP INDEX PRCOMP1,PRCOMP2,PRCOMP3
SELECT 3
USE PRPAGA INDEX PRPAGA1,PRPAGA2,PRPAGA3
SELECT 4
USE PRBENEF INDEX PRBENEF1
SELECT 5
USE PRSOPOR INDEX PRSOPOR

STORE 100 TO WLINPAGA
STORE 0 TO WPAGINA
STORE .T. TO PAGAndo
DO WHILE PAGAndo
   STORE WLINPAGA + 1 TO WLINPAGA
   IF WLINPAGA >=17
      STORE WPAGINA + 1 TO WPAGINA
      IF WPAGINA > 1
         STORE "OPRIMA <ENTER> PARA CONTINUAR" TO MES
         DO AVISO WITH MES
      ENDIF
      SET COLOR TO W+/B
      @ 0,0 CLEAR
      @ 0,0 SAY QQWW
      @ 0,75 SAY "PAGAR"
      @ 01,00 SAY "-------------------------------------------+------------+--------+--------------"
      @ 02,00 SAY " A¥-ORI PART-GE-ES-SE-ORD                  |COMPROMISO  |RECIBO  |         MONTO"
      @ 03,00 SAY "-------------------------------------------+------------+--------+--------------"
      @ 04,00 SAY "   -        -  -  -  -                     |            |        |              "
      @ 05,00 SAY "   -        -  -  -  -                     |            |        |              "
      @ 06,00 SAY "   -        -  -  -  -                     |            |        |              "
      @ 07,00 SAY "   -        -  -  -  -                     |            |        |              "
      @ 08,00 SAY "   -        -  -  -  -                     |            |        |              "
      @ 09,00 SAY "   -        -  -  -  -                     |            |        |              "
      @ 10,00 SAY "   -        -  -  -  -                     |            |        |              "
      @ 11,00 SAY "   -        -  -  -  -                     |            |        |              "
      @ 12,00 SAY "   -        -  -  -  -                     |            |        |              "
      @ 13,00 SAY "   -        -  -  -  -                     |            |        |              "
      @ 14,00 SAY "   -        -  -  -  -                     |            |        |              "
      @ 15,00 SAY "   -        -  -  -  -                     |            |        |              "
      @ 16,00 SAY "   -        -  -  -  -                     |            |        |              "
      @ 17,00 SAY "   -        -  -  -  -                     |            |        |              "
      @ 18,00 SAY "-------------------------------------------+------------------------------------"
      @ 19,00 SAY "                                                                                "
      @ 20,00 SAY "                                                                                "
      @ 21,00 SAY "                                                                                "
      @ 22,00 SAY "                                                                                "
      @ 23,00 SAY "                                                                                "
      STORE 4 TO WLINPAGA
   ENDIF
   store "No.DE CUENTA A PROCESAR, ? = VER CUENTAS" TO MES
   DO MENSAJE WITH MES
   STORE .F. TO WPORCONTRA
   @ WLINPAGA ,01  GET WPREANO
   @ WLINPAGA ,04  GET WPREORI
   @ WLINPAGA ,08  GET WPARTID
   @ WLINPAGA ,13  GET WGENERI
   @ WLINPAGA ,16  GET WESPECI
   @ WLINPAGA ,19  GET WSUBESP
   @ WLINPAGA ,22  GET WORDINA
   READ
   STORE SPACE(18) TO WCUENTA0
   DO WARMACOD0
   IF WCUENTA0 = SPACE(18).OR.READKEY()=12.OR.READKEY()=268
      CLOSE DATA
      CLOSE INDEX
      RETURN
   ENDIF
   IF AT("?",WCUENTA0) > 0
      SAVE SCRE TO S11
      @ 1,0 CLEAR
      CLEAR TYPEAHEAD
      STORE SPACE(18) TO WCUENTA0
      DO PRFORMU
      RESTORE SCRE FROM S11
      DO ARMACOD0
      STORE SUBSTR(WCUENTA0,1,2)  TO WPREANO
      STORE SUBSTR(WCUENTA0,3,3)  TO WPREORI
      STORE SUBSTR(WCUENTA0,06,4) TO WPARTID
      STORE SUBSTR(WCUENTA0,10,2) TO WGENERI
      STORE SUBSTR(WCUENTA0,12,2) TO WESPECI
      STORE SUBSTR(WCUENTA0,14,2) TO WSUBESP
      STORE SUBSTR(WCUENTA0,16,3) TO WORDINA
      @ WLINPAGA ,01  SAY WPREANO
      @ WLINPAGA ,04  SAY WPREORI
      @ WLINPAGA ,08  SAY WPARTID
      @ WLINPAGA ,13  SAY WGENERI
      @ WLINPAGA ,16  SAY WESPECI
      @ WLINPAGA ,19  SAY WSUBESP
      @ WLINPAGA ,22  SAY WORDINA
   ENDIF
   STORE RTRIM(LTRIM(WCUENTA0)) TO XCUENTA0
   IF LEN(WCUENTA0) <> 18
      STORE "ESTE NUMERO DE CUENTA NO MANEJA PAGOS." TO MES
      DO AVISO WITH MES
      LOOP
   ENDIF
   SELECT PRCTAS
   FIND &WCUENTA0
   IF EOF()
      STORE "NUMERO DE CUENTA NO EXISTE. <ENTER>" TO MES
      DO AVISO WITH MES
      STORE WLINPAGA - 1  TO WLINPAGA
      LOOP
   ENDIF
   *** DATOS DEL ARCHIVO DE CTAS
   STORE WCUENTA0 TO WNOCTA
   STORE DESCRI1 TO WDESCTA1
   STORE DESCRI2 TO WDESCTA2
   STORE DESCRI3 TO WDESCTA3
   STORE DESCRI4 TO WDESCTA4
   STORE ORIG    TO WORIG
   STORE TRAS    TO WTRAS
   STORE INCR    TO WINCR
   STORE DISM    TO WDISM
   STORE ASIG    TO WASIG
   STORE CAUS    TO WCAUS
   STORE COMP    TO WCOMP
   STORE PAGA    TO WPAGA
   STORE (WORIG+WTRAS+WINCR-WDISM)-WCOMP TO WDISPONIBLE
   @ 19,00 CLEAR TO 23,79
   @ 19,00 SAY "PARTIDA: "
   @ 19,10 SAY WDESCTA1
   @ 20,10 SAY WDESCTA2
   @ 21,10 SAY WDESCTA3
   @ 22,10 SAY WDESCTA4
   STORE .T. TO VERCONT
   DO WHILE VERCONT
      STORE SPACE(3) TO WTIPCOM
      STORE SPACE(8) TO WNUMCOM
      STORE "TIPO Y NUMERO DEL COMPROMISO, <ESC>=SALIR" TO MES
      DO MENSAJE WITH MES
      @ WLINPAGA,44 GET WTIPCOM
      READ
      IF READKEY()=12 .OR. READKEY()=268
         CLOSE DATA
         CLOSE INDEX
         RETURN
      ENDIF
      IF WTIPCOM = SPACE(3)
         LOOP
      ENDIF
      SELECT PRSOPOR
      FIND &WTIPCOM
      IF EOF()
         STORE "TIPO DE COMPROMISO NO REGISTRADO, VERIFIQUE" TO MES
         DO AVISO WITH MES
         LOOP
      ENDIF
      STORE DESCRI TO MES
      DO MENSAJE WITH MES
      @ WLINPAGA,48 GET WNUMCOM
      READ
      IF WNUMCOM = SPACE(8)
         LOOP
      ENDIF
      STORE WTIPCOM+"-"+WNUMCOM TO WCONTRATO
      SELECT PRCOMP
      SET ORDER TO 3
      FIND &WCONTRATO
      IF EOF()
         STORE "DOCUMENTO DE COMPROMISO NO REGISTRADO EN ESTA PARTIDA (W1)" TO MES
         DO AVISO WITH MES
         SET ORDER TO 1
         LOOP
      ELSE
         STORE .F. TO WFLAGFOUND
         DO WHILE.NOT.EOF().AND.SOPORTE=WCONTRATO
            IF CODIGOPRE=WCUENTA0
               STORE .T. TO WFLAGFOUND
               EXIT
            ENDIF
            SKIP
         ENDDO
         SET ORDER TO 1
         IF .NOT.WFLAGFOUND
            STORE "DOCUMENTO DE COMPROMISO NO REGISTRADO EN ESTA PARTIDA" TO MES
            DO AVISO WITH MES
            LOOP
         ENDIF
         STORE BENEFI    TO WEMPRESA
         STORE MONTO     TO WMONTOPAGAR
         STORE DESCRI1   TO WDESCRI1
         STORE DESCRI2   TO WDESCRI2
         @ 19,00 CLEAR TO 23,79
         @ 19,00 SAY "COMPROMISO: "
         @ 19,12 SAY DESCRI1
         @ 20,12 SAY DESCRI2
         @ 21,12 SAY DESCRI3
         @ 22,12 SAY DESCRI4
         IF LEN(WCUENTA0) <> 18
            STORE "ESTE NUMERO DE CUENTA NO MANEJA PAGOS. <ENETR>" TO MES
            DO AVISO WITH MES
            LOOP
         ENDIF
         STORE .F. TO VERCONT
      ENDIF
   ENDDO

   ***** CALCULO DEL ACUMULADO PAGADO DE ESE COMPROMISO
   IF WCONTRATO <> SPACE(12)
      STORE .F. TO WHAYPAGO
      SELECT PRPAGA
      STORE WCUENTA0+WCONTRATO TO WCLAVE
      FIND &WCLAVE
      STORE 0 TO WACUMULADO
      DO WHILE .NOT. EOF() .AND. CODIGOPRE = WCUENTA0 .AND. CONTRATO = WCONTRATO
         STORE WACUMULADO + MONTOPAGA TO WACUMULADO
         SKIP
      ENDDO
   ELSE
      STORE 0 TO WACUMULADO
   ENDIF
   *****
   STORE SPACE(8) TO WRECIBO
   DO WHILE WRECIBO=SPACE(8)
      STORE "INGRESE EL NUMERO DEL RECIBO" TO MES
      DO MENSAJE WITH MES
      @ WLINPAGA,57 GET WRECIBO
      READ
      IF READKEY()=12 .OR. READKEY()=268
         RETURN
      ENDIF
   ENDDO
   STORE WCUENTA0+WCONTRATO+WRECIBO TO WCLAVE
   SELECT PRPAGA
   FIND &WCLAVE
   IF EOF()
      STORE DATE() TO WFECHA
      @ 19,00 CLEAR TO 23,79
      @ 19,00 SAY "PAGO : "
      @ 21,00 SAY "FECHA: "
      @ 22,00 SAY "BENEF: "+WEMPRESA
      @ 19,07 GET WDESCRI1
      @ 20,07 GET WDESCRI2
      @ 21,07 GET WFECHA
      READ
      STORE .T. TO WPAGANDO
      DO WHILE WPAGANDO
         STORE WMONTOPAGAR - WACUMULADO TO WMONTO
         @ WLINPAGA,68 GET WMONTO picture "#########.##"
         READ
         IF READKEY()=12 .OR. READKEY()=268
            CLOSE DATA
            CLOSE INDEX
            RETURN
         ENDIF
         IF WMONTO = 0
            STORE "MONTO DEBE SER MAYOR QUE CERO (0). <ENTER>" TO MES
            DO AVISO WITH MES
         ELSE 
            IF WMONTO > (WMONTOPAGAR - WACUMULADO)
               STORE "MONTO A PAGAR MAYOR QUE PERMITIDO("+STR((WMONTOPAGAR-WACUMULADO),15,2)+"), VERIFIQUE. <ENTER>" TO MES
               DO AVISO WITH MES
            ELSE
               STORE .F. TO WPAGANDO
            ENDIF
         ENDIF
      ENDDO
      STORE "CONFORME? (S/N)" TO TEX
      STORE "SN" TO WCH
      DO PREGUNTA
      IF WCH = "N"
         STORE WLINPAGA - 1  TO WLINPAGA
         LOOP
      ENDIF
      SELECT PRPAGA
      DO FILLOC
      APPEND BLANK
      UNLOCK
      do recloc
      REPLACE CODIGOPRE WITH WCUENTA0
      REPLACE CONTRATO  WITH WCONTRATO
      REPLACE RECIBO    WITH WRECIBO
      REPLACE MONTOPAGA WITH WMONTO
      REPLACE FECHAPAGA WITH WFECHA
      REPLACE DESCRI1   WITH WDESCRI1
      REPLACE DESCRI2   WITH WDESCRI2
      REPLACE USERNAME  WITH SYS(30)
      REPLACE USERDATE  WITH DATE()
      unlock
      FLUSH
      SELECT PRCTAS
      do recloc
      *** ACTUALIZAR CTA
      STORE WCUENTA0 TO WNOCTA
      STORE .T.      TO WFLAGMES
      STORE "PAGA"   TO WCAMPO
      STORE WMONTO   TO WMONTOPROC
      DO ACTUALIZA
      unlock 
      FLUSH
      SELECT 3
   ELSE
      STORE SUBSTR(CODIGOPRE,1,2)  TO WPREANO
      STORE SUBSTR(CODIGOPRE,3,3)  TO WPREORI
      STORE SUBSTR(CODIGOPRE,06,4) TO WPARTID
      STORE SUBSTR(CODIGOPRE,10,2) TO WGENERI
      STORE SUBSTR(CODIGOPRE,12,2) TO WESPECI
      STORE SUBSTR(CODIGOPRE,14,2) TO WSUBESP
      STORE SUBSTR(CODIGOPRE,16,3) TO WORDINA
      STORE SPACE(18) TO WCUENTA0
      DO WARMACOD0
      STORE FECHAPAGA TO WFECHA
      @ WLINPAGA,68 say MONTOPAGA picture "#########.##"
      @ 19,00 CLEAR TO 23,79
      @ 19,00 SAY "PAGO : "
      @ 21,00 SAY "FECHA: "
      @ 22,00 SAY "BENEF: "+WEMPRESA
      @ 19,07 SAY DESCRI1
      @ 20,07 SAY DESCRI2
      @ 21,07 SAY FECHAPAGA
      STORE "PAGO YA ESISTE, ELIMINAR ? (S/N)" TO TEX
      STORE "NS" TO WCH
      DO PREGUNTA
      IF WCH = "N"
         STORE WLINPAGA - 1 TO WLINPAGA
         LOOP
      ENDIF
      IF WCH = "S"
         store montoPAGA to wmontodel
         do recloc
         REPLACE USERNAME WITH SYS(30)
         REPLACE USERDATE WITH DATE()
         DELETE
         unlock
         SELECT 1
         do recloc
         store wcuenta0     to wnocta
         STORE .T.          TO WFLAGMES
         store "PAGA"       to wcampo
         store wmontodel*-1 to wmontoproc
         DO ACTUALIZA
         unlock
      ENDIF
   ENDIF
ENDDO
RETURN


