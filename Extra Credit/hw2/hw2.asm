TITLE Dog years     (demo1.asm)
; Description:  This program gets the age of the user and and calculates their age in dog years (age x 7).
INCLUDE Irvine32.inc

.data
	age			DWORD	?										; User's age
	hi_there	BYTE	"Hi there, this is Zach",0				; Greeting the user
	prompt1		BYTE	"Can I have your age please?",0			; Gets age
	output		BYTE	"So, your age in dog years is: ",0			; Reposts dog age
	byebye		BYTE	"Thanks for passing by, have a great day!",0	; Bye bye
	youth_str	BYTE	"Wow! That young but you know how to use a computer!",0		; Extra credit string

.code
main PROC
; Greet the user
	mov	EDX, OFFSET hi_there		; Set up for call to WriteString and greet the user
	call	WriteString
	call	Crlf
; Gets the user's age
	mov	EDX, OFFSET prompt1		; Asks the user's age
	call	WriteString
	call	Crlf
	call	ReadInt			; Reads the users age. Age in EAX
	call	Crlf

; Extra credit: Make the young people feel special
	cmp	EAX, 4
	jg calculate
    call youth

calculate:
; Calculate the dog years and stores the dog age
	mov	EBX, 7
	mul	EBX
	mov	age, EAX			; Stores the users dog age. Dog age also in EAX
	
; Reports the dog years and says bye
	mov	EDX, OFFSET output
	call	WriteString
	mov	EAX, age
	call	WriteDec
	call	Crlf
	mov	EDX, OFFSET byebye
	call	WriteString
	call	Crlf
	exit				;exit to operating system
	
main ENDP

youth PROC
	pushad

	mov	EDX, OFFSET youth_str	; Set up string for printing
	call WriteString
	call Crlf

	popad

	ret		; proc takes no parameters, so we do not need to free anything from the stack
youth ENDP

END main