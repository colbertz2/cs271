### mReadString
`mReadString buffer, lenBuffer, maxSize`
Reads string input from the console, terminated with the return key.
#### Arguments
+ **buffer** - _(BYTE)_ Variable in which to store the string. Must have maxSize+1 capacity.
+ **lenBuffer** - _(DWORD)_ Variable in which to store the final length of the string. Must have DWORD capacity.
+ **maxSize** - _(DWORD)_ Maximum length of the string.
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

[Back to Top](../CustomMacros.md)
