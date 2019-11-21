### mWriteString
`mWriteString buffer`
Writes a string to the console from memory.
#### Arguments
+ **buffer** - _(BYTE)_ Variable from which to read the string.
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

[Back to Top](../CustomMacros.md)
