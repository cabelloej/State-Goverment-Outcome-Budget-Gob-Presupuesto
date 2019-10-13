              STORE .T. TO WACTX
              DO WHILE WACTX
                 SELECT prdismi
                 STORE FECHA TO WFECHA
                 STORE monto TO WMONTO,wlastmonto
                 STORE SPACE(18) TO  WCTADISMI
                 STORE SPACE(18) TO  WCUENTA0
                 DO ARMADIS
                 DO ARMACOD0
                 select PRCTAS
                 FIND &WCTADISMI
                 IF EOF()
                    STORE "CODIGO DE CUENTA ORIGINAL NO EXISTE EN PLAN DE CUENTAS. <ENTER>" TO MES
                    DO AVISO WITH MES
                    STORE wscrelin7  - 1  TO wscrelin7 
                    LOOP
                 ELSE
                    STORE DESCRI1 TO WDESCTA1
                    STORE DESCRI2 TO WDESCTA2
                    STORE DESCRI3 TO WDESCTA3
                    STORE DESCRI4 TO WDESCTA4
                    STORE ORIG+TRAS+INCR-DISM TO WMONMOD
                    STORE COMP                TO WMONCOM
                 ENDIF
                 select PRDISMI
                 @ wscrelin7,30 GET WFECHA
                 @ wscrelin7,55 GET WMONTO PICTURE "#,###,###,###.##"
                 READ
                 IF (WMONMOD-WLASTMONTO)+WMONTO < WMONCOM
                    STORE "ERROR, NUEVO MONTO NO CUBRIRA LOS COMPROMISOS" TO MES
                    DO AVISO WITH MES
                    LOOP
                 ENDIF
                 IF WMONTO <> WLASTMONTO
                    STORE .T. TO WCAMBIO
                 ELSE
                    STORE .F. TO WCAMBIO
                 ENDIF
                 STORE "CONFORME ? (S/N)" TO TEX
                 STORE "SN" TO WCH
                 DO PREGUNTA
                 IF WCH = "N"
                    LOOP
                 ENDIF
                 SELECT PRDISMI
                 IF WCAMBIO
                    do recloc
                    REPLACE FECHA      WITH WFECHA
                    REPLACE MONTO      WITH WMONTO
                    REPLACE USERNAME   WITH SYS(30)
                    REPLACE USERDATE   WITH DATE()
                    FLUSH
                    SELECT PRCTAS
                    STORE .T.           TO WFLAGMES
                    *** ELIMINA MONTO ANTERIOR
                    STORE WCTADISMI     TO WNOCTA
                    STORE "DISM"        TO WCAMPO
                    STORE WLASTMONTO*-1 TO WMONTOPROC
                    DO ACTUALIZA
                    *** COLOCA EL NUEVO MONTO
                    STORE WCTADISMI     TO WNOCTA
                    STORE "DISM"        TO WCAMPO
                    STORE WMONTO        TO WMONTOPROC
                    DO ACTUALIZA
                 ENDIF
                 UNLOCK ALL
                 STORE .F. TO WACTX
              ENDDO
              SELECT PRDISMI
              RETURN
