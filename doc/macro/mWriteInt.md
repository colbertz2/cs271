### mWriteInt
`mWriteInt buffer`
Writes a signed integer to the console from memory.
#### Arguments
+ **buffer** - _(DWORD)_ Variable from which to read the integer.
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

[Back to Top](../CustomMacros.md)
