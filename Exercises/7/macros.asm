TITLE Program Template     (template.asm)

; Author:
; Course / Project ID                 Date:
; Description:

INCLUDE Irvine32.inc
INCLUDE customMacros.inc

.data
    HI = 1000
    LO = 0
    rand DWORD ?
    nloops DWORD ?
    prompt BYTE "Number of loops: ", 0
    delim BYTE ", ", 0

.code
main PROC
    mRandomize

    mWriteString prompt
    mReadDec nloops
    mCrlf
    mov ECX, nloops

    randLoop:
        mRandomRange rand, HI, LO
        mWriteDec rand
        mWriteString delim
        loop randLoop

    mCrlf

	exit	; exit to operating system
main ENDP

END main
