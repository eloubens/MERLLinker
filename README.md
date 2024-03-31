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

Example
Suppose that input.asm now contains the following self-modifying code, and the load address α is 0x10000.

beq $0, $0, skip
changeMe: .word 0
skip:
lis $3
.word 241
lis $4
.word changeMe
sw $3, 0($4)
jr $31
Your program's output should be:

10000001
00000000
00001814
000000F1
00002014
00000010
AC830000
03E00008
10000001
000000F1
00001814
000000F1
00002014
00010004
AC830000
03E00008
Notice that in the first print, the 6th line is 0x10. In the second print, it has been relocated to 0x10004.

Also, in the second print, the 2nd line has changed to 0xF1 due to the self-modifying code. The self-modification should work regardless of the load address α.


Run all lines of the following code:

cs241.linkasm < load.asm > merl.merl

cs241.linker merl.merl starter.merl > combined.merl

cs241.binasm <<< '.word 0x10000' > address.bin

cs241.linkasm < i.txt > input.merl

cat address.bin input.merl > input.in

mips.stdin combined.merl < input.in

