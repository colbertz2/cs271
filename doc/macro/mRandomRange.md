### mRandomRange
`mRandomRange buffer, hi, lo`
Returns a random integer in the specified range.
#### Preconditions
Set the random number seed with `mRandomize` or `call Randomize` before calling this macro.
#### Arguments
+ **buffer** - _(DWORD)_ Variable in which to store the random integer.
+ **hi** - _(DWORD)_ Maximum value of the random number.
+ **lo** - _(DWORD)_ Minimum value of the random number.
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
```

[Back to Top](../CustomMacros.md)
