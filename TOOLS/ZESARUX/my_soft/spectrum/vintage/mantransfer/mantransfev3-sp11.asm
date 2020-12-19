;Contenido del codigo fuente de la ultima version de manstransfe, MANTR11.SP que hay en el mantransfev3.tap



RUN        ORG  49152
       ENT  16384
INICIO
REGSP  DEFW 0
;ESTA INSTRUCCION LA ALTERA
;EL EMULADOR, CON EL MODO
;ACTIVO, SI IM1 O IM2
IMMODE IM1
       RET
;
;INICIO RUTINA CARGA
;
CARGAR LD   SP,FINRUT
;METEMOS STACK AL FINAL DEL
;TODO
       LD   A,255
       SCF

       LD   IX,FINRUT
       LD   DE,65536-FINRUT
       CALL 1366
;RESTAURAR REGISTROS

RESTAU LD   SP,(REGSP)
       POP  HL
       POP  DE
       POP  BC
       POP  AF
       EX   AF,AF'
       EXX
       POP  IY
       POP  IX
       POP  HL
       POP  DE
       POP  BC
;REGISTRO I Y FLAGS QUE INDICAN
;SI DI O EI
       POP  AF

       LD   I,A

;MODO INTERRUPCIONES
       CALL IMMODE

;SI EI O DI
       JP   PO,ESTADI
       EI
ESTADI POP  AF
       RET
;
;RUTINA GRABAR SNAPSHOT
;
GRABAR PUSH AF
       LD   A,I
       PUSH AF
       PUSH BC
       PUSH DE
       PUSH HL
       PUSH IX
       PUSH IY
       EXX
       EX   AF,AF'
       PUSH AF
       PUSH BC
       PUSH DE
       PUSH HL
       LD   (REGSP),SP
;GRABAR PROGRAMA BASIC
       LD   A,0
       LD   IX,CABBAS
       LD   DE,17
       CALL SAVPAU
       LD   A,255
       LD   IX,INIBAS
       LD   DE,FINBAS-INIBAS
       CALL SAVPAU
;BLOQUE BYTES PRIMERO
       LD   A,0
       LD   IX,CABCOD
       LD   DE,17
       CALL SAVPAU
       LD   A,255
       LD   IX,16384
       LD   DE,GRABAR-INICIO
       CALL SAVPAU
;Y BLOQUE DATOS
       LD   A,255
       LD   IX,FINRUT
       LD   DE,65536-FINRUT
       CALL SAVPAU
;DESPUES DE GRABAR QUE HACEMOS
       JP   RESTAU
SAVPAU CALL 1218
       LD   BC,0
PAUSA2 DEC  BC
       LD   A,B
       OR   C
       JR   NZ,PAUSA2
       RET
;PROGRAMA BASIC QUE CARGA
INIBAS DEFB 0,1
       DEFW FINBAS-LINEA1
LINEA1 DEFB #EF,34,34,#AF,#3A
;LOAD ""CODE:

       DEFB #F9,#C0,#B0,34
;RANDOMIZE USR VAL "

       DEFM "16389"
       DEFB 34
       DEFB 13
FINBAS
CABBAS DEFB 0
       DEFM "MANTRANSFE"
       DEFW FINBAS-INIBAS
       DEFW 1
       DEFW FINBAS-INIBAS
CABCOD DEFB 3
       DEFM "1234567890"
       DEFW GRABAR-INICIO
       DEFW 16384
       DEFW 0
FINRUT
