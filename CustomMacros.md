# Custom Macros
for the Irvine32 Library

## Contents
### [Reading Macros](#reading-macros)
[mReadString](#mReadString)
[mReadDec](#mReadDec)
[mReadInt](#mReadInt)
[mReadFloat](#mReadFloat)
### [Writing Macros](#writing-macros)
[mWriteString](#mWriteString)
[mWriteDec](#mWriteDec)
[mWriteInt](#mWriteInt)
[mWriteFloat](#mWriteFloat)
[mNewLine](#mNewLine)
[mCrlf](#mCrlf)
[mClearScreen](#mClearScreen)
[mClrScr](#mClrScr)
### [Other Macros](#other-macros)
[mRandomize](#mRandomize)
[mRandomRange](#mRandomRange)

## Reading Macros
### mReadString
`mReadString buffer, lenBuffer, maxSize`
Reads string input from the console, terminated with the return key.
#### Arguments
**buffer** - _(BYTE)_ Variable in which to store the string. Must have maxSize+1 capacity.
**lenBuffer** - _(DWORD)_ Variable in which to store the final length of the string. Must have DWORD capacity.
**maxSize** - _(DWORD)_ Maximum length of the string.
#### Example
```
.data
    STR_SIZE = 21
    myString    BYTE    STR_SIZE DUP(0)
    strLength   DWORD   ?
    ...
.code
main PROC
    mReadString myString, strLength, STR_SIZE
    ...
    exit
main ENDP
```

### mReadDec
`mReadDec buffer`
Reads unsigned integer input from the console, terminated with the return key.
#### Arguments
**buffer** - _(DWORD)_ Variable in which to store the integer.
#### Example
```
.data
    myInt   DWORD   ?
    ...
.code
main PROC
    mReadDec myInt
    ...
    exit
main ENDP
```

### mReadInt
`mReadInt buffer`
Reads signed integer input from the console, terminated with the return key.
#### Arguments
**buffer** - _(DWORD)_ Variable in which to store the integer.
#### Example
```
.data
    myInt   DWORD   ?
    ...
.code
main PROC
    mReadInt myInt
    ...
    exit
main ENDP
```

### mReadFloat
`mReadFloat buffer`
Reads float input from the console, terminated by return key.
#### Preconditions
Initialize the FPU with `finit` before calling this macro.
#### Arguments
**buffer** - _(REAL8)_ Variable in which to store the float.
#### Example
```
.data
    myFloat     REAL8   ?
    ...
.code
main PROC
    finit
    mReadFloat REAL8
    ...
    exit
main ENDP
```

## Writing Macros
### mWriteString
`mWriteString buffer`
Writes a string to the console from memory.
#### Arguments
**buffer** - _(BYTE)_ Variable from which to read the string.
#### Example
```
.data
    myString    BYTE    "This is my string!", 0
    ...
.code
main PROC
    mWriteString myString
    ...
    exit
main ENDP
```

### mWriteDec
`mWriteDec buffer`
Writes an unsigned integer to the console from memory.
#### Arguments
**buffer** - _(DWORD)_ Variable from which to read the integer.
#### Example
```
.data
    myInt   DWORD   5
    ...
.code
main PROC
    mWriteDec myInt
    ...
    exit
main ENDP
```

### mWriteInt
`mWriteInt buffer`
Writes a signed integer to the console from memory.
#### Arguments
**buffer** - _(DWORD)_ Variable from which to read the integer.
#### Example
```
.data
    myInt   DWORD   -9
    ...
.code
main PROC
    mWriteInt buffer
    ...
    exit
main ENDP
```

### mWriteFloat
`mWriteFloat buffer`
Writes a float to the console from memory.
#### Preconditions
Intialize the FPU with `finit` before calling this macro.
#### Arguments
**buffer** - _(REAL8)_ Variable from which to read the float.
#### Example
```
.data
    myFloat     REAL8   4.768
    ...
.code
main PROC
    finit
    mWriteFloat myFloat
    ...
    exit
main ENDP
```

### mNewLine
`mNewLine`
Writes a newline to the console.

### mCrlf
`mCrlf`
Writes a newline to the console.

### mClearScreen
`mClearScreen`
Clears the console window.

### mClrScr
`mClrScr`
Clears the console window.

## Other Macros
### mRandomize
`mRandomize`
Sets a seed for the random number sequence. Call once during the program to initialize.

### mRandomRange
`mRandomRange buffer, hi, lo`
Returns a random integer in the specified range.
#### Preconditions
Set the random number seed with `mRandomize` or `call Randomize` before calling this macro.
#### Arguments
**buffer** - _(DWORD)_ Variable in which to store the random integer.
**hi** - _(DWORD)_ Maximum value of the random number.
**lo** - _(DWORD)_ Minimum value of the random number.
#### Example
```
.data
    RAND_MAX = 10
    RAND_MIN = 1
    myRand  DWORD   ?
    ...
.code
main PROC
    mRandomize
    mRandomRange myRand, RAND_MAX, RAND_MIN
main ENDP