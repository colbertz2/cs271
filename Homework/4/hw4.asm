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
    arrLength       DWORD   ?

    ; Unsorted array variables
    unsortHead     BYTE    "Unsorted Array Contents", 0

    ; Sorted array variables
    sortHead       BYTE    "Sorted Array Contents", 0

    ; Array space in memory
    ; How do?

    ; Array statistics variables
    arrMedian   DWORD   ?
    arrMean     DWORD   ?

.code
main PROC
    call intro

    push OFFSET arrLength
    call getUserInput

    mWriteDec arrLength

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

END main
