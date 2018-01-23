; BETTER TO TEST IN DOS-BOX
; IF YOU DO NOT WANT TO QUIT(using int27h), UNCOMMENT LINE 54

; There is a bug if you use ibm-pc emulator.
; The bug is that you can only input one char after this program
; finished and quited.
; However, in dosbox emulator, this problem doesn't occur any more
; This bug was founded when I finished and tested my codes in dosbox
; successfully and then tried to test the program in ibm-pc.

; Moreover, task1 and task2 can both count 10 seconds
; Thank you for reading these comments!
assume cs:code, ss:stack 

stack segment
    db 128 dup(0)
stack ends

code segment
start:  
        
        MOV AX, stack                       
        MOV SS, AX
        MOV SP, 128
        
        PUSH CS
        POP DS
        
        ;CALL task1
        CALL task2  ;both task1 and task2 can count 10 seconds!
        MOV AH, 0CH
        INT 21H
        
        ;movsb to 0:[204h]
        MOV AX, 0
        MOV ES, AX
        MOV SI, OFFSET int9
        MOV DI, 204h
        MOV CX, OFFSET int9end - OFFSET int9
        CLD
        REP MOVSB
                                               
        ;mov int9 address 0:[200]
        PUSH ES:[9*4]
        POP ES:[200h]
        PUSH ES:[9*4+2]
        POP ES:[202H]

        CLI    ;set IF=0 
        MOV WORD PTR ES:[9*4], 204H
        MOV WORD PTR ES:[9*4+2], 0
        STI    ;set IF=1
        
        ;CALL task2    

;MOV AX, 4C00H
;INT 21H
INT 27H

int9:    
        PUSH AX
        PUSH BX
        PUSH CX
        PUSH DX        
        
        ;get keyboard code
        ;CS=0
        
        CLI
        PUSHF
        
        PUSHF
        POP AX
        AND AH, 11111100B
        PUSH AX
        POPF
        
        CALL DWORD PTR CS:[200H]
        ;int 200h/4  both are OK!
        
        MOV AH, 0H
        INT 16H
        STI
        
        CMP AL, 'a'
        JB pos2
        CMP AL, 'z'
        JA pos2
        CMP AL, 'z'
        JE pos1
        INC AL
        JMP pos2
   pos1:
        MOV AX, 61H
   pos2:     
        MOV DL, AL
        MOV AH, 02h
        INT 21H
        
        int9ret:
        
        POP dx
        POP cx
        POP bx
        POP ax
        IRET
        
        int9end:
        NOP
  
task1 proc near
        CLI
        PUSH AX
        PUSH CX
        PUSH DX         
        
        ; Wait 10,000,000 microseconds
        ; MOV     CX, 0FH
        ; MOV     DX, 4240H
        MOV CX, 98H
        MOV DX, 9680H
        
        
        MOV AH, 86H
        INT 15H
        POP DX
        POP CX
        POP AX
        RET
task1 endp

task2 proc near
        STI
        PUSH AX
        PUSH BX
        PUSH CX
        PUSH DX
        
        MOV AH, 00H
        INT 1AH
        MOV BX, DX
    s1:   
        INT 1AH
        SUB DX, BX
        CMP DX, 181
        JL s1
        
        POP DX
        POP CX
        POP BX
        POP AX
        CLI
        RET
task2 endp
       
code ends
end start
