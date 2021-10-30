START EQU P3.1
RESET1 EQU P3.0
BUZZ EQU P3.7

DISA EQU P3.3
DISB EQU P3.2
DISC EQU P3.6

ORG 0000H
LJMP MAIN
ORG 0040H
MAIN:
     CLR BUZZ
     JB START,$                     ;WAIT FOR START BUTTON TO BE PRESSED
     SETB DISA
     SETB DISB
     SETB DISC
DD1:SETB DISA
    MOV A,#09H                      ;SETTING FOR MINUTE
    MOV R1,A
    MOV R4,A
DS1:MOV P0,R1
    DD2:MOV A,#05H
    DS2:MOV P2,A
        DD3:MOV A,#09H
        DS3:MOV P1,A
            ACALL AAA
            DEC A
            CJNE A,#00H,DS3
        MOV A,P2
        MOV P1,#00H
        ACALL AAA
        DEC A
        CJNE A,#00H,DS2
TEN:MOV P2,#00H
    MOV R6,#09H
    TE:MOV P1,R6
    DEC R6
    ACALL AAA
    CJNE R6,#00H,TE
    MOV P1,#00H
DEC R1
ACALL AAA
MOV P0,R1
CJNE R1,#00H,DS1
MOV P0,#00H
LASTMIN:
DE2:MOV A,#05H
    DF2:MOV P2,A
        DE3:MOV A,#09H
        DF3:MOV P1,A
            ACALL AAA
            DEC A
            CJNE A,#00H,DF3
        MOV A,P2
        MOV P1,#00H
        ACALL AAA
        DEC A
        CJNE A,#00H,DF2
LASTEN:
MOV P0,#00H
MOV P2,#00H
MOV R6,#09H
    TE1:MOV P1,R6
    DEC R6
    ACALL AAA
    CJNE R6,#00H,TE1
    MOV P1,#00H
    SETB BUZZ
JB RESET1,$                       ;END OF COUNTDOWN.WAIT FOR RESET TO BE PRESSED
MOV P0,R4
MOV P2,#05H
MOV P1,#09H
CLR BUZZ
JMP MAIN
AAA:
ACALL RST
ACALL STP
ACALL DELAY
ACALL RST
ACALL STP
RET
RST:                            ;RESETS ALL DISPLAYS AND RETURNS TO START   
JB RESET1,DOWN
MOV P0,R4
MOV P1,#09H
MOV P2,#05H
JMP MAIN
DOWN:RET
STP:                             ;PAUSE ROUTINE FOR TIMER
S1:JB START,DWN
SJMP S1
DWN:RET
DELAY:                           ;DELAY OF ONE SECOND
        MOV TMOD,#01H
        MOV TH0,#3CH
        MOV TL0,#0B0H
        MOV R7,#00H
        SETB TR0
    DEL:JNB TF0,DEL
        MOV TH0,#3CH
        MOV TL0,#0B0H
        CLR TF0
        INC R7  
        CJNE R7,#14H,DEL
        RET

END