### mWriteDec
`mWriteDec buffer`
Writes an unsigned integer to the console from memory.
#### Arguments
+ **buffer** - _(DWORD)_ Variable from which to read the integer.
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

[Back to Top](../CustomMacros.md)
