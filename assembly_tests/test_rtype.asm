addi $t0, $zero, 490 # 0x000001ea
addi $t1, $zero, 351 # 0x0000015f

add $t2, $t1, $t0    # 0x00000349
and $t3, $t1, $t0    # 0x0000014a
nor $t4, $t1, $t0    # 0xfffffe00
or  $t5, $t1, $t0    # 0x000001ff
sll $t6, $t1, 15     # 0x00af8000
sllv $t7, $t1, $t0   # 0x00057c00
slt $s0, $t1, $t0    # 0x00000001
sra $s1, $t1, 5      # 0x0000000a
srav $s2, $t1, $t0   # 0x00000000
srl $s3, $t0, 5      # 0x0000000f
srlv $s4, $t1, $t0   # 0x00000000
sub $s5, $t0, $t1    # 0x0000008b
subu $s6, $t1, $t0   # 0xffffff75
xor $s7, $t1, $t0    # 0x000000b5
addu $t8, $t1, $t0   # 0x00000349

syscall