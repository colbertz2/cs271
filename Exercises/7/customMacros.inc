mReadString MACRO buffer, lenBuffer, maxSize
    push EDX
    push ECX
    push EAX

    mov EDX, OFFSET buffer
    mov ECX, maxSize
    call ReadString

    mov [lenBuffer], EAX

    pop EAX
    pop ECX
    pop EDX
ENDM

mReadDec MACRO buffer
    push EAX
    pushf

    call ReadDec
    mov [buffer], EAX

    popf
    pop EAX
ENDM

mReadInt MACRO buffer
    push EAX
    pushf

    call ReadInt
    mov [buffer], EAX
    
    popf
    pop EAX
ENDM

mReadFloat MACRO buffer
    call ReadFloat
    fstp buffer
ENDM

mRandomize MACRO
    call Randomize
ENDM

mRandomRange MACRO buffer, hi, lo
    push EAX

    mov EAX, hi
    sub EAX, lo
    inc EAX
    call RandomRange
    add EAX, lo
    mov [buffer], EAX

    pop EAX
ENDM

mWriteString MACRO buffer
    push    EDX
    mov     EDX, OFFSET buffer
    call    WriteString
    pop     EDX
ENDM

mWriteDec MACRO num
    push    EAX
    mov     EAX, num
    call    WriteDec
    pop     EAX
ENDM

mWriteInt MACRO num
    push    EAX
    mov     EAX, num
    call WriteInt
    pop     EAX
ENDM

mWriteFloat MACRO buffer
    fld buffer
    call WriteFloat
    fstp st(0)  ; Throw away the top of the stack
ENDM

mNewLine MACRO
    call Crlf
ENDM

mCrlf MACRO
    call Crlf
ENDM

mClearScreen MACRO
    call ClrScr
ENDM

mClrScr MACRO
    call ClrScr
ENDM