TITLE Arrays and Sorting     (hw4.asm)

; Author: Zach Colbert
; CS 271 / Homework 4                 Date: 27 November 2019
; Description: Creates an array of random integers and sorts it.

; LIBRARY INCLUDES
INCLUDE Irvine32.inc
INCLUDE customMacros.inc

; CONSTANT DEFINITIONS
INPUT_MIN = 10
INPUT_MAX = 200
RAND_MIN = 100
RAND_MAX = 999
PRNT_PER_LINE = 10
HLINE_LENGTH = 30
DELIMITER EQU <", ", 0>

.data
    ; Intro variables
    progName    BYTE    "Array Sorting Demo", 0
    authName    BYTE    "by Zach Colbert", 0
    hline       BYTE    HLINE_LENGTH DUP("-"), 0
    dhline      BYTE    HLINE_LENGTH DUP("="), 0

    ; User input variables
    prompt1     BYTE    "Enter integer length of array [", 0
    prompt2     BYTE    " - ", 0
    prompt3     BYTE    "]: ", 0
    tooHi       BYTE    " is too high. Try again.", 0
    tooLo       BYTE    " is too low. Try again.", 0
    arrLength   DWORD   ?

    ; Unsorted array variables
    unsortHead  BYTE    "Unsorted Array Contents", 0

    ; Sorted array variables
    sortHead    BYTE    "Sorted Array Contents", 0

    ; Array space in memory
    list        DWORD   INPUT_MAX DUP(?)    ; Only need WORD b/c max is small

    ; Array statistics variables
    arrMedian   DWORD   ?
    arrMean     DWORD   ?

.code
main PROC
    call intro

    push OFFSET arrLength
    call getUserInput



    exit    ; exit to operating system
main ENDP

; intro
;   Prints introductory information about the program.
;
;   Receives: 
;       Global variables progName, authName, dhline
;   Returns: 
;       None
;   Preconditions: 
;       None
;   Changes Registers: 
;       None
intro PROC
    push EDX
    mWriteString dhline
    mNewLine
    mWriteString progName
    mNewLine
    mWriteString authName
    mNewLine
    mWriteString dhline
    mNewLine
    mNewLine
    pop EDX
    ret
intro ENDP

; getUserInput
;   Prompts the user for a single, unsigned integer input.
;   If the input is outside the given range, the user is prompted again.
;
;   Receives:
;       Global byte strings prompt1, prompt2, prompt3, tooHi, tooLo
;       Global constant DWORDs INPUT_MIN, INPUT_MAX
;       Reference to DWORD variable in which to store input.
;   Returns:
;       DWORD unsigned integer.
;   Preconditions:
;       None
;   Changes Registers:
;       None
getUserInput PROC    
    push EBP
    mov EBP, ESP
    push EAX
    push EDX
    push ESI

    prompt:
        mWriteString prompt1
        mWriteDec INPUT_MIN
        mWriteString prompt2
        mWriteDec INPUT_MAX
        mWriteString prompt3

    ; Writing to memory and reading from memory again is not optimal
    ; But it's how the macro works
    mov ESI, [EBP + 8]
    mReadDec ESI
    mov EAX, [ESI]

    cmp EAX, INPUT_MIN
    jl boundLo
    cmp EAX, INPUT_MAX
    jg boundHi
    jmp fin

    boundLo:
        mWriteDec EAX
        mWriteString tooLo
        mNewLine
        mNewLine
        jmp prompt

    boundHi:
        mWriteDec EAX
        mWriteString tooHi
        mNewLine
        mNewLine
        jmp prompt

    fin:
    pop ESI
    pop EDX
    pop EAX
    pop EBP
    ret 4
getUserInput ENDP

; arrayFillRandom
;   Fills an array with random numbers between RAND_MIN and RAND_MAX
;
;   Receives:
;       Global constants RAND_MIN, RAND_MAX
;       Pointer to DWORD array, via stack
;       DWORD size of array, via stack
;   Returns:
;       Array filled with random unsigned integer values.
;   Preconditions:
;       Array size passed to this proc must be less or equal to
;       allocated space in memory.
;   Changes registers:
;       None
arrayFillRandom PROC
    push EBP
    mov EBP, ESP
    push ECX
    push ESI
    pushf

    mRandomize      ; Set random number seed
    mov ESI, [EBP + 12]     ; Pointer to first array elem
    mov ECX, [EBP + 8]      ; ECX = Array size

    ; Use counted loop to fill array elements
    topLoop:
        ; Save a random number to the current element
        mRandomRange ESI, RAND_MAX, RAND_MIN
        add ESI, sizeof DWORD   ; Advance to next element
        loop topLoop    ; Loop again if ECX != 0

    postLoop:
    popf
    pop ESI
    pop ECX
    pop EBP
    ret 8
arrayFillRandom ENDP

; arrayPrint
;   Prints the contents of an array of unsigned ints.
;
;   Receives:
;       Global constants, PRINT_PER_LINE and DELIMITER
;       Pointer to DWORD array, via stack (reference).
;       DWORD size of array, via stack (value).
;       Pointer to BYTE string, via stack.
;           (Prints additional info before array elements).
;   Returns:
;       Array contents printed to console, max PRINT_PER_LINE
;       elements per line and delimited by string DELIMITER.
;   Preconditions:
;       None
;   Changes Registers:
;       None
arrayPrint PROC
    push EBP
    mov EBP, ESP
    push EAX
    push ECX
    push ESI
    pushf

    mov ESI, [EBP + 8]      ; Pointer to info string
    mWriteString ESI

    mov ESI, [EBP + 16]     ; Pointer to first array elem
    mov ECX, [EBP + 12]     ; ECX = array size
    mov EAX, 0              ; Init EAX = 0

    topLoop:
        mWriteDec [ESI]         ; Write element to console
        add ESI, sizeof DWORD   ; Advance to next element
        inc EAX                 ; EAX += 1
        
        cmp ECX, 1
        je continue             ; Follow each element with a delimiter
        mWriteString DELIMITER  ; Except after last element
        
        cmp EAX, PRINT_PER_LINE
        jne continue            ; Insert newline every few elements
        mNewLine

        continue:
            loop topLoop

    mNewLine
    mNewLine

    popf
    pop ESI
    pop ECX
    pop EAX
    ret 12
arrayPrint ENDP

END main
