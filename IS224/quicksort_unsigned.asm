data segment
    ;NUM DW 0H,1H,2H,3H,4H,5H,6H,7H,8H,9H,40 DUP(10H)
    ;NUM DW 11H,02H,15H,32H,05H,08H,07H,09H,10H,09H,12H,07H,25H,19H,99H,45H,18H,32H,16H,64H, 30 DUP(5)
    ;NUM DW 40 DUP(10H),9H,8H,7H,6H,5H,4H,3H,2H,1H, 0H
    NUM DW 9995H, 7D4FH, 0FF56H, 0AD55H, 4521H, 45 DUP(1234H)
    ;注意，将需要排序的数视为无符号数！
    LT  DW 0H
    RT  DW 49
ends

stack segment
    ST  DW  1000 dup(0)
    TOP EQU 1000
ends

code segment
    ASSUME DS:data, SS:stack, CS:code
start:

        MOV  AX, data
        MOV  DS, AX
        MOV  AX, stack
        MOV  SS, AX
        MOV  SP, TOP
        
        PUSH LT
        PUSH RT
        CALL quicksort 

        MOV  AX, 4C00H
        INT  21H 

quicksort proc near
        PUSH AX
        PUSH BX
        PUSH CX
        PUSH DX
        PUSH SI
        MOV  SI, SP
        MOV  BX, SS:[SI + 14]  ; BX = L 
        MOV  AX, SS:[SI + 12]  ; AX = R
        
        CMP AX, BX
        ;JBE  P                ; IF R - L <= 0 RETURN
        JLE  P
        SHL  BX, 1H            ; BX = 2 * L
        MOV  DX, DS:[BX]       ; DX = S = ARR[L]
        SHL  AX, 1H            ; AX = 2 * R
        
    F0:
        CMP  AX, BX            ; AX = 2 * HIGH, BX = 2 * LOW
        JLE  L_OUT             
                               ; IF HIGH > LOW
        MOV  BP, AX                        
        MOV  CX, DS:[BP]       ; CX = ARR[HIGH]
        CMP  CX, DX            ; CMP ARR[HIGH], S
        JB   F1                 
        SUB  AX, 2
        JMP  F0
    F1:       
        CMP  AX, BX            ; CMP LOW, HIGH
        JLE   L_OUT
                               ; EXCHABGE ARR[LOW], ARR[HIGH]
        MOV  DI, AX
        MOV  CX, DS:[DI]
        MOV  DS:[BX], CX, 
        ADD  BX, 2
        
    F3: CMP  AX, BX
        JLE  L_OUT
                       
        MOV  CX, DS:[BX]       ; CX = ARR[LOW]
        CMP  CX, DX            ; CMP ARR[HIGH], S
        JA   F2                 
        ADD  BX, 2
        JMP  F3                
    F2:     
        CMP AX, BX
        JLE  L_OUT
        
        MOV  BP, BX
        MOV  DI, AX
        MOV  CX, DS:[BP]
        MOV  DS:[DI], CX
        SUB  AX, 2
        
        JMP  F0
                                ; IF HIGH <= LOW  QUIT LOOP
 L_OUT: MOV  DS:[BX], DX
        SHR  AX, 1              ; AX = HIGH
        SHR  BX, 1              ; BX = LOW
              
        PUSH SS:[SI + 14]      ; PUSH L
        DEC  BX                ; BX = LOW - 1
        PUSH BX
        CALL quicksort
        POP  BX
        POP  BX
        INC  AX                ; AX = HIGH + 1
        PUSH AX
        PUSH SS:[SI + 12]
        CALL quicksort
        POP  AX
        POP  AX
        
     P: POP  SI
        POP  DX
        POP  CX
        POP  BX
        POP  AX
        RET
ends

end start
