# Assembly Language and Computer Architecture
Include 2 projects developed by MIPS Assembly Language:
- Curiosity Marsbot
- Palindrome String

# Curiosity Marsbot
The Curioisity Marsbot autonomous vehicle runs on Mars, which is operated remotely by programmers on Earth. 

By sending control codes from a matrix keyboard, the programmer controls Marbot's as follows:
- 1b4: Marbot started moving
- c68: Marbot pauses
- 444: Turn left 90* and keep a new direction
- 666: Turn right 90*  and keep in a new direction
- dad: Start leaving marks on the road
- cbc: Stop leaving marks on the road

After receiving the control code, Curioisity Marsbot will not process it immediately, but wait for the command to activate the code from the Keyboard & Display MMIO Simulator.

There are 2 commands:
- Enter key: Finish entering the code and ask Marbot to execute
- Del key: Delete all the code in progress.

Every time sending a control code to Marsbot, showing that code on the console screen so that viewers can monitor the vehicle's route.


# Palindrome String
Create a program to input a text line from keyboard and test if it is a palindrome.

For example: “abc121cba” is a palindrome. 

Store all palindromes which user typed into the memory, to make sure that user doesn’t duplicate a palindromes.


# Requirements
- MARS IDE (MIPS Assembler and Runtime Simulator). Install by Mars.zip file.
