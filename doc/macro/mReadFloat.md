### mReadFloat
`mReadFloat buffer`
Reads float input from the console, terminated by return key.
#### Preconditions
Initialize the FPU with `finit` before calling this macro.
#### Arguments
+ **buffer** - _(REAL8)_ Variable in which to store the float.
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

[Back to Top](../CustomMacros.md)
