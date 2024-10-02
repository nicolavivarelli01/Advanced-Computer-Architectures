.data
v1 = .byte 2, 6, -3, 11, 9, 18, -13, 16, 5, 1 #byte riserva 1 byte
v2 = .byte 4, 2, -13, 3, 9, 9, 7, 16, 4, 7 #word riserva 2 byte
v3 = .space 10

.text

MAIN: 
    daddui r1, r0, 0 # i = 0
    daddui r2, r0, 0 # j = 0
    daddui r3, r0, 0 #k = 0
    dadd   r4, r0, 0 # pointer v1
    dadd   r5, r0, 0 # pointer v2

loop1:







