;PROGRAM TO GENERATE RANDOM AIRTHMATIC QUIZ

RANDNUMBER MACRO RANGE
    
    MOV AH, 00h  ; Interrupts to get system time        
    INT 1AH      ; CX:DX now hold number of clock ticks since midnight
            
    MOV AX, DX
    XOR DX, DX   ; Clears value in Data register
    MOV CX, RANGE  
    DIV CX       ; Here dx contains the remainder of the division - from 0 to 9

    ADD DL, '0'
ENDM    

NL MACRO
    
    MOV AH,2
	MOV DL, 0AH
	INT 21H   
    MOV DL, 0DH
    INT 21H

ENDM    

.MODEL SMALL
.STACK 100H

.DATA    

MSG1 DB '*************************************************$'
MSG2 DB 10,13,'Project BY Labheshwar Sharma!$'
MSG3 DB 10,13,'*************************************************$'
MSG4 DB 10,13,10,13,'A quiz system that generates random ADDITION queries each time we play$'
MSG5 DB 10,13,'Press any key to start the quiz : $'
MSG6 DB 10,13,'Enter your answer : $'
MSG7 DB 10,13,'Correct.$'
MSG8 DB 10,13,'Wrong.$'
MSG9 DB 10,13,'Quiz successfully completed.$'
MSG10 DB 10,13,'You scored : $'
MSG11 DB 10,13,'Congratulations, You aced the quiz with score : 10/10.$'
MSG12 DB 10,13,'                    ***Thank you.! ***$'  

Q DB ?, '. '
OPRD1 DB ?, '+'
OPRD2 DB ?, '=?$'
OPTS DB '   a) '
OPT1 DB ?,'    b) '
OPT2 DB ?,'    c) '
OPT3 DB ?,'$'
LP DB 10
NUM1 DB ?
NUM2 DB ?
SUM DB ?
COUNT DB '0'
CRCTOPT DB ?

.CODE

MAIN PROC 

     
    MOV AX,@DATA
	MOV DS,AX
    
	LEA DX,MSG1
	MOV AH,9
	INT 21H
	
	NL
    
	LEA DX,MSG2
	MOV AH,9
	INT 21H
    
	NL
    
	LEA DX,MSG3
	MOV AH,9
	INT 21H
    
    NL
    
	LEA DX,MSG4
	MOV AH,9
	INT 21H
	
    
    NL
       
    LEA DX,MSG5
    MOV AH,9
    INT 21H
    
    MOV AH, 1
    INT 21H
        
    MOV BL, '1'
        

    QUES:
    
        NL
        NL
        
        CMP BL, 58 
        JNE NOT_TEN 
        
        
        MOV SI, OFFSET Q
        MOV [SI], '01'   ;Sets Q No. 10, since registers store characters in reverse order == 01==>10
        JMP RANDOM_OPERANDS
        
        
        NOT_TEN:
        MOV SI, OFFSET Q
        MOV [SI], BL
        

        INC BL
        
        RANDOM_OPERANDS:

        MOV SI, OFFSET OPRD1
        RANDNUMBER 6
        MOV [SI], DL
        MOV NUM1, DL

        MOV SI, OFFSET OPRD2
        RANDNUMBER 5
        MOV [SI], DL
        MOV NUM2, DL

        XOR AL, AL
        ADD AL, NUM1
        ADD AL, NUM2
        MOV SUM, AL
        SUB SUM, 48

        LEA DX,Q
        MOV AH,9
        INT 21H

        NL

        RANDNUMBER 3
        MOV CRCTOPT, DL
        ADD CRCTOPT, 49    
       
        CMP CRCTOPT, 'a'
        JE OPTION1

        CMP CRCTOPT, 'b'
        JE OPTION2

        JMP OPTION3        
        

        OPTION1:
            
            MOV SI, OFFSET OPT1
            MOV DL, SUM
            MOV [SI], DL

            MOV SI, OFFSET OPT2
            RANDNUMBER 9
            CMP DL, SUM
            JE OPTION1
            MOV [SI], DL

            MOV SI, OFFSET OPT3
            RANDNUMBER 8
            CMP DL, SUM
            JE OPTION1
            MOV [SI], DL

        JMP OPTIONS
        OPTION2:

            MOV SI, OFFSET OPT1
            RANDNUMBER 9
            CMP DL, SUM
            JE OPTION2
            MOV [SI], DL

            MOV SI, OFFSET OPT2
            MOV DL, SUM
            MOV [SI], DL

            MOV SI, OFFSET OPT3
            RANDNUMBER 8
            CMP DL, SUM
            JE OPTION2
            MOV [SI], DL


        JMP OPTIONS
        OPTION3:

            MOV SI, OFFSET OPT1
            RANDNUMBER 9
            CMP DL, SUM
            JE OPTION3
            MOV [SI], DL

            MOV SI, OFFSET OPT2
            RANDNUMBER 8
            CMP DL, SUM
            JE OPTION3
            MOV [SI], DL

            MOV SI, OFFSET OPT3
            MOV DL, SUM
            MOV [SI], DL

        OPTIONS:

            LEA DX,OPTS
            MOV AH,9
            INT 21H

            NL

            LEA DX, MSG6
            MOV AH, 9
            INT 21H

            MOV AH, 1
            INT 21H

            CMP CRCTOPT, AL
            JE CORRECT

            NL
            LEA DX, MSG8
            MOV AH, 9
            INT 21H
            DEC LP
            JZ FINISHED
            JMP QUES
            
        
        CORRECT:
            
            NL
            INC COUNT
            LEA DX, MSG7
            MOV AH, 9
            INT 21H

        DEC LP
    JZ FINISHED
    JMP QUES


    FINISHED:

        NL
        LEA DX, MSG9
        MOV AH, 9
        INT 21H 
        
        CMP COUNT,58
        JE WINNER

        NL 
        LEA DX, MSG10
        MOV AH, 9
        INT 21H

        MOV DL, COUNT
        MOV AH, 2
        INT 21H  
        
        JMP THANKYOU
        
        WINNER:    
        
            NL            
            LEA DX, MSG11
            MOV AH, 9
            INT 21H 
            
        THANKYOU:
              
            NL
            LEA DX, MSG12  
            MOV AH, 9
            INT 21H           

        MOV AH, 4CH
        INT 21H

MAIN ENDP
    END MAIN    