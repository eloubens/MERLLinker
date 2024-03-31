.import readWord
.import printHex

lis $12
.word readWord          ; reads in 4 bytes and stores in $3. 
lis $14
.word printHex
lis $4
.word 4
lis $11
.word 1
lis $17               ; load from mems
.word 0xffff0004
lis $18                 ; store location to stdout
.word 0xffff000c

; Each Merl line in MERL file is 4 bytes = 1 word.
; header: each of beq $0, $0, $2, end of merl file, and end of MIPS code lines
; End of merl file:  the length (in bytes) of the .merl file
; End of mips code: the length (in bytes) of the header plus the MIPS program (see below)


add $13, $31, $0        ; save $31 in $13

jalr $12                ; read word. stores in $3. For alpha. (32 bits = 4 bytes)
add $10, $3, $0         ; store starting address alpha in $10

jalr $12                ; call readWord. stores in $3. For beq $0, $0, $2.

jalr $12                ; call readWord. stores in $3. For end of module.
add $15, $3, $0         ; $15 stores merl file end                 

jalr $12                ; call readWord. stores in $3. for end of MIPS code address. (also its length + header)
add $16, $3, $0         ; $16 stores mips code end + header
                        ; subtract header which is 3 lines long of 4 bytes = 12 bytes.
sub $16, $16, $4
sub $16, $16, $4
sub $16, $16, $4        ; $16 stores mips code length

add $20, $0, $0         ; counter for which line of MIPS code block. Counts by 4.
        
    


loop1:
beq $20, $16, exitloop1 ; check that counter != size of MIPS code block

jalr $12                ; call readWord. stores mips code in $3.
add $1, $3, $0          ; $1 = $3 since print hex takes in arg in $1
jalr $14                ; call print hex. prints $1 to stdout

add $23, $10, $20       ; counter for the mem addres to store. $23 = starting address($10) + counter($20)
sw $3, 0($23)           ; store MIPS code stored in $3 to start at mem address $10
add $20, $20, $4        ; $20 = $20 + $4. increment counter.
beq $0, $0, loop1       ; loop1
exitloop1:

lis $9                   ; store 12 which is header offset
.word 0x0c

loopfooter:
jalr $12                ; call readWord. stores mips code in $3. To read in 0x00000001 which tells you relocation.
bne $3, $11, exitloopfooter  ; check that $3 is 0x01  which tells you relocation.
jalr $12                ; call readWord. stores mips code in $3. $3 stores address that needs to be relocated in MERL file.
                        ; $3 stores the address that needs to relocated assuming MERL file starts at 0x00 and includes header. 
add $23, $10, $3        ; To $3, need to add alpha ($10) and subtract 0x0c(12), since we stored MERL code on stack starting at starting address alpha excluding the header. 
sub $23, $23, $9
                        ; $3 which stores relocation address given is the address in the MERL file which starts at 0x00
                        ; we've saved code on heap at (alpha + codes original offset from 0x00)
lw $19, 0($23)          ; $19 stores the label value that we need to relocated
sub $19, $19, $9        ; $19 = $19 - 12 to get rid of header!
add $19, $19, $10       ; $19 = $19 + alpha to get added offset since were storing at alpha and label needs to be in relation to full RAM address   
sw $19, 0($23)          ; rewrite the label address on stack
beq $0, $0, loopfooter  ; loopfooter
exitloopfooter:

                        ; set $30 and store needed registers on stack!
lis $30
.word 1114116
sw $13, -4($30)         ; stores $31 !!!
sw $10, -8($30)         ; stores alpha
sw $15, -12($30)        ; $15 stores merl file end  
sw $16, -16($30)        ; $16 stores mips code length

lis $16
.word 16
sub $30, $30, $16

                        ; jump to alpha to execute mips code
jalr $10


                        ; restore to old register values
lis $30
.word 1114116
lw $13, -4($30)         ; stores $31 !!!
lw $10, -8($30)         ; stores alpha
lw $15, -12($30)        ; $15 stores merl file end  
lw $16, -16($30)        ; $16 stores mips code length
                        ; set constants
lis $12
.word readWord          ; reads in 4 bytes and stores in $3. 
lis $14
.word printHex
lis $4
.word 4
lis $11
.word 1
lis $17               ; load from mems
.word 0xffff0004
lis $18                 ; store location to stdout
.word 0xffff000c


add $20, $0, $0         ; counter for which line of MIPS code block. set back to 0.

loop2:
beq $20, $16, exitloop2 ; check that counter != size of MIPS code block
add $23, $10, $20       ; counter for the mem address where mips code is stored. 
                        ; $23 = starting address($10) + counter($20)
lw $1, 0($23)           ; load stored mips code into $1 
                        ; since print hex takes arg in $1.
jalr $14                ; call print hex. prints $1 to stdout
add $20, $20, $4        ; $20 = $20 + $4. increment counter.
beq $0, $0, loop2       ; loop2

exitloop2:

add $31, $0, $13        ; reset $31 to its value
jr $31

; scrap code
