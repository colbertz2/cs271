TITLE Arithmetic Demo with Procedures           (hw3.asm)

; Author: Zach Colbert
; CS 271 / Homework 3                 Date: 15 November 2019
; Description: Demonstrates arithmetic operations using user-inputted operands.

INCLUDE Irvine32.inc

.386
.model flat, stdcall
.stack 4096
ExitProcess proto, dwExitCode:dword

;CONSTANT DEFINITIONS
PROG_NAME   EQU <"Arithmetic Demo with Procedures", 0>
AUTH_NAME   EQU <"by Zach Colbert", 0>
USER_INSTRUCTION    EQU <"Enter two positive integers for arithmetic demo.", 0>
PROMPT_1    EQU <"First operand [1-10]: ", 0>
PROMPT_2    EQU <"Second operand [1-10]: ", 0>
TOO_LOW     EQU <" is too small. Enter a number at least ", 0>
TOO_HIGH    EQU <" is too large. Enter a number at most ", 0>
ADD_CONST   EQU <" + ", 0>
SUB_CONST   EQU <" - ", 0>
MUL_CONST   EQU <" * ", 0>
DIV_CONST   EQU <" / ", 0>
REM_CONST   EQU <" remainder ", 0>
EQU_CONST   EQU <" = ", 0>
; BYE_CONST   EQU <"So long, and thanks for all the ints!", 0>

OP_MIN  =   1       ; Minimum operand value
OP_MAX  =   10      ; Maximum operand value

.data
    ; Store constants in memory (?)
    progName    BYTE    PROG_NAME
    authName    BYTE    AUTH_NAME
    uInstr      BYTE    USER_INSTRUCTION
    prompt1     BYTE    PROMPT_1
    prompt2     BYTE    PROMPT_2
    valTooLow   BYTE    TOO_LOW
    valTooHigh  BYTE    TOO_HIGH
    add_str     BYTE    ADD_CONST
    sub_str     BYTE    SUB_CONST
    mul_str     BYTE    MUL_CONST
    div_str     BYTE    DIV_CONST
    rem_str     BYTE    REM_CONST
    equ_str     BYTE    EQU_CONST

    ; Can't print exclamation when I use the same method as other strings.
    ; Why is that?
    bye_str     BYTE    "So long, and thanks for all the ints!", 0

    ; Global storage for user operands
    n1  DWORD   ?
    n2  DWORD   ?

    ; Global storage for arithmetic results
    radd    DWORD   ?
    rsub    DWORD   ?
    rmul    DWORD   ?
    rdiv    REAL4  ?

.code
main PROC
    call intro              ; Print intro message
    
    push offset n1
    push offset prompt1
    call getInput           ; Get first operand

    push offset n2
    push offset prompt2
    call getInput           ; Get second operand

    push offset radd
    call demoAdd            ; radd = n1 + n2

    push n1
    push n2
    push offset rsub
    call demoSub            ; rsub = n1 - n2 (unsigned)

    push offset n1
    push offset n2
    push offset rmul
    call demoMul            ; rmul = n1 * n2

    mov EAX, n1
    mov EBX, n2
    push offset rdiv
    call demoDiv            ; rdiv = n1 / n2 (floating point)

    call printResults       ; It prints. Results.

    call outro              ; The Big Goodbye

    invoke ExitProcess,0   ; exit to operating system
main ENDP

; PROCEDURE DEFINITIONS

; intro: Prints title, author, and initial user instructions.
;   Receives: Global variables progName, authName, uInstr
;   Returns: (None)
;   Preconditions: Initialize progName, authName, uInstr as byte strings
;   Registers changed: None
intro PROC
    pushad  ; Save registers

    mov EDX, offset progName
    call WriteString            ; Print program name from EDX
    call Crlf

    mov EDX, offset authName
    call WriteString            ; Print author name from EDX
    call Crlf
    call Crlf

    mov EDX, offset uInstr
    call WriteString            ; Print user instructions from EDX
    call Crlf

    popad   ; Restore registers
    ret     ; Pop stack to return EIP to calling proc... No params to pop
intro ENDP


; getInput: Prompts user for input, validates against min/max values, and stores
;           the value in a global variable.
;   Receives: Memory address at which to store value, passed by stack.
;             Offset of string prompt message, passed by stack.
;             Min/max values defined as global constants OP_MIN and OP_MAX.
;   Returns: Unsigned integer stored in memory.
;   Preconditions: DWORD memory space allocated and writeable. OP_MIN and OP_MAX
;                  initialized to unsigned integer values.
;   Registers changed: None
getInput PROC
    push EBP
    mov EBP, ESP
    pushad

    validateLoop:
        mov EDX, [EBP + 8]      ; Move address of prompt string from stack
        call WriteString        ; Print user prompt
        call ReadDec            ; Get user input
        cmp EAX, OP_MIN         ; Compare to minimum value
        jl  lowBound            ; Try again if less than minimum
        cmp EAX, OP_MAX         ; Compare to max value
        jg  highBound           ; Try again if greater than maximum
        jmp inBound             ; Value is within bounds!

    lowBound:
        call WriteDec
        mov EDX, offset valTooLow
        call WriteString        ; Print a warning message
        mov EAX, OP_MIN
        call WriteDec
        call Crlf
        call Crlf
        jmp validateLoop        ; Try again

    highBound:
        call WriteDec
        mov EDX, offset valTooHigh
        call WriteString        ; Print a warning message
        mov EAX, OP_MAX
        call WriteDec
        call Crlf
        call Crlf
        jmp validateLoop        ; Try again

    inBound:
        mov ESI, [EBP + 12]
        mov [ESI], EAX      ; Store the user's input in memory

    popad
    pop EBP
    ret 8
getInput ENDP


; demoAdd: Adds two parameters from global variables using the FPU.
;   Receives:
;       n1 - Unsigned, integer operand stored in global variable n1
;       n2 - Unsigned, integer operand stored in global variable n2
;       rAdd - DWORD memory reference to store result of addition, pass by stack
;   Returns:
;       rAdd - Unsigned, integer result stored in memory
;   Preconditions:
;       Initialize global vars n1 and n2 with DWORD values.
;       Declare DWORD memory space for result.
;   Registers changed: None
demoAdd PROC
    push EBP
    mov EBP, ESP
    pushad

    mov ESI, [EBP + 8]      ; Memory location where we'll store the result

    finit       ; Init FPU
    fld n1      ; Load first operand from global var
    fld n2      ; Load second operand from global var
    fadd        ; Add operands from FPU stack
    fstp DWORD PTR [ESI]    ; Pop result from FPU stack and cast as DWORD

    popad
    pop EBP
    ret 4
demoAdd ENDP


; demoSub: Subtracts two parameters passed via stack using the CPU.
;   Receives:
;       n1 - Unsigned, integer operand passed via stack.
;       n2 - Unsigned, integer operand passed via stack.
;       rSub - DWORD memory reference to store result, passed via stack.
;   Returns:
;       Unsigned, integer result stored in memory.
;   Preconditions:
;       Push two operands and result offset to the stack.
;       n1 >= n2
;   Registers changed: None
demoSub PROC
    push EBP
    mov EBP, ESP
    pushad

    mov ESI, [EBP + 8]      ; Memory location for result

    mov EAX, [EBP + 16]     ; Get first param from stack
    mov EBX, [EBP + 12]     ; Get second param from stack

    sub EAX, EBX            ; Subtract the two operands

    mov [ESI], EAX          ; Store result in memory

    popad
    pop EBP
    ret 12
demoSub ENDP


; demoMul: Multiplies two parameters passed by reference via stack.
;   Receives:
;       n1 - DWORD passed by reference on stack.
;       n2 - DWORD passed by reference on stack.
;       rMul - DWORD memory reference for result.
;   Returns:
;       DWORD result stored in memory at offset rMul
;   Preconditions:
;       None
;   Registers changed: None
demoMul PROC
    push EBP
    mov EBP, ESP
    pushad

    mov EAX, 0              ; Init EAX to 0

    mov ESI, [EBP + 16]     ; Pointer to n1
    mov AL, BYTE PTR [ESI]  ; Cast n1 value to 8 bits
    
    mov ESI, [EBP + 12]     ; Pointer to n2
    mul BYTE PTR [ESI]      ; AX = AL * n2

    mov ESI, [EBP + 8]      ; Memory location for result
    mov [ESI], AX          ; Store result in memory

    popad
    pop EBP
    ret 12
demoMul ENDP


; demoDiv: Divides two parameters passed by register using the FPU.
;   Receives:
;       n1 - DWORD dividend in EAX
;       n2 - DWORD divisor in EBX
;       rDiv - REAL4 memory location for quotient
;   Returns:
;       REAL4 quotient saved to memory location rDiv.
;   Preconditions: n2 must not be zero
;   Registers changed: None
demoDiv PROC
    push EBP
    mov EBP, ESP
    sub ESP, 8      ; Make room for 2 local REAL4s
    pushad

    mov [EBP - 4], EAX        ; Store registers in local vars
    mov [EBP - 8], EBX

    mov ESI, [EBP + 8]     ; Memory location for quotient

    finit
    fld REAL4 PTR [EBP - 4]
    fdiv REAL4 PTR [EBP - 8]        ; ST(0) = EAX / EBX
    fstp REAL4 PTR [ESI]

    popad
    mov ESP, EBP
    pop EBP
    ret 4
demoDiv ENDP


; printResults: Load values from memory and print them.
;   Receives:
;       Global vars: n1, n2, radd, rsub, rmul, rdiv
;       Global consts: add_str, sub_str, mul_str, div_str, equ_str
;   Returns: None
;   Preconditions: Call all 4 of the demoOPX procs, store results in the listed 
;                   global vars.
;   Registers changed: None
printResults PROC
    pushad

    call Crlf

    ; ADDITION RESULT
    mov EAX, n1
    call WriteDec
    mov EDX, offset add_str
    call WriteString
    mov EAX, n2
    call WriteDec
    mov EDX, offset equ_str
    call WriteString
    mov EAX, radd
    call WriteDec
    call Crlf

    ; SUBTRACTION RESULT
    mov EAX, n1
    call WriteDec
    mov EDX, offset sub_str
    call WriteString
    mov EAX, n2
    call WriteDec
    mov EDX, offset equ_str
    call WriteString
    mov EAX, rsub
    call WriteDec
    call Crlf

    ; MULTIPLICATION RESULT
    mov EAX, n1
    call WriteDec
    mov EDX, offset mul_str
    call WriteString
    mov EAX, n2
    call WriteDec
    mov EDX, offset equ_str
    call WriteString
    mov EAX, rmul
    call WriteDec
    call Crlf

    ; DIVISION RESULT
    mov EAX, n1
    call WriteDec
    mov EDX, offset div_str
    call WriteString
    mov EAX, n2
    call WriteDec
    mov EDX, offset equ_str
    call WriteString
    finit
    fld rdiv
    call WriteFloat
    call Crlf

    popad
    ret
printResults ENDP


; outro: Prints a goodbye message for the user, who we'll miss dearly.
;   Receives: Global constant bye_str
;   Returns: None
;   Preconditions: Initialize bye_str
;   Registers changed: None
outro PROC
    pushad

    call Crlf
    mov EDX, offset bye_str
    call WriteString
    call Crlf

    popad
    ret
outro ENDP

END main
