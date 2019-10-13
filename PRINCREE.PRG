              STORE MONTO     TO WMONTODEL
              STORE FECHA     TO WFECHADEL
              STORE SPACE(18) TO WCTAINCRE
              STORE SPACE(18) TO WCUENTA0
              DO ARMAINC
              DO ARMACOD0
              select PRCTAS
              find &wctaincre
              if eof()
                 store "ERROR, PARTIDA DE INCREMENTO NO EXISTE EN PLAN DE CUENTAS" TO MES
                 DO AVISO WITH MES
                 RETURN
              ENDIF
              IF (ORIG+TRAS+INCR-DISM) - WMONTODEL < COMP
                 STORE "ERROR, NUEVO MONTO NO CUBRIRA LOS COMPROMISOS" TO MES
                 DO AVISO WITH MES
                 RETURN
              ENDIF
              STORE "ESTA SEGURO QUE DESEA ELIMINAR (S/N)" TO TEX 
              STORE "NS" TO WCH                                   
              DO PREGUNTA                                         
              IF WCH = "S"
                 SELECT PRINCRE
                 STORE MONTO TO WMONTO
                 REPLACE USERNAME   WITH SYS(30)
                 REPLACE USERDATE   WITH DATE()
                 DELETE                        
                 FLUSH
                 ***
                 STORE WCTAINCRE  TO WNOCTA
                 STORE WFECHADEL  TO WFECHA
                 STORE .T.        TO WFLAGMES
                 STORE "INCR"     TO WCAMPO
                 STORE WMONTO*-1  TO WMONTOPROC
                 DO ACTUALIZA
                 select PRINCRE
                 STORE .T. TO FLAGDEL                         
                 SKIP                                         
                 IF .NOT. EOF()                               
                    STORE RECNO() TO WINICIO7
                    STORE .T. TO FLAGJUMP7
                    STORE RECNO() TO WREVERSE7
                    STORE RECNO() TO WCLEARREC7
                    STORE WLINE7  TO WEDILIN7
                    STORE WLINE7  TO WCLEARLIN7
                 ELSE                     
                    GO TOP                
                    STORE RECNO() TO WINICIO7
                    STORE .T. TO FLAGJUMP7
                    STORE 0 TO WREVERSE7
                 ENDIF                  
              ENDIF                     
              SELECT PRINCRE
              RETURN
  



