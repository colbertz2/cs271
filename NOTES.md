# CS 271
## Computer Architecture & Assembly Language

## 1 Oct 2019 - Day 0
### Assembly Language
Low-level lanaguage that gives some direct access to hardware.

### Computer Architecture
Talking about the function of processors, and working out to other hardware components.

### Computer Hardware & Software
Hardware uses digital gates (transistors) to execute boolean logic.

### Data Representation & Arithmetic Systems
+ Arithmetic systems:
    + Decimal - Base 10
    + Binary - Base 2
    + Octal - Base 8
    + Hexadecimal - Base 16

+ Converting other bases to decimal (unsigned)
+ Converting decimal to other bases (unsigned)

> "I don't know if Visual Studio will work on the Mac. Maybe it will work, but you can't program in assembly."

## 3 Oct 2019 - Day 1
### Binary Number Operations
+ Binary Addition
+ Binary Subtraction
+ Binary Multiplication
+ Binary Division **Read**

### Signed Binary/Hexadecimal Numbers
For _n_ digits in a number,
+ Unsigned: 2^n - 1 positive numbers can be represented
+ Signed: 2^(n-1) -1 positive numbers and 2^(n-1) negative numbers represented

Signed binary numbers look like:
Bin     Dec
011     3
010     2
001     1
000     0
111     -1
110     -2
101     -3
100     -4

#### 2's Complement Method
**Read**
1. Find minimum number of bits necessary for the signed representation
2. Find the unsigned binary representation
3. Flip the bits
4. Add 1

**Read** Signed hex numbers


## 8 Oct 2019
### Floating Point Numbers
+ Converting a floating point decimal to binary
+ IEEE 754 Single Precision Numbers
+ Overviewed format for doubles and longs

### Character Encoding Systems
+ ASCII
+ Unicode


## 15 Oct 2019
### Computer Architecture
+ Von Neumann Architecture
+ Microarchitecture
+ Instruction Set Architecture (ISA)

#### Language Levels
+ 4 - Natural
    + Used by humans
    + Ex: English
+ 3 - High
    + English-like, portable across architecture
    + Translated to low-level by a compiler
    + Ex: C++
+ 2 - Low
    + Direct control of hardware
    + Ex: MASM, other Assembly
+ 1 - Machine
    + Literal binary

#### Common Uses of Assembly Language
+ Embedded programming
+ Real-time applications
+ Device drivers
+ Firmware

### Intel x86 Architecture - CISC
+ Complex Instruction Set Computing

#### CISC Components
+ Peripheral Devices
+ I/O Unit
+ Main Memory
+ CPU

### Other Architectures
+ RISC - Reduced Instruction Set Computing
+ EPIC - Explicitly Parallel Instruction Computing
+ MISC - Minimal Instruction Set Computing
+ VLIW - Very Long Instruction Word
+ OISC - One Instruction Set Computing

## 29 Oct 2019
### Intro to MASM
+ Template for asm files is on Canvas, under additional resources
+ `=` is only for assigning 32-bit ints
+ `EQU` is for assigning anything