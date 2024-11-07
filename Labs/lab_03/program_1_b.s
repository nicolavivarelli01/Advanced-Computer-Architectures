# Nicola Vivarelli
# 336797

.data
v1: .double 1.0, 2.0, 3.0, 4.0, 5.0, 6.0, 7.0, 8.0
    .double 9.0, 10.0, 11.0, 12.0, 13.0, 14.0, 15.0, 16.0
    .double 17.0, 18.0, 19.0, 20.0, 21.0, 22.0, 23.0, 24.0
    .double 25.0, 26.0, 27.0, 28.0, 29.0, 30.0, 31.0, 32.0

v2: .double 0.5, 1.5, 2.5, 3.5, 4.5, 5.5, 6.5, 7.5, 8.5
    .double 9.5, 10.5, 11.5, 12.5, 13.5, 14.5, 15.5, 16.5
    .double 17.5, 18.5, 19.5, 20.5, 21.5, 22.5, 23.5, 24.5
    .double 25.5, 26.5, 27.5, 28.5, 29.5, 30.5, 31.5, 32.5

v3: .double 0.1, 1.1, 2.1, 3.1, 4.1, 5.1, 6.1, 7.1, 8.1
    .double 9.1, 10.1, 11.1, 12.1, 13.1, 14.1, 15.1, 16.1
    .double 17.1, 18.1, 19.1, 20.1, 21.1, 22.1, 23.1, 24.1
    .double 25.1, 26.1, 27.1, 28.1, 29.1, 30.1, 31.1, 32.1

v4: .space 32 * 8               # space for 32 double-precision values
v5: .space 32 * 8               # space for 32 double-precision values
v6: .space 32 * 8               # space for 32 double-precision values

a: .double 1.5
b1: .double 3.5
m: .word 1                   # m = 1 (int64)

.text
main:

    daddui r2, r0, 32           # array pointer= 32
    daddui r3, r0, 32           # loop counter = 32 (i)
    daddui r1, r0, 3            # r1 = 3

    loop:
        daddui r3, r3, -1       # decrement loop counter
        beqz r3, end            # if loop counter == 0, exit loop

        l.d f1, v1(r1)          # load v1[i] into f1
        l.d f2, v2(r1)          # load v2[i] into f2
        l.d f3, v3(r1)          # load v3[i] into f3

        ddiv r4, r3, r1         # r4 = r3 / 3 (i/3)
        dmul r5, r4, r1         # r5 = r4 * 3 (i/3 * 3)
        beq r5, r3, multiple    # if r5 == r3, branch to multiple

        ld r6, m(r0)            # load m into r6 (64-bit integer)
        j notmul                # else branch to notmul

    # in case of multiple of 3
    multiple:
        ld r6, m(r0)            # load m into r6 (64-bit integer)
        dsllv r7, r6, r3        # i << m
        mtc1 r7, f5             # move r7 into f5 (integer to float)
        cvt.d.l f5, f5          # convert f5 to double (double(i << m))

        div.d f6, f1, f5        # f6 = v1[i] / (i << m)
        s.d f6, a(r0)           # store f6 into a

        cvt.l.d f7, f6          # convert f6 to integer (int64)
        mfc1 r7, f7             # move f7 into r7 (float to integer)
        sd r7, m(r0)            # store r7 into m [(int)m = a]
        j continue

    notmul:
        mtc1 r6, f4             # move r6 to floating-point register f4
        cvt.d.l f4, f4          # convert 64-bit integer in f4 to double-precision float
        mul.d f5, f4, f3        # f5 = f4 * v3[i]
        s.d f5, a(r0)           # store f5 into a

        cvt.l.d f6, f5          # convert double-precision float in f5 to 64-bit integer
        mfc1 r7, f6             # move the integer value from f6 to r7
        sd r7, m(r0)            # store r7 into m [(int)m = a]

    continue:
        mul.d f7, f6, f1        # f7 = f6 * v1[i]
        sub.d f8, f7, f2        # f8 = f7 - v2[i]
        s.d f8, v4(r3)          # store f8 into v4[i]

        div.d f9, f8, f3        # f9 = v4[i] / v3[i]
        l.d f10, b1(r0)         # load b into f10
        sub.d f11, f9, f10      # f11 = f9 - b
        s.d f11, v5(r3)         # store f11 into v5[i]

        sub.d f12, f8, f1       # f12 = v4[i] - v1[i]
        mul.d f13, f12, f11     # f13 = f12 * f11
        s.d f13, v6(r3)         # store f13 into v6[i]

        daddui r2, r2, -8       # r2 = r2 - 8 (array pointer)
        bnez r3, loop           # if loop counter != 0, loop

    end:
        halt
