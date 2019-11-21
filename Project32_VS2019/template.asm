TITLE Program Template     (template.asm)

; Author:
; Course / Project ID                 Date:
; Description:

INCLUDE Irvine32.inc

; (insert constant definitions here)
mWriteStr MACRO buffer
    push    EDX
    mov     EDX, OFFSET buffer
    call    WriteString
    call    Crlf
    pop     EDX
ENDM

.data

; (insert variable definitions here)

.code
main PROC

; (insert executable instructions here)
    mWriteStr "This is a string",0

	exit	; exit to operating system
main ENDP

; (insert additional procedures here)

END main
