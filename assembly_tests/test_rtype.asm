addi $8, $zero, 490 # 0x000001ea
addi $9, $zero, 351 # 0x0000015f


add $10, $t1, $t0    # 0x00000349
and $11, $t1, $t0    # 0x0000014a
nor $12, $t1, $t0    # 0xfffffe00
or  $13, $t1, $t0    # 0x000001ff
sll $14, $t1, 15     # 0x00af8000
sllv $15, $t1, $t0   # 0x00057c00
slt $16, $t1, $t0    # 0x00000001
sra $17, $t1, 5      # 0x0000000a
srav $18, $t1, $t0   # 0x00000000
srl $19, $t0, 5      # 0x0000000f
srlv $20, $t1, $t0   # 0x00000000
sub $21, $t0, $t1    # 0x0000008b
subu $22, $t1, $t0   # 0xffffff75
xor $23, $t1, $t0    # 0x000000b5
addu $24, $t1, $t0   # 0x00000349
# need break, div, divu, jr, mfhi, mflo, mthi, mtlo, mult, multu, sltu
sw $9, -4
lw $25, -4
div $26, $8, $9
divu $27, $9, $8
j SkipSyscall
syscall # this should not happen if j works
SkipSyscall:
mthi $8
mtlo $9
mfhi $28
mflo $29
jal SkipSyscall2
# if 30 and 4 are the same as 28 and 29, then jal has failed because the mult in SkipSyscall2 should fill hi and lo with different numbers.
#mult $8, $9
mfhi $30 # if this line and all following before SkipSyscall2 don't happen, then jr has failed.
mflo $4
multu $9, $8
mfhi $1
mflo $2
sltu $3, $8, $9
syscall
SkipSyscall2:
mult $8, $9
jr $ra
