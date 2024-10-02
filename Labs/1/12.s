.data
v1  = .byte 2, 6, -3, 11, 9, 18, -13, 16, 5, 1 #byte riserva 1 byte
v2  = .byte 4, 2, -13, 3, 9, 9, 7, 16, 4, 7 #word riserva 2 byte
v3  = .space 10

.text
main:
    daddui r1, r0, 10 # counter per v1
    daddui r2, r0, 0 # i = 0
    daddui r4, r0, 0 # k = 0

loop_1:
        lb r5, v1(r2) # r5 = v1[0] 
        daddui r6, r0, 0 # counter per v2
        daddui r3, r0, 10 # j = 10

loop_2:
        lb r7, v2(r6)  #r7 = v2[0]
        beq r5, r7, found  #if(v1[i] == v2[j]) then found
        daddi r6, r6, 1  #v2[j+1]
        daddui r3, r3, -1  #j--
        bnez r6, loop_2 #if(j != 0) then loop_2 [torna su finchè j != 0]

found:
        sb r5, v3(r4) #v3[k] = v1[i]
        daddi r4, r4, 1 #k++ 
        j loop_1 #torna a loop_1 (break)

end:
    HALT