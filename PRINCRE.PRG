STORE .F. TO FLAGDEL7
select 1
use prctas   index prctas1
select 2
use prparti  index prparti
select 3
use prunid   index prunid
select 4
use prbenef  index prbenef1,prbenef2
select 5
use prsopor  index prsopor
select 6
use princre  index princre
SET COLOR TO w+/b
@ 4,0 CLEAR
STORE "INCREMENTOS DEL PRESUPUESTO" TO WHEADER7
@ 4,40 - (LEN(WHEADER7)/2) SAY WHEADER7
@ 5,0
@ 05,01  SAY "A¥-INC PART-GE-ES-SE-ORD     FECHA                          INCREMENTO"
@ 6,0 TO 19,79
STORE  "INCLUIR    " TO XMENU1
STORE  "VER/MODIFI." TO XMENU2
STORE  "ELIMINAR   " TO XMENU3
STORE  "SELECCIONAR" TO XMENU4
STORE  "BUSCAR     " TO XMENU5
STORE 4 TO WMENU7
STORE .T. TO XFLAG7
STORE .F. TO WREGS7
select princre
GO TOP
DO WHILE .NOT. EOF()
   STORE .T. TO WREGS7
   EXIT
ENDDO
IF .NOT. WREGS7
   DO PRINCREI
   SELECT princre
ENDIF
GO TOP
STORE .F. TO WREGS7
DO WHILE .NOT. EOF()
   STORE .T. TO WREGS7
   EXIT
ENDDO
IF .NOT. WREGS7
   CLOSE DATA
   CLOSE INDEX
   RETURN
ENDIF
GO TOP
STORE 12 TO WRANGO7
STORE RECNO() TO WINICIO7
STORE 0 TO WREVERSE7
STORE 0 TO WEDILIN7
STORE .T. TO FLAGJUMP7
STORE .T. TO WEDITAR7
DO WHILE WEDITAR7
   IF FLAGJUMP7
      STORE 0       TO WCONT7
      STORE 07      TO WLINE7
      IF .NOT. EOF()
         GO WINICIO7
      ELSE
         EXIT
      ENDIF
      SET COLOR TO W+/B
   *  @ 7,1 CLEAR TO 18,78
      DO WHILE .NOT. EOF() .AND. WCONT7 < WRANGO7
         STORE WLINE7+WCONT7 TO wscrelin7
         STORE WLINE7+WCONT7 TO WLASTLIN7
         STORE RECNO() TO WLASTREC7
         @ wscrelin7 ,01  SAY PREANO+"-"
         @ wscrelin7 ,04  SAY PREORI
         @ wscrelin7 ,08  SAY PARTID+"-"
         @ wscrelin7 ,13  SAY GENERI+"-"
         @ wscrelin7 ,16  SAY ESPECI+"-"
         @ wscrelin7 ,19  SAY SUBESP+"-"
         @ wscrelin7 ,22  SAY ORDINA
         @ wscrelin7 ,30  SAY FECHA
         @ wscrelin7 ,55  SAY MONTO picture "#,###,###,###.##"
         STORE WCONT7 + 1 TO WCONT7
         SKIP
      ENDDO
      STORE .F. TO FLAGJUMP7
   ENDIF
   *** RELLENO DE ESP. VACION (SI NO HAY SUF. REGISTROS)
   STORE WCONT7 TO WFILCON
   STORE WLASTLIN7 TO WFILLIN
   SET COLOR TO W+/B
   DO WHILE WFILCON < WRANGO7
      STORE WFILLIN + 1 TO WFILLIN
      @ WFILLIN, 1 SAY SPACE(77)
      STORE WFILCON + 1 TO WFILCON
   ENDDO
   ***
   IF WREVERSE7 = 0
      STORE WLASTREC7 TO WREVERSE7
      STORE WLASTLIN7 TO WEDILIN7
      STORE WINICIO7  TO WCLEARREC7
      STORE WLINE7    TO WCLEARLIN7
   ENDIF
   ** PARA BORRAR EL REGISTRO ANTERIOR
   SET COLOR TO W+/B
   GO WCLEARREC7
   STORE WCLEARLIN7 TO wscrelin7
   @ wscrelin7 ,01  SAY PREANO+"-"
   @ wscrelin7 ,04  SAY PREORI
   @ wscrelin7 ,08  SAY PARTID+"-"
   @ wscrelin7 ,13  SAY GENERI+"-"
   @ wscrelin7 ,16  SAY ESPECI+"-"
   @ wscrelin7 ,19  SAY SUBESP+"-"
   @ wscrelin7 ,22  SAY ORDINA
   @ wscrelin7 ,30  SAY FECHA
   @ wscrelin7 ,55  SAY MONTO picture "#,###,###,###.##"
   ** PARA MARCAR EL REGISTRO ACTUAL
   SET COLOR TO B/W+
   GO WREVERSE7
   STORE WEDILIN7 TO wscrelin7
   @ wscrelin7 ,01  SAY PREANO+"-"
   @ wscrelin7 ,04  SAY PREORI
   @ wscrelin7 ,08  SAY PARTID+"-"
   @ wscrelin7 ,13  SAY GENERI+"-"
   @ wscrelin7 ,16  SAY ESPECI+"-"
   @ wscrelin7 ,19  SAY SUBESP+"-"
   @ wscrelin7 ,22  SAY ORDINA
   @ wscrelin7 ,30  SAY FECHA
   @ wscrelin7 ,55  SAY MONTO picture "#,###,###,###.##"
   STORE WREVERSE7 TO WCLEARREC7
   STORE wscrelin7 TO WCLEARLIN7
   SET COLOR TO W+/B
 * @ 21,01 SAY "D E S C R I P C I O N:"
 * @ 22,01 SAY DESCRI1+"        "+DESCRI3
 * @ 23,01 SAY DESCRI2+"        "+DESCRI4
   *** PARA INDICAR LA ROTACION DEL MENU (SI LA HUBO)
   IF XFLAG7
      SET COLOR TO W+/B
      @ 20,05 SAY  XMENU1
      @ 20,20 SAY  XMENU2
      @ 20,35 SAY  XMENU3
      @ 20,50 SAY  XMENU4
      @ 20,65 SAY  XMENU5
      SET COLOR TO B/W+
      STORE "XMENU"+STR(WMENU7,1) TO WMACRO
      @ 20,5+((WMENU7-1)*15)  SAY &WMACRO
      STORE .F. TO XFLAG7
      SET COLOR TO W+/B
   ENDIF
   *** CAPTURA DE INTERACTIVIDAD
   CLEAR TYPEAHEAD
   STORE INKEY(0) TO WMUEVE7
   *** PAGE DOWN
   IF WMUEVE7 = 3
      GO WINICIO7
      SKIP +12
      IF .NOT. EOF()
         STORE RECNO() TO WINICIO7
         STORE .T.     TO FLAGJUMP7
         STORE WINICIO7 TO WREVERSE7
         STORE WLINE7   TO WEDILIN7
         STORE WINICIO7 TO WCLEARREC7
         STORE WLINE7   TO WCLEARLIN7
      ENDIF
   ENDIF
   *** PAGE UP
   IF WMUEVE7 =  18
      GO WINICIO7
      SKIP -12
      STORE RECNO() TO WINICIO7
      STORE .T. TO FLAGJUMP7
      STORE 0 TO WREVERSE7
   ENDIF
   *** HOME
   IF WMUEVE7 = 1
      GO TOP
      IF .NOT. EOF()
         STORE RECNO() TO WINICIO7
         STORE .T. TO FLAGJUMP7
         STORE WINICIO7 TO WREVERSE7
         STORE WLINE7   TO WEDILIN7
         STORE WINICIO7 TO WCLEARREC7
         STORE WLINE7   TO WCLEARLIN7
      ENDIF
   ENDIF
   *** END
   IF WMUEVE7 = 6
      GO BOTT
      SKIP -11
      STORE RECNO() TO WINICIO7
      STORE 0 TO WREVERSE7
      STORE .T. TO FLAGJUMP7
   ENDIF
   *** DOWN ARROW
   IF WMUEVE7 = 24
      SKIP + 1
      IF WEDILIN7 < (WLINE7+(WCONT7-1))
         STORE WREVERSE7    TO WCLEARREC7
         STORE RECNO()     TO WREVERSE7
         STORE WEDILIN7     TO WCLEARLIN7
         STORE WEDILIN7 + 1 TO WEDILIN7
      ELSE
         IF .NOT. EOF()
            GO WINICIO7
            SKIP +1
            STORE RECNO() TO WINICIO7
            STORE .T.     TO FLAGJUMP7
            STORE 0       TO WREVERSE7
         ELSE
            GO WINICIO7
            STORE RECNO() TO WINICIO7
            STORE .T.     TO FLAGJUMP7
            STORE 0       TO WREVERSE7
         ENDIF
      ENDIF
   ENDIF
   *** UP ARROW
   IF WMUEVE7 = 5
      SKIP -1
      IF WEDILIN7 > WLINE7
         STORE WREVERSE7    TO WCLEARREC7
         STORE RECNO()     TO WREVERSE7
         STORE WEDILIN7     TO WCLEARLIN7
         STORE WEDILIN7 - 1 TO WEDILIN7
      ELSE
         GO WINICIO7
         SKIP -1
         STORE RECNO() TO WINICIO7
         STORE .T.     TO FLAGJUMP7
         STORE WINICIO7 TO WREVERSE7
         STORE WLINE7   TO WEDILIN7
         STORE WINICIO7 TO WCLEARREC7
         STORE WLINE7   TO WCLEARLIN7
      ENDIF
   ENDIF
   *** RIGHT ARROW
   IF WMUEVE7 = 4
      STORE .T. TO XFLAG7
      STORE WMENU7+1 TO WMENU7
      IF WMENU7 > 5
         STORE 1 TO WMENU7
      ENDIF
   ENDIF
   *** LEFT ARROW
   IF WMUEVE7 = 19
      STORE .T. TO XFLAG7
      STORE WMENU7-1 TO WMENU7
      IF WMENU7 < 1
         STORE 5 TO WMENU7
      ENDIF
   ENDIF
   *** ESCAPE
   IF WMUEVE7 = 27
      close data
      close index      
      RETURN
   ENDIF
   *** ENTER (INICIO DE OPERACIONES DE ACTUALIZACION DE DATOS
   IF WMUEVE7 = 13
      DO CASE    
         CASE WMENU7 = 1
              DO PRINCREI
              SELECT princre
         CASE WMENU7 = 2
              do recloc
              DO PRINCREM
              unlock all
              SELECT princre
         CASE WMENU7 = 3
              do recloc
              DO PRINCREE
              unlock all
              select princre
         CASE WMENU7 = 4
              close data
              close index             
              RETURN
         CASE WMENU7 = 5
              SAVE SCRE TO S9
              @ wscrelin7 ,01  GET WPREANO
              @ wscrelin7 ,04  GET WPREORI
              @ wscrelin7 ,08  GET WPARTID
              @ wscrelin7 ,13  GET WGENERI
              @ wscrelin7 ,16  GET WESPECI
              @ wscrelin7 ,19  GET WSUBESP
              @ wscrelin7 ,22  GET WORDINA
              READ
              STORE SPACE(18) TO WCUENTA0
              DO WARMACOD0
              IF WCUENTA0 <> SPACE(18)
                 select princre
                 FIND &Wcuenta0
                 IF .NOT. EOF()
                    STORE RECNO() TO WINICIO7
                    STORE .T. TO FLAGJUMP7
                    STORE RECNO() TO WREVERSE7
                    STORE RECNO() TO WCLEARREC7
                    STORE WLINE7   TO WEDILIN7
                    STORE WLINE7   TO WCLEARLIN7
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
close data
close index
RETURN
