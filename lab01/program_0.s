#VIVARELLI NICOLA
# S336797
# LAB01 - Esercizio 1

.data
v1: .byte 2, 6, -3, 11, 9, 18, -13, 16, 5, 1
v2: .byte 4, 2, -13, 3, 9, 9, 7, 16, 4, 7       
v3: .space 10
f1: .byte 0
f2: .byte 1
f3: .byte 1

.text

MAIN: 
    dadd r1, r0, r0     # pointer v1 = 0
    daddui r2, r0, 10   # counter v1 = 10
    daddui r3, r0, 0    # pointer v3 = 0

loop1:
    lb r4, v1(r1)       # r4 = v1[pointer v1]
    dadd r5, r0, r0     # pointer v2 = 0
    daddui r6, r0, 10   # counter v2 = 10
loop2:
    lb r7, v2(r5)       # r7 = v2[pointer v2]
    beq r4, r7, found   # if v1[i] == v2[j] then found
    daddui r5, r5, 1    # pointer v2++
    daddui r6, r6, -1   # counter v2--
    bnez r6, loop2      # if v2 has more elements then loop2 

    daddui r1, r1, 1    # v1++
    daddui r2, r2, -1   # counter v1--
    bnez r2, loop1      # if v1 has more elements then loop1

    j set_flags

found:
    sb r4, v3(r3)       # v3[pointer v3] = v1[pointer v1]
    daddui r3, r3, 1    # pointer v3++
    daddui r1, r1, 1    # pointer v1++
    daddui r2, r2, -1   # counter v1--
    bnez r2, loop1      # if v1 has more elements then loop1


set_flags:
    beq r3, r0, set1    # if v3 has no elements then set1
    dadd r13, r3, r0    # Save length of v3 in r13
    daddui r3, r0, 0    # pointer v3 = 0
    daddui r14, r0, 0   # pointer v3_2 = 0

sort1:
    #checks that the array is sorted 
    lb r9, v3(r3)       # r9 = v3[0]
    daddui r3, r3, 1    # pointer v3++
    lb r10, v3(r3)      # r10 = v3[1]
    slt r11, r9, r10    # if v3[i] < v3[i++] then r11 = 1
    bnez r11, set_flag2 # if r11 == 0 then set2
    bne r3, r13, sort1  # if v3 has elements then go back up
    j end

set_flag2:
    # flag2 = 0 because the array is not sorted ascending
    daddui r12, r0, 0
    sb r12, f2(r0)      # flag2 = 0
    j sort2

sort2:
    lb r9, v3(r14)       # r9 = v3[0]
    daddui r14, r14, 1    # r5 = r5 + 1
    lb r10, v3(r14)      # r10 = v3[i+1]
    slt r11, r10, r9    # if v3[i] > v3[i++] then r11 = 1
    bnez r11, set_flag3 # if r11 == 0 then set_flag3
    bne r14, r13, sort2  # if v3 has elements then go back up
    j end


set_flag3:
    # flag3 = 0 because the array is not sorted descending
    daddui r12, r0, 0
    sb r12, f3(r0)      #flag3 = 0
    j end

set1:
    # enters only if v3 has no elements
    daddui r8, r0, 1
    sb r8, f1(r0)       # flag1 = 1
    j end

end:
    halt
