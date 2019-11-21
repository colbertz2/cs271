### mReadInt
`mReadInt buffer`
Reads signed integer input from the console, terminated with the return key.
#### Arguments
+ **buffer** - _(DWORD)_ Variable in which to store the integer.
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

[Back to Top](../CustomMacros.md)
