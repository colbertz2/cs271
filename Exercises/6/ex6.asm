TITLE Fibonacci Calculator		(ex6.asm)

; Author: Zach Colbert
; CS 271 / Exercise 6                 Date: 11 November 2019
; Description: Prints the number of Fibonacci numbers specified by the user.

INCLUDE Irvine32.inc

.data
	; Constant definitions
	progName	DB		"=== FIBONACCI CALCULATOR ===", 0
	authName	DB		"by Zach Colbert", 0
	namePrompt	DB		"Enter your name: ", 0
	greet1		DB		"Nice to meet you, ", 0
	greet2		DB		"!", 0
	intPrompt	DB		"Number of Fibonacci terms to print (1-46): ", 0
	intTooSmall	DB		" is too small. Choose a number 1 or greater.", 0
	intTooBig	DB		" is too large. Choose a number 46 or smaller.", 0
	intSpace	DB		5 DUP(' '), 0		; 5 spaces between results
	boundLow	EQU		1		; User input may not be less
	boundHigh	EQU		46		; User input may not be greater
	bye			DB		"Goodbye, ", 0

	; Introduction variables
	userName	BYTE	21 DUP(0)

	; Fibonacci variables
	nLoops		DWORD	?


.code
main PROC

	Introduction:
		mov EDX, OFFSET progName	; Write the program name
		call WriteString
		call Crlf

		mov EDX, OFFSET authname	; Write the author name
		call WriteString
		call Crlf
		call Crlf

		mov EDX, OFFSET namePrompt	; Get the user's name
		call WriteString
		mov EDX, OFFSET userName	; Store the user's name here
		mov ECX, SIZEOF userName	; Max number of characters
		call ReadString

		mov EDX, OFFSET greet1		; Greet the user
		call WriteString
		mov EDX, OFFSET userName	; personalize the greeting
		call WriteString
		mov EDX, OFFSET greet2		; End greeting
		call WriteString
		call Crlf
		call Crlf

	UserInstruction:
		mov EDX, OFFSET intPrompt	; Write instructions for the user
		call WriteString

	GetData:
		call ReadDec	; Get an unsigned decimal integer from the user

		LowerBound:
			cmp EAX, boundLow	; Compare user input to 1
			jge UpperBound		; n >= 1 is in bounds! Carry on
			mov EDX, OFFSET intTooSmall
			call WriteDec
			call WriteString	; Print an error message
			call Crlf
			jmp UserInstruction			; Try again

		UpperBound:
			cmp EAX, boundHigh	; Compare user input to 46
			jle Fibonacci		; n <= 46 is in bounds! Carry on
			mov EDX, OFFSET intTooBig
			call WriteDec
			call WriteString	; Print an error message
			call Crlf
			jmp UserInstruction			; Try again

	Fibonacci:
		mov nLoops, EAX		; Save user input

		call Crlf
		mov ECX, EAX	; Initialize loop counter from user input
		mov EAX, 0		; Initialize accumulator to zero
		push 0			; init Previous, previous result
		push 1			; init Previous result

		FibLoop:
			cmp ECX, nLoops
			je FibMain			; Avoid dividing by zero in the first loop

			NewLine:
				push EAX			; Save EAX
				mov BX, CX			; Copy of loop counter
				mov EAX, nLoops		; Copy of nLoops
				sub AX, BX			; AX = Num of loops executed so far
                mov BX, 5			; Set divisor
				div BL				; Divide num of loops by 5, EDX is remainder
				cmp AH, 0			; have we executed a multiple of 5 loops?
				pop EAX				; Restore EAX
				jnz FibMain
				call Crlf
			
			FibMain:
				pop EBX			; Pop previous result, and keep it around
				pop EAX			; Pop pre,previous result... okay to overwrite
				add EAX, EBX	; Add previous two results, store in EAX
				call WriteDec	; Write the result to the console
				mov EDX, OFFSET intSpace
				call WriteString
				push EBX		; Push previous result --> Now pre,previous
				push EAX		; Push current result --> Now previous

			loop FibLoop

	Goodbye:
		call Crlf
		mov EDX, OFFSET bye
		call WriteString
		mov EDX, OFFSET userName
		call WriteString
		mov EDX, OFFSET greet2
		call WriteString
		call Crlf

	exit	; exit to operating system
main ENDP

; (insert additional procedures here)

END main
