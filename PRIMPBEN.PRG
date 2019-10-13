select 1
use prbenef index prbenef2
@ 11,35 clear to 14,79
@ 11,35 to 14,79
@ 11,45 SAY " BENEFICIARIOS "
@ 12,36 say "CLAVE       :"
@ 13,36 say "SALIDA (M/I):"
SAVE SCRE TO WSCRE99
store .f. to wflagscre
store .t. to viendo
do while viendo
   if wflagscre
      @ 0,0 clear
      RESTORE SCRE FROM WSCRE99
   else
      store .t. to wflagscre
   endif
   STORE space(10) TO Xcodigo
   @ 12,50 GET XCODIGO
   READ
   IF READKEY()=12 .OR. READKEY()=268
      EXIT
   ENDIF
   IF Xcodigo = SPACE(10)
      STORE "TODOS" TO WBENEFIDES
   ELSE
      STORE "  "    TO WBENEFIDES
   ENDIF
   @ 12,50 SAY WBENEFIDES+"           "

   STORE "SELECCIONE LA SALIDA: (M)ONITOR, (I)MPRESORA" TO TEX
   STORE "MI" TO WCH
   DO PREGUNTA
   IF READKEY()=12 .OR. READKEY()=268
      LOOP
   ENDIF
   STORE WCH TO WSALIDA
   STORE 0   TO WPAGINA
   STORE 100 TO WLINEA
   IF WSALIDA = "I"
      STORE 55 TO WSALTO
      STORE "IMPRESORA" TO WSALIDES
   ELSE
      STORE 22 TO WSALTO
      STORE "MONITOR" TO WSALIDES
   ENDIF
   @ 13,50 SAY WSALIDES

   STORE "OPCIONES: (C)ONTINUAR, (S)ALIR" TO TEX
   STORE "CS" TO WCH
   DO PREGUNTA
   IF WCH = "S"
      exit
   ENDIF
   IF WSALIDA = "I"
      SET DEVI TO PRINT
   ELSE
      SET DEVI TO SCRE
   ENDIF
   if xcodigo <> space(10)
      STORE RTRIM(LTRIM(XCODIGO)) TO XCODIGO
      STORE LEN(XCODIGO)          TO WLARCOD
   else
      store 0 to wlarcod
   endif
   SELECT prbenef
   GO TOP
   DO WHILE .NOT. EOF()
      *** FILTROS
      IF WLARCOD>0.and.AT(XCODIGO,DESCRI)=0
         SELECT prbenef
         SKIP
         LOOP
      ENDIF
      *** FIN FILTROS
      STORE WLINEA+1 TO WLINEA
      IF WLINEA >=WSALTO
         STORE WPAGINA + 1 TO WPAGINA
         IF WSALIDA = "M"
            if WPAGINA <> 1
               STORE "OPRIMA <ENTER> PARA CONTINUAR o <ESC> PARA SALIR" TO MES
               DO AVISO WITH MES
               IF READKEY()=12 .OR. READKEY()=268
                  EXIT
               ENDIF
            endif
            @ 0,0 clear
         ENDIF
         IF WSALIDA = "M"
            @ 0,0 SAY QQWW
         ELSE
            @ 0,0 SAY CHR(14)+QQWW
         ENDIF
         @ 1,60 SAY "PAGINA:"+STR(WPAGINA,4)
         @ 2,0 SAY "LISTADO DE BENEFICIARIOS"
         @ 2,60 SAY "FECHA :"+DTOC(DATE())
         @ 4,00 SAY "CODIGO"
         @ 4,18 SAY "DESCRIPCION"
         @ 4,50 SAY "TIPO"
         @ 4,56 SAY "RAZON"
         @ 5,00 SAY "------"
         @ 5,18 SAY "------------------------------"
         @ 5,50 SAY "----"
         @ 5,56 SAY "-----"
         STORE 6 TO WLINEA
      ENDIF
      @ WLINEA , 0 SAY CODIGO
      @ WLINEA ,18 SAY DESCRI
      @ WLINEA ,50 SAY TIPO
      @ WLINEA ,56 SAY RAZON
      SELECT PRBENEF
      SKIP
   ENDDO
   IF WSALIDA = "M"
      STORE "OPRIMA <ENTER> PARA FINALIZAR" TO MES
      DO AVISO WITH MES
   ELSE
      EJECT
      SET DEVI TO SCRE
   ENDIF
ENDDO
close data
close index
return

