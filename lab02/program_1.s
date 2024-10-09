# Nicola Vivarelli
# 336797

.data
v1: 
    .double 1.0, 2.0, 3.0, 4.0, 5.0, 6.0, 7.0, 8.0
    .double 9.0, 10.0, 11.0, 12.0, 13.0, 14.0, 15.0, 16.0
    .double 17.0, 18.0, 19.0, 20.0, 21.0, 22.0, 23.0, 24.0
    .double 25.0, 26.0, 27.0, 28.0, 29.0, 30.0, 31.0, 32.0

v2:
    .double 0.5, 1.5, 2.5, 3.5, 4.5, 5.5, 6.5, 7.5, 8,5
    .double 9.5, 10.5, 11.5, 12.5, 13.5, 14.5, 15.5, 16.5
    .double 17.5, 18.5, 19.5, 20.5, 21.5, 22.5, 23.5, 24.5
    .double 25.5, 26.5, 27.5, 28.5, 29.5, 30.5, 31.5, 32.5

v3: 
    .double 0.1, 1.1, 2.1, 3.1, 4.1, 5.1, 6.1, 7.1, 8.1
    .double 9.1, 10.1, 11.1, 12.1, 13.1, 14.1, 15.1, 16.1
    .double 17.1, 18.1, 19.1, 20.1, 21.1, 22.1, 23.1, 24.1
    .double 25.1, 26.1, 27.1, 28.1, 29.1, 30.1, 31.1, 32.1

v4: .space 32 * 8           # space for 32 double-precision values
v5: .space 32 * 8           # space for 32 double-precision values
v6: .space 32 * 8           # space for 32 double-precision values

.text
main:
    dadd r1, r0, r0         # array pointer = 0
    daddui r2, r0, 32       # loop counter = 32

    # loop 32 times
    loop:
    daddui r2, r2, -1       # decrement loop counter

    l.d f1, v1(r1)          # load v1[0] into f1
    l.d f2, v2(r1)          # load v2[0] into f2
    l.d f3, v3(r1)          # load v3[0] into f3

    mul.d f4, f1, f1        # f4 = f1 * f1 (v1[i] * v1[i])
    sub.d f5, f4, f2        # f8 = f7 - f2 (v1[i] * v1[i] - v2[i])
    s.d f5, v4(r1)          # stores f5 in v4[0] 

    div.d f6, f5, f3        # f6 = f5 / f3 (v4[i] / v3[i])
    sub.d f7, f6, f2        # f7 = f6 - f2 (v4[i] / v3[i] - v2[i])
    s.d f7, v5(r1)          # stores f7 in v5[0]

    sub.d f8, f5, f1        # f8 = f5 - f1 (v4[i] - v1[i])
    mul.d f9, f8, f7        # f9 = f8 * f7 ((v4[i] - v1[i]) * v5[i])
    s.d f9, v6(r1)          # stores f9 in v6[0]

    daddui r1, r1, 8        # increment array pointer
    bnez r2, loop           # loop if counter != 0

#After the bnez function, if no branches are made, the program goes to the end label, exiting
end:
    halt
