TITLE Homework 3            (hw3.asm)

; Author: Zach Colbert
; CS 271 / Homework 3                 Date: 15 November 2019
; Description:  Gets some integers from the user, and performs 
;               arithmetic operations on them.

INCLUDE Irvine32.inc

.386
.model flat, stdcall
.stack 4096
ExitProcess proto, dwExitCode:dword

.data
; Introduction variables
prog_name       BYTE    "Arithmetic Demo with Procedures", 0
author_str      BYTE    "by Zach Colbert", 0
u_instruction   BYTE    "Enter two positive integers for arithmetic demo.", 0

; Get_Data variables
prompt1         BYTE    "First operand: ", 0
prompt2         BYTE    "Second operand: ", 0
n1      DWORD ? ; First operand for arithmetic ops
n2      DWORD ? ; Second operand for arithmetic ops
radd    DWORD ? ; Result of addition
rsub    DWORD ? ; Result of subtraction
rmlt    DWORD ? ; Result of multiplication
rdiv    DWORD ? ; Result of division
rmod    DWORD ? ; Result of modulus(remainder)

; Results variables
add_str     BYTE    " + ", 0
sub_str     BYTE    " - ", 0
mul_str     BYTE    " * ", 0
div_str     BYTE    " / ", 0
rem_str     BYTE    " remainder ", 0
equ_str     BYTE    " = ", 0

; Farewell variables
bye         BYTE    "So long, and thanks for all the ints!", 0

; Exception messages
overflow_str    BYTE    "Integer overflow", 0
div0_str        BYTE    "Divide by zero", 0

.code
main PROC

    Introduction:
        mov EDX, OFFSET prog_name   ; Move prog_name string to EDX register
        call WriteString            ; WriteString reads from EDX register
        call Crlf                   ; All other string prints look like this

        mov EDX, OFFSET author_str
        call WriteString
        call Crlf
        call Crlf

        mov EDX, OFFSET u_instruction
        call WriteString
        call Crlf

    Get_Data:
        mov EDX, OFFSET prompt1
        call WriteString
        call ReadDec            ; Get user input in the form of an unsigned int
        mov n1, EAX             ; Store user input to variable

        mov EDX, OFFSET prompt2
        call WriteString
        call ReadDec
        mov n2, EAX

    Arithmetic:
        mov EAX, n1
        mov EBX, n2
        add EAX, EBX     ; EAX = n1 + n2
        mov radd, EAX    ; Store result to variable

        mov EAX, n1
        mov EBX, n2
        sub EAX, EBX     ; EAX = n1 - n2
        mov rsub, EAX

        ; This is sketchy. We're accepting 32-bit numbers,
        ; which means the result of MUL could be up to 64-bit.
        ; Printing a 64-bit int in 32-bit mode seems impractical.
        ; So let's hope the numbers don't get too big.
        mov EAX, n1
        mov EBX, n2
        mul EBX     ; EDX:EAX = n1 * n2
        jo overflow ; Check for overflow, exit if numbers get too big
        mov rmlt, EAX

        cmp n2, 0       ; Is the divisor going to be 0?
        jz  div0        ; Quit before divide by zero exception

        mov EAX, n1     ; dividend
        mov EDX, 0      ; div uses EDX:EAX, so make sure EDX is clear (sketchy!)
        mov EBX, n2     ; divisor
        div EBX         ; EAX = n1 / n2 and EDX = remainder
        mov rdiv, EAX
        mov rmod, EDX

    Results:
        call Crlf

        ; Print results of addition
        mov EAX, n1
        call WriteDec           ; WriteDec writes unsigned ints to console
        mov EDX, OFFSET add_str
        call WriteString
        mov EAX, n2
        call WriteDec
        mov EDX, OFFSET equ_str
        call WriteString
        mov EAX, radd
        call WriteDec
        call Crlf

        ; Print results of subtraction
        mov EAX, n1
        call WriteDec
        mov EDX, OFFSET sub_str
        call WriteString
        mov EAX, n2
        call WriteDec
        mov EDX, OFFSET equ_str
        call WriteString
        mov EAX, rsub
        call WriteDec
        call Crlf

        ; Print results of multiplication
        mov EAX, n1
        call WriteDec
        mov EDX, OFFSET mul_str
        call WriteString
        mov EAX, n2
        call WriteDec
        mov EDX, OFFSET equ_str
        call WriteString
        mov EAX, rmlt
        call WriteDec
        call Crlf

        ; ; Print results of division
        mov EAX, n1
        call WriteDec
        mov EDX, OFFSET div_str
        call WriteString
        mov EAX, n2
        call WriteDec
        mov EDX, OFFSET equ_str
        call WriteString
        mov EAX, rdiv
        call WriteDec
        mov EDX, OFFSET rem_str
        call WriteString
        mov EAX, rmod
        call WriteDec
        call Crlf
        call Crlf

    Farewell:
        mov EDX, OFFSET bye
        call WriteString
        call Crlf

    invoke ExitProcess,0   ; exit to operating system
main ENDP

; PROCEDURE DEFINITIONS

; Example of a proc doc
; Receives: parameters and how to pass them
; Returns: outputs and how to get them
; Preconditions: Things to do before calling
; Postconditions/Registers changed: Things that are different after call

overflow PROC
    mov EDX, OFFSET overflow_str
    call WriteString
    invoke ExitProcess,1    ; exit with code 1 if something overflows
overflow ENDP

div0 PROC
    mov EDX, OFFSET div0_str
    call WriteString
    invoke ExitProcess,1    ; exit with code 1 before trying to divide by 0
div0 ENDP



END main
