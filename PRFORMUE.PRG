do armacod0
IF COMP > 0 .OR. TRAS <> 0 .OR. INCR > 0
   STORE "ERROR, PRIMERO ELIMINE TODA OPERACION RELACIONADA CON ESTA CUENTA." TO MES
   DO AVISO WITH MES
   RETURN
ENDIF
select PRCOMP
set order to 1
find &wcuenta0
if .not. eof()
   store "ERROR, PARTIDA CON ASIGNACIONES." TO MES
   do aviso with mes
   select prctas
   return
else
   select prctas
endif
STORE "ESTA SEGURO QUE DESEA ELIMINAR (S/N)" TO TEX
STORE "NS" TO WCH
DO PREGUNTA
IF WCH = "S"
   STORE ORIG TO WORIG
   STORE CORR TO WCORR
   STORE INVE TO WINVE
   REPLACE USERNAME   WITH WUSERCODE
   REPLACE USERDATE   WITH DATE()
   DELETE
   FLUSH
   IF WLARCOD = 18
      STORE WCUENTA0 TO WNOCTA
      STORE .F.      TO WFLAGMES
      STORE "ORIG"   TO WCAMPO
      STORE WORIG*-1 TO WMONTOPROC
      DO ACTUALIZA
      STORE "CORR"   TO WCAMPO
      STORE WCORR*-1 TO WMONTOPROC
      DO ACTUALIZA
      STORE "INVE"   TO WCAMPO
      STORE WINVE*-1 TO WMONTOPROC
      DO ACTUALIZA
   ENDIF
   STORE .T. TO FLAGDEL
   SKIP
   IF .NOT. EOF()
      STORE RECNO() TO WINICIO0
      STORE .T. TO FLAGJUMP0
      STORE RECNO() TO WREVERSE0
      STORE RECNO() TO WCLEARREC0
      STORE WLINE0  TO WEDILIN0
      STORE WLINE0  TO WCLEARLIN0
   ELSE
      GO TOP
      STORE RECNO() TO WINICIO0
      STORE .T. TO FLAGJUMP0
      STORE 0 TO WREVERSE0
   ENDIF
ENDIF
return
