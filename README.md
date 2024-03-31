# MERLLinker

Write a MIPS program that reads input (from standard input) consisting of a 32-bit memory address α followed by a MERL file.

Your program should load the MIPS code segment of the MERL file into memory at address α, and print each word of the MIPS code segment as it gets loaded.
Next, it should read the footer of the MERL file and perform relocation on the loaded MIPS code.
Then, it should jump to address α and execute the loaded MIPS code.
After the loaded MIPS code finishes running, print the loaded MIPS code (as it exists in memory at address α) then return.
All words should be printed using the provided printHex procedure.

Implementation Notes
This time, the MERL file can have a non-empty footer. However, the footer of the MERL file will only contain REL entries. You will not encounter ESR and ESD entries.

All other implementation notes from Problem 6 still apply. The main difference is that in this problem, you will be tested with programs that do not work when loaded at nonzero addresses unless relocation is performed correctly.



We have provided some starter code in the form of two MIPS procedures:

readWord, which takes no parameters and reads a single word (4 bytes) from standard input, storing the value in $3. If standard input has fewer than 4 bytes remaining, the behaviour is undefined.
printHex, which prints the hexadecimal representation of the word in $1 to standard output, followed by a newline. It does not return a value.
Both procedures preserve all registers not used for return values. So readWord preserves all registers except $3, and printHex preserves all registers.

The starter code is provided as both assembly source code and a MERL library. It is up to you whether you simply copy the source code into your submissions, or use the ".import" directive to import the procedures from the MERL file. Marmoset will accept both options.
Make sure that starter.merl is present in the directory where you are running this code.


Run all lines of the following code:
- .word 0x10000 is α (the starting address to load in the MERL file).
- Make sure that starter.merl is present in the directory where you are running this code.

cs241.linkasm < load.asm > merl.merl

cs241.linker merl.merl starter.merl > combined.merl

cs241.binasm <<< '.word 0x10000' > address.bin

cs241.linkasm < i.txt > input.merl

cat address.bin input.merl > input.in

mips.stdin combined.merl < input.in > output.txt




