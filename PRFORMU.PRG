SET COLOR TO w+/b
@ 4,0 CLEAR
STORE "FORMULACION DE PRESUPUESTOS" TO WHEADER0
@ 4,40 - (LEN(WHEADER0)/2) SAY WHEADER0
@ 5,0
@ 05,01  SAY "A�-ORG   G.PA.GE.ES.SE.ORD       MONTO ORIGINAL"
@ 6,0 TO 19,79
STORE  "INCLUIR    " TO XMENU1
STORE  "CONS/MODIF." TO XMENU2
STORE  "ELIMINAR   " TO XMENU3
STORE  "SELECCIONAR" TO XMENU4
STORE  "BUSCAR     " TO XMENU5
STORE 4 TO WMENU0
STORE .T. TO XFLAG0
STORE .F. TO WREGS0
SELECT PRCTAS
GO TOP
DO WHILE .NOT. EOF()
   STORE .T. TO WREGS0
   EXIT
ENDDO
IF .NOT. WREGS0
   DO PRFORMUI
   SELECT PRCTAS
ENDIF
GO TOP
STORE 12 TO WRANGO0
STORE RECNO() TO WINICIO0
STORE 0 TO WREVERSE0
STORE 0 TO WEDILIN0
STORE .T. TO FLAGJUMP0
STORE .T. TO WEDITAR0
DO WHILE WEDITAR0
   IF FLAGJUMP0
      STORE 0       TO WCONT0
      STORE 07      TO WLINE0
      SELECT PRCTAS
      GO WINICIO0
      SET COLOR TO w+/b
   *  @ 7,1 CLEAR TO 18,78
      DO WHILE .NOT. EOF() .AND. WCONT0 < WRANGO0
         STORE WLINE0+WCONT0 TO WSCRELIN0
         STORE WLINE0+WCONT0 TO WLASTLIN0
         STORE RECNO() TO WLASTREC0
         @ WSCRELIN0 ,01  SAY PREANO+"-"
         @ WSCRELIN0 ,04  SAY PREORI
         @ WSCRELIN0 ,10  SAY PARTID+"."
         @ WSCRELIN0 ,15  SAY GENERI+"."
         @ WSCRELIN0 ,18  SAY ESPECI+"."
         @ WSCRELIN0 ,21  SAY SUBESP+"."
         @ WSCRELIN0 ,24  SAY ORDINA
         @ WSCRELIN0 ,47  SAY ORIG picture "#,###,###,###,###.##"
         STORE WCONT0 + 1 TO WCONT0
         SKIP
      ENDDO
      STORE .F. TO FLAGJUMP0
   ENDIF
   *** RELLENO DE ESP. VACION (SI NO HAY SUF. REGISTROS)
   STORE WCONT0 TO WFILCON
   STORE WLASTLIN0 TO WFILLIN
   SET COLOR TO W+/B
   DO WHILE WFILCON < WRANGO0
      STORE WFILLIN + 1 TO WFILLIN
      @ WFILLIN, 1 SAY SPACE(77)
      STORE WFILCON + 1 TO WFILCON
   ENDDO
   ***
   IF WREVERSE0 = 0
      STORE WLASTREC0 TO WREVERSE0
      STORE WLASTLIN0 TO WEDILIN0
      STORE WINICIO0  TO WCLEARREC0
      STORE WLINE0    TO WCLEARLIN0
   ENDIF
   ** PARA BORRAR EL REGISTRO ANTERIOR
   SET COLOR TO W+/B
   GO WCLEARREC0
   STORE WCLEARLIN0 TO WSCRELIN0
   @ WSCRELIN0 ,01  SAY PREANO+"-"
   @ WSCRELIN0 ,04  SAY PREORI
   @ WSCRELIN0 ,10  SAY PARTID+"."
   @ WSCRELIN0 ,15  SAY GENERI+"."
   @ WSCRELIN0 ,18  SAY ESPECI+"."
   @ WSCRELIN0 ,21  SAY SUBESP+"."
   @ WSCRELIN0 ,24  SAY ORDINA
   @ WSCRELIN0 ,47  SAY ORIG picture "#,###,###,###,###.##"
   ** PARA MARCAR EL REGISTRO ACTUAL
   SET COLOR TO B/W+
   GO WREVERSE0
   STORE WEDILIN0 TO WSCRELIN0
   @ WSCRELIN0 ,01  SAY PREANO+"-"
   @ WSCRELIN0 ,04  SAY PREORI
   @ WSCRELIN0 ,10  SAY PARTID+"."
   @ WSCRELIN0 ,15  SAY GENERI+"."
   @ WSCRELIN0 ,18  SAY ESPECI+"."
   @ WSCRELIN0 ,21  SAY SUBESP+"."
   @ WSCRELIN0 ,24  SAY ORDINA
   @ WSCRELIN0 ,47  SAY ORIG picture "#,###,###,###,###.##"
   STORE WREVERSE0 TO WCLEARREC0
   STORE WSCRELIN0 TO WCLEARLIN0
   SET COLOR TO W+/B
   @ 21,01 SAY DESCRI1
   @ 22,01 SAY DESCRI2
   @ 23,01 SAY DESCRI3
   @ 24,01 SAY DESCRI4
   *** PARA INDICAR LA ROTACION DEL MENU (SI LA HUBO)
   IF XFLAG0
      SET COLOR TO W+/B
      @ 20,05 SAY  XMENU1
      @ 20,20 SAY  XMENU2
      @ 20,35 SAY  XMENU3
      @ 20,50 SAY  XMENU4
      @ 20,65 SAY  XMENU5
      SET COLOR TO B/W+
      STORE "XMENU"+STR(WMENU0,1) TO WMACRO
      @ 20,5+((WMENU0-1)*15)  SAY &WMACRO
      STORE .F. TO XFLAG0
      SET COLOR TO W+/B
   ENDIF
   *** CAPTURA DE INTERACTIVIDAD
   CLEAR TYPEAHEAD
   STORE INKEY(0) TO WMUEVE0
   *** PAGE DOWN
   IF WMUEVE0 = 3
      GO WINICIO0
      SKIP +12
      IF .NOT. EOF()
         STORE RECNO() TO WINICIO0
         STORE .T.     TO FLAGJUMP0
         STORE WINICIO0 TO WREVERSE0
         STORE WLINE0   TO WEDILIN0
         STORE WINICIO0 TO WCLEARREC0
         STORE WLINE0   TO WCLEARLIN0
      ENDIF
   ENDIF
   *** PAGE UP
   IF WMUEVE0 =  18
      GO WINICIO0
      SKIP -12
      STORE RECNO() TO WINICIO0
      STORE .T. TO FLAGJUMP0
      STORE 0 TO WREVERSE0
   ENDIF
   *** HOME
   IF WMUEVE0 = 1
      GO TOP
      IF .NOT. EOF()
         STORE RECNO() TO WINICIO0
         STORE .T. TO FLAGJUMP0
         STORE WINICIO0 TO WREVERSE0
         STORE WLINE0   TO WEDILIN0
         STORE WINICIO0 TO WCLEARREC0
         STORE WLINE0   TO WCLEARLIN0
      ENDIF
   ENDIF
   *** END
   IF WMUEVE0 = 6
      GO BOTT
      SKIP -11
      STORE RECNO() TO WINICIO0
      STORE 0 TO WREVERSE0
      STORE .T. TO FLAGJUMP0
   ENDIF
   *** DOWN ARROW
   IF WMUEVE0 = 24
      SKIP + 1
      IF WEDILIN0 < (WLINE0+(WCONT0-1))
         STORE WREVERSE0    TO WCLEARREC0
         STORE RECNO()     TO WREVERSE0
         STORE WEDILIN0     TO WCLEARLIN0
         STORE WEDILIN0 + 1 TO WEDILIN0
      ELSE
         IF .NOT. EOF()
            GO WINICIO0
            SKIP +1
            STORE RECNO() TO WINICIO0
            STORE .T.     TO FLAGJUMP0
            STORE 0       TO WREVERSE0
         ELSE
            GO WINICIO0
            STORE RECNO() TO WINICIO0
            STORE .T.     TO FLAGJUMP0
            STORE 0       TO WREVERSE0
         ENDIF
      ENDIF
   ENDIF
   *** UP ARROW
   IF WMUEVE0 = 5
      SKIP -1
      IF WEDILIN0 > WLINE0
         STORE WREVERSE0    TO WCLEARREC0
         STORE RECNO()     TO WREVERSE0
         STORE WEDILIN0     TO WCLEARLIN0
         STORE WEDILIN0 - 1 TO WEDILIN0
      ELSE
         GO WINICIO0
         SKIP -1
         STORE RECNO() TO WINICIO0
         STORE .T.     TO FLAGJUMP0
         STORE WINICIO0 TO WREVERSE0
         STORE WLINE0   TO WEDILIN0
         STORE WINICIO0 TO WCLEARREC0
         STORE WLINE0   TO WCLEARLIN0
      ENDIF
   ENDIF
   *** RIGHT ARROW
   IF WMUEVE0 = 4
      STORE .T. TO XFLAG0
      STORE WMENU0+1 TO WMENU0
      IF WMENU0 > 5
         STORE 1 TO WMENU0
      ENDIF
   ENDIF
   *** LEFT ARROW
   IF WMUEVE0 = 19
      STORE .T. TO XFLAG0
      STORE WMENU0-1 TO WMENU0
      IF WMENU0 < 1
         STORE 5 TO WMENU0
      ENDIF
   ENDIF
   *** ESCAPE
   IF WMUEVE0 = 27
      STORE SPACE(18) TO WCUENTA0
      DO ARMACOD0
      RETURN
   ENDIF
   *** ENTER (INICIO DE OPERACIONES DE ACTUALIZACION DE DATOS
   IF WMUEVE0 = 13
      store space(18) to WCUENTA0
      DO ARMACOD0
      STORE LEN(WCUENTA0) TO WLARCOD
      DO CASE    
         CASE WMENU0 = 1
              DO PRFORMUI
              SELECT PRCTAS
         CASE WMENU0 = 2
              DO RECLOC
              STORE SPACE(18) TO WCUENTA0
              DO ARMACOD0
              STORE SUBSTR(WCUENTA0,1,2)  TO WPREANO
              STORE SUBSTR(WCUENTA0,3,3)  TO WPREORI
              STORE SUBSTR(WCUENTA0,6,4)  TO WPARTID
              STORE SUBSTR(WCUENTA0,10,2) TO WGENERI
              STORE SUBSTR(WCUENTA0,12,2) TO WESPECI
              STORE SUBSTR(WCUENTA0,14,2) TO WSUBESP
              STORE SUBSTR(WCUENTA0,16,3) TO WORDINA
              DO PRFORMUM
              SELECT PRCTAS
              UNLOCK
              STORE RECNO() TO WINICIO0
              STORE .T.     TO FLAGJUMP0
              STORE RECNO() TO WREVERSE0
              STORE RECNO() TO WCLEARREC0
              STORE WLINE0  TO WEDILIN0
              STORE WLINE0  TO WCLEARLIN0
         CASE WMENU0 = 3
              DO RECLOC
              DO PRFORMUE
              UNLOCK
         CASE WMENU0 = 4
              STORE SPACE(18) TO WCUENTA0
              DO ARMACOD0
              STORE SUBSTR(WCUENTA0,1,2)  TO WPREANO
              STORE SUBSTR(WCUENTA0,3,3)  TO WPREORI
              STORE SUBSTR(WCUENTA0,6,4)  TO WPARTID
              STORE SUBSTR(WCUENTA0,10,2) TO WGENERI
              STORE SUBSTR(WCUENTA0,12,2) TO WESPECI
              STORE SUBSTR(WCUENTA0,14,2) TO WSUBESP
              STORE SUBSTR(WCUENTA0,16,3) TO WORDINA
              RETURN
         CASE WMENU0 = 5
              SAVE SCRE TO S9
              @ WSCRELIN0 ,01  GET WPREANO
              @ WSCRELIN0 ,04  GET WPREORI
              @ WSCRELIN0 ,08  GET WPARTID
              @ WSCRELIN0 ,13  GET WGENERI
              @ WSCRELIN0 ,16  GET WESPECI
              @ WSCRELIN0 ,19  GET WSUBESP
              @ WSCRELIN0 ,22  GET WORDINA
              READ
              STORE SPACE(18) TO WCUENTA0
              DO WARMACOD0
              IF WCUENTA0 <> SPACE(18)
                 SEEK WCUENTA0
                 IF .NOT. EOF()
                    STORE RECNO() TO WINICIO0
                    STORE .T.     TO FLAGJUMP0
                    STORE RECNO() TO WREVERSE0
                    STORE RECNO() TO WCLEARREC0
                    STORE WLINE0  TO WEDILIN0
                    STORE WLINE0  TO WCLEARLIN0
                 ELSE
                    STORE "CODIGO NO REGISTRADO. <ENTER>" TO MES
                    DO AVISO WITH MES
                    RESTORE SCRE FROM S9
                 ENDIF
              ELSE
                 RESTORE SCRE FROM S9
              ENDIF
      ENDCASE
   ENDIF
ENDDO
RETURN
