              store recno() to wstarting
              @ 21,0 CLEAR TO 24,79
              STORE .T. TO WACTX
              DO WHILE WACTX
                 SELECT PRCTAS
                 STORE DESCRI1    TO WDESCRI1
                 STORE DESCRI2    TO WDESCRI2
                 STORE DESCRI3    TO WDESCRI3
                 STORE DESCRI4    TO WDESCRI4
                 STORE ORIG       TO WORIG,WLASTORIG
                 STORE CORR       TO WCORR,WLASTCORR
                 STORE INVE       TO WINVE,WLASTINVE
                 STORE TRAS       TO WTRAS
                 STORE INCR       TO WINCR
                 STORE DISM       TO WDISM
                 STORE COMP       TO WCOMP
                 STORE CAUS       TO WCAUS
                 STORE PAGA       TO WPAGA
                 STORE UNIEJE     TO WUNIEJE
                 STORE TIPOINV    TO WTIPOINV
                 STORE REGION     TO WREGION
                 STORE SPACE(18)  TO WCUENTA0
                 DO ARMACOD0
                 STORE WCUENTA0             TO WLASTCTA0
                 STORE LEN(RTRIM(WCUENTA0)) TO WLARCOD
                 SAVE SCRE TO S8
                 @ 00,00 CLEAR
                 @ 00,00 SAY QQWW
                 @ 01,00 SAY "          P L A N   D E   C U E N T A S   D E L    P R E S U P U E S T O       "
                 @ 02,00 SAY "+-----------------------------------------------------+------------------------+"
                 @ 03,00 SAY "|A�O:                                                 |COR.:                   |"
                 @ 04,00 SAY "|ORI:                                                 |INV.:                   |"
                 @ 05,00 SAY "|   :                                                 |TOT.:                   |"
                 @ 06,00 SAY "|   :                                                 |------------------------|"
                 @ 07,00 SAY "|   :                                                 |TRA.:                   |"
                 @ 08,00 SAY "|   :                                                 |INC.:                   |"
                 @ 09,00 SAY "|   :                                                 |DIS.:                   |"
                 @ 10,00 SAY "|   :                                                 |MOD.:                   |"
                 @ 11,00 SAY "|PAR:                                                 |COM.:                   |"
                 @ 12,00 SAY "|GEN:                                                 |CAU.:                   |"
                 @ 13,00 SAY "|ESP:                                                 |PAG.:                   |"
                 @ 14,00 SAY "|SUE:                                                 |DIS.:                   |"
                 @ 15,00 SAY "+-----------------------------------------------+-----|------------------------|"
                 @ 16,00 SAY "|COD:                                           |T/PAR|EJE.:                   |"
                 @ 17,00 SAY "|                                               |     |                        |"
                 @ 18,00 SAY "|                                               |-----|------------------------|"
                 @ 19,00 SAY "|                                               |T/INV|REG.:                   |"
                 @ 20,00 SAY "|                                               |     |                        |"
                 @ 21,00 SAY "+-----------------------------------------------+-----+------------------------+"
                 SELECT PRCTAS
                 STORE SUBSTR(WCUENTA0,1,2) TO WWPREANO
                 seek WWPREANO
                 IF EOF()
                    STORE SPACE(25) TO WDESPREANO
                 ELSE
                    STORE DESCRI1 TO WDESPREANO
                 ENDIF
                 STORE SUBSTR(WCUENTA0,1,5) TO WWPREORI
                 seek WWPREORI
                 IF EOF()
                    STORE SPACE(25) TO WDESPREORI
                 ELSE
                    STORE DESCRI1 TO WDESPREORI
                 ENDIF
                 SELECT PRPARTI
                 STORE SUBSTR(WCUENTA0,06,4) TO WWPARTID
                 seek WWPARTID
                 IF EOF()
                    STORE SPACE(25) TO WDESPARTID
                 ELSE
                    STORE DESCRI TO WDESPARTID
                 ENDIF
                 STORE SUBSTR(WCUENTA0,06,6) TO WWGENERI
                 seek WWGENERI
                 IF EOF()
                    STORE SPACE(25) TO WDESGENERI
                 ELSE
                    STORE DESCRI TO WDESGENERI
                 ENDIF
                 STORE SUBSTR(WCUENTA0,06,8) TO WWESPECI
                 seek WWESPECI
                 IF EOF()
                    STORE SPACE(25) TO WDESESPECI
                 ELSE
                    STORE DESCRI TO WDESESPECI
                 ENDIF
                 STORE SUBSTR(WCUENTA0,06,10) TO WWSUBESP
                 seek WWSUBESP
                 IF EOF()
                    STORE SPACE(25) TO WDESSUBESP
                 ELSE
                    STORE DESCRI TO WDESSUBESP
                 ENDIF
                 SELECT PRUNID
                 seek WUNIEJE
                 IF EOF()
                    STORE SPACE(24) TO WDESUNIEJE
                 ELSE
                    STORE DESCRI    TO WDESUNIEJE
                 ENDIF
                 SELECT PRREGI
                 SEEK WREGION
                 IF EOF()
                    STORE SPACE(24) TO WDESREGI
                 ELSE
                    STORE DESCRI    TO WDESREGI
                 ENDIF

                 SELECT PRCTAS
                 @ 03,05 SAY WPREANO+"   "+WDESPREANO
                 @ 04,05 SAY WPREORI+"  "+WDESPREORI
                 @ 11,05 SAY WPARTID+" "+WDESPARTID
                 @ 12,05 SAY WGENERI+"   "+WDESGENERI
                 @ 13,05 SAY WESPECI+"   "+WDESESPECI
                 @ 14,05 SAY WSUBESP+"   "+WDESSUBESP
                 @ 16,05 SAY WPARTID+"."+WGENERI+"."+WESPECI+"."+WSUBESP+"."+WORDINA

                 @ 03,62 SAY WCORR PICTURE "99,999,999,999.99"
                 @ 04,62 SAY WINVE PICTURE "99,999,999,999.99"
                 @ 05,62 SAY WORIG PICTURE "99,999,999,999.99"
                 @ 07,62 SAY WTRAS PICTURE "99,999,999,999.99"
                 @ 08,62 SAY WINCR PICTURE "99,999,999,999.99"
                 @ 09,62 SAY WDISM PICTURE "99,999,999,999.99"
                 @ 10,62 SAY WORIG+WTRAS+WINCR-WDISM PICTURE "99,999,999,999.99"
                 @ 11,62 SAY WCOMP PICTURE "99,999,999,999.99"
                 @ 12,62 SAY WCAUS PICTURE "99,999,999,999.99"
                 @ 13,62 SAY WPAGA PICTURE "99,999,999,999.99"
                 @ 14,62 SAY (WORIG+WTRAS+WINCR-WDISM)-WCOMP PICTURE "99,999,999,999.99"
                 @ 16,62 SAY WUNIEJE
                 @ 17,55 SAY SUBSTR(WDESUNIEJE,1,24)
                 @ 20,55 SAY SUBSTR(WDESREGI,1,24)
                 @ 17,01 GET WDESCRI1
                 @ 18,01 GET WDESCRI2
                 @ 19,01 GET WDESCRI3
                 @ 20,01 GET WDESCRI4
                 READ
                 IF READKEY() = 12 .OR. READKEY() = 268
                    SELECT PRCTAS
                    RESTORE SCRE FROM S8
                    STORE .F. TO WACTX
                    RETURN
                 ENDIF

                 IF WLARCOD = 5
                    @ 16,60 GET WUNIEJE
                    READ
                    SELECT PRUNID
                    SEEK WUNIEJE
                    IF EOF()
                       STORE "UNIDAD EJECUTORA NO REGISTRADA, INGRESAR ? (S/N)" TO TEX
                       STORE "SN" TO WCH
                       DO PREGUNTA
                       IF WCH = "S"
                          SAVE SCRE TO SCREEJC
                          STORE WUNIEJE TO WSEL
                          DO PRUNID
                          STORE WSEL TO WUNIEJE
                          RESTORE SCRE FROM SCREEJC
                          LOOP
                       ENDIF
                    ELSE
                       STORE ALLTRIM(DESCRI) TO TEX
                       DO AVISO WITH TEX
                       @ 17,55 SAY SUBSTR(DESCRI,1,24)
                    ENDIF
                 ENDIF
                 store .f. to wrecalc
                 IF WLARCOD = 18
                    DO WHILE .T.
                       IF WCORR>0
                          STORE "C" TO WTIPO
                          STORE "C" TO WLASTTIPO
                       ELSE
                          STORE "I" TO WTIPO
                          STORE "I" TO WLASTTIPO
                       ENDIF
                       STORE "TIPO DE GASTO : (C)orriente, (I)nversion" TO MES
                       DO MENSAJE WITH MES
                       @ 17,51 GET WTIPO
                       READ
                       IF WTIPO="C".OR.WTIPO="I"
                          EXIT
                       ENDIF
                    ENDDO
                    IF WTIPO="I"
                       *** TIPO DE INVERSION
                       DO WHILE .T.
                          STORE "TIPO DE INVERSION: (O)bra, o(R)dinaria" TO MES
                          DO MENSAJE WITH MES
                          @ 20,51 GET WTIPOINV
                          READ
                          IF WTIPOINV="O".OR.WTIPOINV="R"
                             EXIT
                          ENDIF
                       ENDDO
                       IF WTIPOINV="O"
                          DO WHILE .T.
                             @ 19,60 GET WREGION
                             READ
                             SELECT PRREGI
                             SEEK WREGION
                             IF .NOT.FOUND()
                                STORE "REGION NO REGISTRADA, INGRESAR ? (S/N)" TO TEX
                                STORE "SN" TO WCH
                                DO PREGUNTA
                                IF WCH = "S"
                                   SAVE SCRE TO SCREEJC
                                   STORE SPACE(2) TO WSEL
                                   DO PRREGI
                                   STORE WSEL TO WREGION
                                   RESTORE SCRE FROM SCREEJC
                                   LOOP
                                ENDIF
                             ELSE
                                @ 20,55 SAY SUBSTR(DESCRI,1,24)
                                EXIT
                             ENDIF
                             *IF WREGION<>WSUBESP
                             *   STORE "EN CODIGO DE OBRAS, LA SUB-ESPECIFICA DEBE SER IGUAL CODIGO DE REGIONPIO" TO TEX
                             *   DO AVISO WITH TEX
                             *ELSE
                             *   EXIT
                             *ENDIF
                          ENDDO
                       ELSE
                          STORE SPACE(2) TO WREGION
                       ENDIF
                    ELSE
                       STORE SPACE(1) TO WTIPOINV
                       STORE SPACE(2) TO WREGION
                    ENDIF

                    STORE WORIG TO WLASTORIG
                    IF WTIPO="C"
                       @ 03,62 GET WORIG PICTURE "99,999,999,999.99"
                    ELSE
                       @ 04,62 GET WORIG PICTURE "99,999,999,999.99"
                    ENDIF
                    READ
                    IF WTIPO="C"
                       STORE WORIG  TO WCORR
                       STORE 0      TO WINVE
                    ELSE
                       STORE 0      TO WCORR
                       STORE WORIG  TO WINVE
                    ENDIF
                    IF WORIG+WTRAS+WINCR-WDISM < WCOMP
                       STORE "MONTO ORIGINAL+TRASPASOS+INCREMENTOS-DISMINUC. NO CUBRE TRANSACCION" TO MES
                       DO AVISO WITH MES
                       STORE WLASTORIG TO WORIG
                    ENDIF
                    IF WLASTORIG <> WORIG .OR. WLASTTIPO<>WTIPO
                       STORE .T. TO WRECALC
                    ELSE
                       STORE .F. TO WRECALC
                    ENDIF
                 ENDIF

                 SELECT PRCTAS
                 GO WSTARTING
                 STORE "CONFORME ? (S/N)" TO TEX
                 STORE "SN" TO WCH
                 DO PREGUNTA
                 RESTORE SCRE FROM S8
                 IF WCH = "N"
                    LOOP
                 ENDIF
                 REPLACE DESCRI1    WITH WDESCRI1
                 REPLACE DESCRI2    WITH WDESCRI2
                 REPLACE DESCRI3    WITH WDESCRI3
                 REPLACE DESCRI4    WITH WDESCRI4
                 REPLACE UNIEJE     WITH WUNIEJE
                 REPLACE TIPOINV    WITH WTIPOINV
                 REPLACE REGION     WITH WREGION
                 REPLACE USERNAME   WITH WUSERCODE
                 REPLACE USERDATE   WITH DATE()
                 FLUSH
                 IF WRECALC
                    IF WLARCOD = 18
                       STORE .T. TO FLAGJUMP0
                       *** ELIMINA EL VIEJO MONTO
                       STORE WLASTCTA0     TO WNOCTA
                       STORE .F.           TO WFLAGMES
                       ***
                       STORE "ORIG"        TO WCAMPO
                       STORE WLASTORIG*-1  TO WMONTOPROC
                       DO ACTUALIZA
                       ***
                       STORE "CORR"        TO WCAMPO
                       STORE WLASTCORR*-1  TO WMONTOPROC
                       DO ACTUALIZA
                       ***
                       STORE "INVE"        TO WCAMPO
                       STORE WLASTINVE*-1  TO WMONTOPROC
                       DO ACTUALIZA

                       *** INGRESA EL NUEVO MONTO
                       STORE WCUENTA0      TO WNOCTA
                       ***
                       STORE "ORIG"        TO WCAMPO
                       STORE WORIG         TO WMONTOPROC
                       DO ACTUALIZA
                       ***
                       STORE "CORR"        TO WCAMPO
                       STORE WCORR         TO WMONTOPROC
                       DO ACTUALIZA
                       ***
                       STORE "INVE"        TO WCAMPO
                       STORE WINVE         TO WMONTOPROC
                       DO ACTUALIZA
                    endif
                 ENDIF
                 STORE .F.     TO WACTX
              ENDDO
              SELECT PRCTAS
              RETURN

