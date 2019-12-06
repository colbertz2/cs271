# Battleship.asm
Code Review for Final Project

## Program Description
+ Emulates the board game "Battleship" in a console window
+ Player places three ships on a grid. Computer does the same, obscured from player.
+ Player and computer take turns guessing where the other's ships are in the grid.
+ Game indicates hits and misses on a separate grid for the player, to keep track of where the player has already fired.
+ Whichever player is left with ships still on the board wins.

## Procedures Review
### main
+ Calls procs to initialize the game and place ships on the board
+ Loops calls to procs that execute player/computer turns and check the board for win conditions

### intro
+ Prints `welcstr`
+ Prints `seedstr`, prompting for seed number
+ Reads seed number, looping if it's invalid
+ Uses the seed number _n_ to get the nth number in sequence from `RandomRange` [Note](#random-numbers)
+ Calls [`WaitMsg`](#waitmsg)
+ Clears the console

### fillboard
### display
### plc3ship
### plc2ship
### plc1ship
### cplc3ship
### cplc2ship
### cplc1ship
### plyrtrn
### comptrn
### chkbrd

## Functional Decomposition

## Direct Questions
### How do the programmers use registers? Do they use sub-registers?
### Which addressing modes do the programmers use?
### Do the programmers use the stack?
### Do the programmers use constants and macros?
### Do the programmers use the FPU?
### How do the programmers handle I/O?

### Are there any procedures or instructions that you did not learn in the class? Can you figure out what they do?
#### WaitMsg

### Are there any graphics? How do the programmers implement graphics?
### Do the programmers include enough documentation?

## Bugs
### Random Numbers
Can't find `Randomize` called anywhere. So the seed number could potentially pull the same random number each time we run the program?

## Improvements