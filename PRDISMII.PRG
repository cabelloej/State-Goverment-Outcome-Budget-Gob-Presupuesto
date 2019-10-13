              @ 21,0 CLEAR TO 24,79
              STORE 100 TO wliner7 
              STORE .T. TO WACTX
              DO WHILE WACTX
                 SELECT PRDISMI
                 STORE DATE() TO WFECHA
                 STORE 0      TO WMONTO
                 STORE wliner7  + 1 TO wliner7 
                 IF wliner7  > 18
                    SET COLOR TO W+/B
                    @ 7,1 CLEAR TO 18,78
                    STORE 7 TO wliner7 
                 ENDIF
                 @ wliner7 ,01  GET WPREANO
                 @ wliner7 ,04  GET WPREORI
                 @ wliner7 ,08  GET WPARTID
                 @ wliner7 ,13  GET WGENERI
                 @ wliner7 ,16  GET WESPECI
                 @ wliner7 ,19  GET WSUBESP
                 @ wliner7 ,22  GET WORDINA
                 READ
                 STORE SPACE(18) TO WCUENTA0
                 STORE SPACE(18) TO WCTADISMI
                 DO WARMACOD0
                 DO WARMADIS
                 IF WCUENTA0 = SPACE(18).OR.READKEY()=12.OR.READKEY()=268
                    STORE .F. TO WACTX
                    GO TOP
                    STORE RECNO() TO WINICIO7
                    STORE .T. TO FLAGJUMP7
                    STORE 0 TO WREVERSE7
                    LOOP
                 ENDIF
                 IF AT("?",WCUENTA0) > 0
                    SAVE SCRE TO S11
                    @ 4,0 CLEAR
                    CLEAR TYPEAHEAD
                    select PRCTAS
                    DO PRFORMU
                    select PRDISMI
                    RESTORE SCRE FROM S11
                    STORE SUBSTR(WCUENTA0,1,2)  TO WPREANO
                    STORE SUBSTR(WCUENTA0,3,3)  TO WPREORI
                    STORE SUBSTR(WCUENTA0,06,4) TO WPARTID
                    STORE SUBSTR(WCUENTA0,10,2) TO WGENERI
                    STORE SUBSTR(WCUENTA0,12,2) TO WESPECI
                    STORE SUBSTR(WCUENTA0,14,2) TO WSUBESP
                    STORE SUBSTR(WCUENTA0,16,3) TO WORDINA
                    store wliner7 - 1 to wliner7
                    loop 
                 ENDIF
                 IF WPREORI = "ORI"
                    STORE "INDIQUE EL ORIGEN DEL LA DISMINUCION EN LA CASILLA <DIS>" TO MES
                    DO AVISO WITH MES
                    STORE WLINER7 - 1 TO WLINER7
                    LOOP
                 ENDIF
                 STORE LEN(RTRIM(WCUENTA0)) TO WLARCOD
                 IF WLARCOD <> 18
                    STORE "FAVOR COMPLETAR EL CODIGO DEL LA DISMINUCION" TO MES
                    DO AVISO WITH MES
                    STORE WLINER7 - 1 TO WLINER7
                    LOOP
                 ENDIF                     
                 SELECT PRCTAS
                 SEEK WCTADISMI
                 IF .NOT. FOUND()
                    STORE "CODIGO DE CUENTA: "+WCTADISMI+" NO EXISTE EN PLAN DE CUENTAS." TO MES
                    DO AVISO WITH MES
                    STORE wliner7  - 1  TO wliner7 
                    LOOP
                 ELSE
                    STORE DESCRI1 TO WDESCTA1
                    STORE DESCRI2 TO WDESCTA2
                    STORE DESCRI3 TO WDESCTA3
                    STORE DESCRI4 TO WDESCTA4
                 ENDIF
                 select PRDISMI
                 SEEK WCUENTA0
                 IF FOUND()
                    STORE "CODIGO DE DISMINUCION YA EXISTE EN MAESTRO DE DISMINUCIONES." TO MES
                    DO AVISO WITH MES
                    STORE wliner7  - 1  TO wliner7 
                    LOOP
                 ELSE
                   *WAIT
                 ENDIF
                 @ wliner7,30 GET WFECHA
                 @ wliner7,55 GET WMONTO PICTURE "999,999,999.99"
                 READ
                 STORE "CONFORME ? (S/N)" TO TEX
                 STORE "SN" TO WCH
                 DO PREGUNTA
                 IF WCH = "N"
                    STORE wliner7  - 1  TO wliner7 
                    LOOP
                 ENDIF
                 SELECT PRDISMI
                 DO FILLOC
                 APPEND BLANK
                 UNLOCK 
                 do recloc
                 REPLACE PREANO     WITH WPREANO
                 REPLACE PREORI     WITH WPREORI
                 REPLACE PARTID     WITH WPARTID
                 REPLACE GENERI     WITH WGENERI
                 REPLACE ESPECI     WITH WESPECI
                 REPLACE SUBESP     WITH WSUBESP
                 REPLACE ORDINA     WITH WORDINA
                 REPLACE FECHA      WITH WFECHA
                 REPLACE MONTO      WITH WMONTO
                 REPLACE USERNAME   WITH SYS(30)
                 REPLACE USERDATE   WITH DATE()
                 FLUSH
                 IF WLARCOD = 18
                    STORE WCTADISMI  TO WNOCTA
                    STORE .T.        TO WFLAGMES
                    STORE "DISM"     TO WCAMPO
                    STORE WMONTO     TO WMONTOPROC
                    DO ACTUALIZA
                 ENDIF
                 UNLOCK ALL
              ENDDO
              SELECT PRDISMI
              RETURN

