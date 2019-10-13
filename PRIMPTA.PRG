SAVE SCRE TO SCRE4
store .t. to wsub4
do while wsub4
   RESTORE SCREEN FROM SCRE4
   @ 05,35 clear to 11,59
   @ 05,35 to 11,59
   @ 05,40 SAY " TABLAS "
   @ 06,36 PROMPT "Partidas (clasificador)"
   @ 07,36 PROMPT "Unidades ejecutoras    "
   @ 08,36 PROMPT "Regiones               "
   @ 09,36 PROMPT "Documentos de soporte  "
   @ 10,36 PROMPT "Beneficiarios          "
   MENU TO WSUBSUB6
   DO CASE
   CASE WSUBSUB6 = 1
        DO PRIMPPAR
   CASE WSUBSUB6 = 2
        DO PRIMPUNI
   CASE WSUBSUB6 = 3
        DO PRIMPREG
   CASE WSUBSUB6 = 4
        DO PRIMPSOP
   CASE WSUBSUB6 = 5
        DO PRIMPBEN
   CASE WSUBSUB6 = 0
        EXIT
   ENDCASE
enddo
