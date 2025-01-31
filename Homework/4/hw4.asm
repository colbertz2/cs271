TITLE Arrays and Sorting     (hw4.asm)

; Author: Zach Colbert
; CS 271 / Homework 4                 Date: 27 November 2019
; Description: Creates an array of random integers and sorts it.

; LIBRARY INCLUDES
INCLUDE Irvine32.inc
INCLUDE customMacros.inc

; MACRO DEFINITIONS
; mArrayIndex
;   Advance ESI to the given DWORD array index.
mArrayIndex MACRO array, i
    LOCAL advance
    LOCAL postloop

    push ECX
    pushf

    mov ESI, array
    mov ECX, i

    cmp ECX, 0
    jz postloop

    advance:
        add ESI, sizeof DWORD
        loop advance

    postloop:
    popf
    pop ECX
ENDM

; mArraySwap
;   Swap two values in an array at indices i and j
mArraySwap MACRO array, i, j
    push ESI
    push EDI
    pushf

    mArrayIndex array, i
    push [ESI]          ; Get value from i
    mov EDI, ESI        ; Save pointer to this index

    mArrayIndex array, j
    push [ESI]          ; Get value from j

    pop [EDI]           ; Save [j] to i
    pop [ESI]           ; Save [i] to j

    popf
    pop EDI
    pop ESI
ENDM

; CONSTANT DEFINITIONS
INPUT_MIN = 10
INPUT_MAX = 200
RAND_MIN = 100
RAND_MAX = 999
PRINT_PER_LINE = 10
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
    arrLength   DWORD   ?

    ; Unsorted array variables
    unsortHead  BYTE    "Unsorted Array Contents: ", 0

    ; Sorted array variables
    sortHead    BYTE    "Sorted Array Contents: ", 0
    delimiter   BYTE    ", ", 0

    ; Array space in memory
    list        DWORD   INPUT_MAX DUP(?)    ; Only need WORD b/c max is small?

    ; Array statistics variables
    arrMedian   DWORD   ?
    arrMean     DWORD   ?

.code
main PROC
    call intro

    push OFFSET arrLength
    call getUserInput

    push OFFSET list
    push arrLength
    call arrayFillRandom

    push OFFSET list
    push arrLength
    push OFFSET unsortHead
    call arrayPrint

    push OFFSET list
    push 0              ; "Low" index for quicksort
    mov EAX, arrLength
    dec EAX
    push EAX            ; "High" index for quicksort
    call arrayQuickSort

    push OFFSET list
    push arrLength
    push OFFSET sortHead
    call arrayPrint

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
    mWriteString OFFSET dhline
    mNewLine
    mWriteString OFFSET progName
    mNewLine
    mWriteString OFFSET authName
    mNewLine
    mWriteString OFFSET dhline
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
        mWriteString OFFSET prompt1
        mWriteDec INPUT_MIN
        mWriteString OFFSET prompt2
        mWriteDec INPUT_MAX
        mWriteString OFFSET prompt3

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
        mWriteString OFFSET tooLo
        mNewLine
        mNewLine
        jmp prompt

    boundHi:
        mWriteDec EAX
        mWriteString OFFSET tooHi
        mNewLine
        mNewLine
        jmp prompt

    fin:
    mNewLine
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
    mNewLine

    mov ESI, [EBP + 16]     ; Pointer to first array elem
    mov ECX, [EBP + 12]     ; ECX = array size
    mov EAX, 0              ; Init EAX = 0

    topLoop:
        mWriteDec [ESI]         ; Write element to console
        add ESI, sizeof DWORD   ; Advance to next element
        inc EAX                 ; EAX += 1
        
        cmp ECX, 1
        je continue             ; Follow each element with a delimiter
        mWriteString OFFSET DELIMITER  ; Except after last element
        
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
    pop EBP
    ret 12
arrayPrint ENDP

; arrayQuickSort
;   Uses the Quicksort algorithm to sort the given array in place.
;   Based on info and algorithms from https://www.geeksforgeeks.org/quick-sort/
;
;   Receives:
;       Pointer to DWORD array, via stack (reference).
;       DWORD starting index, via stack (value). Initially call with 0.
;       DWORD ending index, via stack (value). Initially call with max index.
;   Returns:
;       Sorted array in memory.
;   Preconditions:
;       None.
;   Registers Changed:
;       None.
arrayQuickSort PROC
    push EBP
    mov EBP, ESP
    push EAX
    push EBX
    pushf

    mov EAX, [EBP + 12]     ; EAX = Starting index (lo)
    cmp EAX, [EBP + 8]      ; Compare lo to ending index (hi)
    jge postcon             ; if (lo < hi) { ... } else { return; }

    call qsPartition        ; EAX = partition index (pi)
    mov EBX, EAX
    dec EAX         ; EAX = pi - 1
    inc EBX         ; EBX = pi + 1

    push [EBP + 16]         ; Array pointer
    push [EBP + 12]         ; Same lo value
    push EAX                ; Pass pi - 1 as hi
    call arrayQuickSort     ; Sort the parts of the array up to pi

    push [EBP + 16]         ; Array pointer
    push EBX                ; Pass pi + 1 as lo
    push [EBP + 8]          ; Same hi value
    call arrayQuickSort     ; Sort the parts of the array after pi

    postcon:
    ; FOR DEBUG
    ;push OFFSET list
    ;push arrLength
    ;push OFFSET delimiter
    ;call arrayPrint

    popf
    pop EBX
    pop EAX
    pop EBP
    ret 12
arrayQuickSort ENDP

; qsPartition
qsPartition PROC    ; +16 array, +12 lo, +8 hi
    ;push EBP
    ;mov EBP, ESP        Keep using the same stack frame!
    push ESI
    push EBX
    push ECX
    push EDI
    pushf

    mArrayIndex [EBP + 16], [EBP + 8]   ; ESI = (array + hi)
    mov EAX, [ESI]      ; Save pivot value to EAX

    mov EBX, [EBP + 12]
    dec EBX             ; EBX = lo - 1
    mArrayIndex [EBP + 16], [EBP + 12]      ; ESI (array + lo)
    mov ECX, [EBP + 12]     ; Loop counter = lo

    sortLoop:
        mov EDI, [ESI]
        cmp EDI, EAX        ; Compare current value to pivot value
        jge postLoop
        inc EBX         ; If current value < pivot
        mArraySwap [EBP + 16], EBX, ECX
        add ESI, sizeof DWORD   ; Advance to next element
        inc ECX                 ; Advance to next element
        cmp ECX, [EBP + 8]
        jl sortLoop

    postLoop:
        inc EBX             ; EBX = i + 1
        mArraySwap [EBP + 16], EBX, [EBP + 8]   ; Swap [i+1] and [hi]
        mov EAX, EBX        ; return i + 1

    popf
    pop EDI
    pop ECX
    pop EBX
    pop ESI
    ;pop EBP
    ret
qsPartition ENDP

END main
