              STORE DESCRI     TO WDESCRI
              STORE ASIGNA     TO WASIGNA
              STORE COMPROMETE TO WCOMPROMETE
              STORE CAUSA      TO WCAUSA
              STORE PAGA       TO WPAGA
              STORE .T. TO WACT                                                                                                                                                                                                                               
              DO WHILE WACT                                                                                                                                                                                                                                   
                 @ WSCRELIN ,10  GET WDESCRI
                 @ WSCRELIN ,52  GET WASIGNA
                 @ WSCRELIN ,57  GET WCOMPROMETE
                 @ WSCRELIN ,62  GET WCAUSA
                 @ WSCRELIN ,67  GET WPAGA
                 READ                                                                                                                                                                                                                                         
                 IF READKEY()=12.OR.READKEY()=268
                    STORE .F. TO WACT                                                                                                                                                                                                                         
                    LOOP                                                                                                                                                                                                                                      
                 ENDIF                                                                                                                                                                                                                                        
                 STORE "CONFORME ? (S/N)" TO TEX                                                                                                                                                                                                              
                 STORE "SN" TO WCH                                                                                                                                                                                                                            
                 DO PREGUNTA                                                                                                                                                                                                                                  
                 IF WCH = "N"                                                                                                                                                                                                                                 
                    LOOP 
                 ENDIF                                                                                                                                                                                                                                        
                 REPLACE DESCRI     WITH WDESCRI
                 REPLACE ASIGNA     WITH WASIGNA
                 REPLACE COMPROMETE WITH WCOMPROMETE
                 REPLACE CAUSA      WITH WCAUSA
                 REPLACE PAGA       WITH WPAGA
                 REPLACE USERNAME   WITH WUSERCODE
                 REPLACE USERDATE   WITH DATE()
                 FLUSH                                                                                                                                                                                                                                        
                 STORE .F. TO WACT
              ENDDO                                                                                                                                                                                                                                           

