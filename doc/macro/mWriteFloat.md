### mWriteFloat
`mWriteFloat buffer`
Writes a float to the console from memory.
#### Preconditions
Intialize the FPU with `finit` before calling this macro.
#### Arguments
+ **buffer** - _(REAL8)_ Variable from which to read the float.
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

[Back to Top](../CustomMacros.md)
