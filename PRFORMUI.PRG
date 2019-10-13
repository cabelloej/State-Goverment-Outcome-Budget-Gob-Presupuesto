              SET COLOR TO W+/B
              @ 21,0 CLEAR TO 24,79
              STORE 100 TO WLINER1 
              STORE .T. TO WACTX
              DO WHILE WACTX
                 SELECT PRCTAS
                 STORE SPACE(LEN(DESCRI1))   TO WDESCRI1
                 STORE SPACE(LEN(DESCRI2))   TO WDESCRI2
                 STORE SPACE(LEN(DESCRI3))   TO WDESCRI3
                 STORE SPACE(LEN(DESCRI4))   TO WDESCRI4
                 STORE SPACE(LEN(UNIEJE))    TO WUNIEJE
                 STORE SPACE(LEN(TIPOINV))   TO WTIPOINV
                 STORE SPACE(LEN(REGION))    TO WREGION
                 STORE 0                     TO WMONTO
                 STORE WLINER1  + 1 TO WLINER1 
                 IF WLINER1  > 18
                    @ 7,1 CLEAR TO 18,78
                    STORE 7 TO WLINER1 
                 ENDIF
                 @ WLINER1 ,01  GET WPREANO
                 @ WLINER1 ,04  GET WPREORI
                 @ WLINER1 ,10  GET WPARTID PICT "#.##"
                 @ WLINER1 ,15  GET WGENERI
                 @ WLINER1 ,18  GET WESPECI
                 @ WLINER1 ,21  GET WSUBESP
                 @ WLINER1 ,24  GET WORDINA
                 READ
                 IF WPARTID=" .  "
                    STORE SPACE(4) TO WPARTID
                 ENDIF
                 STORE SPACE(18) TO WCUENTA0
                 DO WARMACOD0
                 IF WCUENTA0 = SPACE(18).OR.READKEY()=12.OR.READKEY()=268
                    SELECT PRCTAS
                    GO TOP
                    STORE RECNO() TO WINICIO0
                    STORE 0       TO WREVERSE0
                    STORE .T.     TO FLAGJUMP0
                    STORE .F.     TO WACTX
                    LOOP
                 ENDIF
                 STORE LEN(RTRIM(WCUENTA0))   TO WLARCOD
                 STORE LTRIM(RTRIM(WCUENTA0)) TO XCUENTA0
                 IF AT(" ",XCUENTA0) > 0
                    STORE "ERROR 1. NO DEBEN EXISTIR ESPACIOS EN BLANCO DENTRO DEL CODIGO" TO MES
                    DO AVISO WITH MES
                    STORE WLINER1  - 1  TO WLINER1
                    LOOP
                 ENDIF
                 IF (LEN(WCUENTA0) <> LEN(LTRIM(WCUENTA0)))
                    STORE "ERROR 2. NO DEBEN EXISTIR ESPACIOS EN BLANCO A LA IZQUIERDA DEL CODIGO" TO MES
                    DO AVISO WITH MES
                    STORE WLINER1  - 1  TO WLINER1
                    LOOP
                 ENDIF
                 SEEK WCUENTA0
                 IF .NOT. EOF()
                    STORE "NUMERO DE CUENTA PRESUPUESTARIA YA EXISTE. <ENTER>" TO MES
                    DO AVISO WITH MES
                    STORE WLINER1  - 1  TO WLINER1 
                    LOOP
                 ENDIF

                 *** VALIDACION DE PARTIDAS ***
                 STORE "" TO WWPPAA
                 STORE SPACE(44) TO WDESCRI1
                 STORE SPACE(44) TO WDESCRI2
                 STORE SPACE(44) TO WDESCRI3
                 STORE SPACE(44) TO WDESCRI4
                 IF WPARTID<>"    ".AND.WPARTID<>"0000"
                    STORE WWPPAA+WPARTID TO WWPPAA
                    SELECT PRPARTI
                    SEEK ALLTRIM(WWPPAA)
                    IF .NOT.EOF()
                       STORE DESCRI    TO WDESCRI1
                       STORE DESCRI2   TO WDESCRI2
                       STORE SPACE(44) TO WDESCRI3
                       STORE SPACE(44) TO WDESCRI4
                    ENDIF
                 ENDIF
                 IF WGENERI<>"  ".AND.WGENERI<>"00"
                    STORE WWPPAA+WGENERI TO WWPPAA
                    SELECT PRPARTI
                    SEEK ALLTRIM(WWPPAA)
                    IF .NOT.EOF()
                       STORE DESCRI    TO WDESCRI1
                       STORE DESCRI2   TO WDESCRI2
                       STORE SPACE(44) TO WDESCRI3
                       STORE SPACE(44) TO WDESCRI4
                    ENDIF
                 ENDIF
                 IF WESPECI<>"  ".AND.WESPECI<>"00"
                    STORE WWPPAA+WESPECI TO WWPPAA
                    SELECT PRPARTI
                    SEEK ALLTRIM(WWPPAA)
                    IF .NOT.EOF()
                       STORE DESCRI    TO WDESCRI1
                       STORE DESCRI2   TO WDESCRI2
                       STORE SPACE(44) TO WDESCRI3
                       STORE SPACE(44) TO WDESCRI4
                    ENDIF
                 ENDIF
                 IF WSUBESP<>"  ".AND.WSUBESP<>"00"
                    STORE WWPPAA+WSUBESP TO WWPPAA
                    SELECT PRPARTI
                    SEEK ALLTRIM(WWPPAA)
                    IF .NOT.EOF()
                       STORE DESCRI    TO WDESCRI1
                       STORE DESCRI2   TO WDESCRI2
                       STORE SPACE(44) TO WDESCRI3
                       STORE SPACE(44) TO WDESCRI4
                    ENDIF
                 ENDIF
                 ***
                 SAVE SCRE TO S8
                 @ 00,00 CLEAR
                 @ 00,00 SAY QQWW
                 @ 01,00 SAY "          P L A N   D E   C U E N T A S   D E L    P R E S U P U E S T O       "
                 @ 02,00 SAY "+-----------------------------------------------------+------------------------+"
                 @ 03,00 SAY "|A¥O:                                                 |COR.:                   |"
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
                 SEEK WWPREANO
                 IF EOF()
                    STORE SPACE(44) TO WDESPREANO
                 ELSE
                    STORE DESCRI1 TO WDESPREANO
                 ENDIF
                 STORE SUBSTR(WCUENTA0,1,5) TO WWPREORI
                 SEEK WWPREORI
                 IF EOF()
                    STORE SPACE(44) TO WDESPREORI
                 ELSE
                    STORE DESCRI1 TO WDESPREORI
                 ENDIF
                 IF WWPPAA = SPACE(10)
                    STORE SPACE(44) TO WDESPARTID
                    STORE SPACE(44) TO WDESGENERI
                    STORE SPACE(44) TO WDESESPECI
                    STORE SPACE(44) TO WDESSUBESP
                 ELSE
                    SELECT PRPARTI
                    STORE SUBSTR(WCUENTA0,6,4) TO WWPARTID
                    SEEK WWPARTID
                    IF EOF()
                       STORE SPACE(44) TO WDESPARTID
                    ELSE
                       STORE DESCRI TO WDESPARTID
                    ENDIF
                    STORE SUBSTR(WCUENTA0,6,6) TO WWGENERI
                    SEEK WWGENERI
                    IF EOF()
                       STORE SPACE(44) TO WDESGENERI
                    ELSE
                       STORE DESCRI TO WDESGENERI
                    ENDIF
                    STORE SUBSTR(WCUENTA0,6,8) TO WWESPECI
                    SEEK WWESPECI
                    IF EOF()
                       STORE SPACE(44) TO WDESESPECI
                    ELSE
                       STORE DESCRI TO WDESESPECI
                    ENDIF
                    STORE SUBSTR(WCUENTA0,6,10) TO WWSUBESP
                    SEEK WWSUBESP
                    IF EOF()
                       STORE SPACE(44) TO WDESSUBESP
                    ELSE
                       STORE DESCRI TO WDESSUBESP
                    ENDIF
                 ENDIF
                 SELECT PRCTAS
                 @ 03,05 SAY WPREANO+"   "+WDESPREANO
                 @ 04,05 SAY WPREORI+"  "+WDESPREORI
                 @ 11,05 SAY WPARTID+" "+WDESPARTID
                 @ 12,05 SAY WGENERI+"   "+WDESGENERI
                 @ 13,05 SAY WESPECI+"   "+WDESESPECI
                 @ 14,05 SAY WSUBESP+"   "+WDESSUBESP
                 @ 16,05 SAY WPARTID+"."+WGENERI+"."+WESPECI+"."+WSUBESP+"."+WORDINA

                 @ 17,01 GET WDESCRI1
                 @ 18,01 GET WDESCRI2
                 @ 19,01 GET WDESCRI3
                 @ 20,01 GET WDESCRI4
                 READ

                 IF WLARCOD = 05
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

                 IF WLARCOD = 18
                    SELECT PRPARTI
                    STORE WPARTID+SPACE(6) TO WCLAVE
                    SEEK WCLAVE
                    IF FOUND()
                       STORE TIPO TO WTIPO
                    ELSE
                       STORE SPACE(1) TO WTIPO
                    ENDIF
                    DO WHILE .T.
                       STORE "TIPO DE EGRESO: (C)orriente, (I)nversion" TO MES
                       DO MENSAJE WITH MES
                       @ 17,51 GET WTIPO
                       READ
                       IF WTIPO="C".OR.WTIPO="I"
                          EXIT
                       ENDIF
                    ENDDO
                    SELECT PRCTAS
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
                             *   STORE "EN CODIGO DE OBRAS, LA SUB-ESPECIFICA DEBE SER IGUAL CODIGO DE LA REGION" TO TEX
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
                    IF WTIPO="C"
                       @ 03,62 GET Wmonto PICTURE "99,999,999,999.99"
                    ELSE
                       @ 04,62 GET Wmonto PICTURE "99,999,999,999.99"
                    ENDIF
                    READ
                    IF WTIPO="C"
                       STORE WMONTO TO WMONTOC
                       STORE 0      TO WMONTOI
                    ELSE
                       STORE 0      TO WMONTOC
                       STORE WMONTO TO WMONTOI
                    ENDIF
                 ENDIF

                 STORE "CONFORME ? (S/N)" TO TEX
                 STORE "SN" TO WCH
                 DO PREGUNTA
                 RESTORE SCRE FROM S8
                 IF WCH = "N"
                    STORE WLINER1  - 1  TO WLINER1 
                    LOOP
                 ENDIF
                 SELECT PRCTAS
                 DO FILLOC
                 APPEND BLANK
                 UNLOCK all 
                 DO RECLOC
                 REPLACE PREANO     WITH WPREANO
                 REPLACE PREORI     WITH WPREORI
                 REPLACE PARTID     WITH WPARTID
                 REPLACE GENERI     WITH WGENERI
                 REPLACE ESPECI     WITH WESPECI
                 REPLACE SUBESP     WITH WSUBESP
                 REPLACE ORDINA     WITH WORDINA
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
                 IF WLARCOD = 18
                    STORE WCUENTA0 TO WNOCTA
                    STORE .F.      TO WFLAGMES
                    ***
                    STORE "ORIG"   TO WCAMPO
                    STORE WMONTO   TO WMONTOPROC
                    DO ACTUALIZA
                    ***
                    IF WTIPO="C"
                       STORE "CORR"   TO WCAMPO
                       STORE WMONTOC  TO WMONTOPROC
                       DO ACTUALIZA
                    ELSE
                       STORE "INVE"   TO WCAMPO
                       STORE WMONTOI  TO WMONTOPROC
                       DO ACTUALIZA
                    ENDIF
                 ENDIF
                 UNLOCK ALL
              ENDDO
              SELECT PRCTAS
              RETURN
