# Nicola Vivarelli
# 336797

.data
v1: .double 1.0, 2.0, 3.0, 4.0, 5.0, 6.0, 7.0, 8.0
    .double 9.0, 10.0, 11.0, 12.0, 13.0, 14.0, 15.0, 16.0
    .double 17.0, 18.0, 19.0, 20.0, 21.0, 22.0, 23.0, 24.0
    .double 25.0, 26.0, 27.0, 28.0, 29.0, 30.0, 31.0, 32.0
 
v2: .double 0.5, 1.5, 2.5, 3.5, 4.5, 5.5, 6.5, 7.5, 8,5
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

.text
main:
    daddui r1, r0, 32           # Initialize counter k to 32 (number of elements to process)
    daddui r2, r0, 256          # Initialize pointer i to point to the start of the arrays (256 bytes offset)
    daddui r3, r0, 3            # Constant value 3 for division and comparison
    l.d f0, b1(r0)              # Load scalar value b1 into floating-point register f0

unrolled_loop:
    daddui r1, r1, -3           # Decrement counter k by 3 for unrolled loop
    slt r7, r1, r0              # Check if counter k is less than 0
    bnez r7, end                # If counter k is less than 0, branch to end of loop

    lw r4, m(r0)                # Load value of m into register r4
    l.d f1, v1(r2)              # Load value of v1[i] into floating-point register f1
    l.d f2, v2(r2)              # Load value of v2[i] into floating-point register f2
    l.d f3, v3(r2)              # Load value of v3[i] into floating-point register f3
    ddiv r5, r2, r3             # Divide i by 3 and store the result in r5
    dsllv r5, r4, r2            # Shift left value of m by i bits and store in r5
    dmul r6, r5, r3             # Multiply (i / 3) by 3 and store in r6
    bne r6, r2, else_1          # If i is not a multiple of 3, branch to else_1
    mtc1 r5, f4                 # Move value of (m << i) to floating-point register f4

mult3_1:
    cvt.d.l f4, f4              # Convert integer value in f4 to double-precision
    div.d f5, f1, f4            # Divide v1[i] by (m << i) and store in f5
    s.d f5, a(r0)               # Store result in scalar a
    j calc_1                    # Jump to calc_1 to continue calculations

else_1:
    dmul r5, r4, r2             # Multiply m by i and store in r5
    cvt.d.l f4, f4              # Convert integer value in f4 to double-precision
    mul.d f5, f1, f4            # Multiply v1[i] by (m * i) and store in f5
    s.d f5, a(r0)               # Store result in scalar a

calc_1:
    mul.d f6, f5, f2            # Multiply a by v2[i] and store in f6
    sub.d f8, f6, f0            # Subtract b1 from (a * v2[i]) and store in f8
    s.d f8, v4(r2)              # Store result in v4[i]
    div.d f9, f8, f3            # Divide v4[i] by v3[i] and store in f9
    sub.d f9, f9, f0            # Subtract b1 from (v4[i] / v3[i]) and store in f9
    s.d f9, v5(r2)              # Store result in v5[i]
    sub.d f6, f8, f1            # Calculate (v4[i] - v1[i]) and store in f6
    mul.d f6, f6, f9            # Multiply (v4[i] - v1[i]) by v5[i] and store in f6
    s.d f6, v6(r2)              # Store result in v6[i]

    daddui r2, r2, -8           # Move pointer i to the next element for the 2nd iteration

    lw r4, m(r0)                # Load value of m into register r4
    l.d f1, v1(r2)              # Load value of v1[i+8] into floating-point register f1
    l.d f2, v2(r2)              # Load value of v2[i+8] into floating-point register f2
    l.d f3, v3(r2)              # Load value of v3[i+8] into floating-point register f3
    ddiv r5, r2, r3             # Divide i by 3 and store the result in r5
    dsllv r5, r4, r2            # Shift left value of m by i bits and store in r5
    dmul r6, r5, r3             # Multiply (i / 3) by 3 and store in r6
    bne r6, r2, else_2          # If i is not a multiple of 3, branch to else_2
    mtc1 r5, f4                 # Move value of (m << i) to floating-point register f4

mult3_2:
    cvt.d.l f4, f4              # Convert integer value in f4 to double-precision
    div.d f5, f1, f4            # Divide v1[i+8] by (m << i) and store in f5
    s.d f5, a(r0)               # Store result in scalar a
    j calc_2                    # Jump to calc_2 to continue calculations

else_2:
    dmul r5, r4, r2             # Multiply m by i and store in r5
    cvt.d.l f4, f4              # Convert integer value in f4 to double-precision
    mul.d f5, f1, f4            # Multiply v1[i+8] by (m * i) and store in f5
    s.d f5, a(r0)               # Store result in scalar a

calc_2:
    mul.d f6, f5, f2            # Multiply a by v2[i+8] and store in f6
    sub.d f8, f6, f0            # Subtract b1 from (a * v2[i+8]) and store in f8
    s.d f8, v4(r2)              # Store result in v4[i+8]
    div.d f9, f8, f3            # Divide v4[i+8] by v3[i+8] and store in f9
    sub.d f9, f9, f0            # Subtract b1 from (v4[i+8] / v3[i+8]) and store in f9
    s.d f9, v5(r2)              # Store result in v5[i+8]
    sub.d f6, f8, f1            # Calculate (v4[i+8] - v1[i+8]) and store in f6
    mul.d f6, f6, f9            # Multiply (v4[i+8] - v1[i+8]) by v5[i+8] and store in f6
    s.d f6, v6(r2)              # Store result in v6[i+8]

    daddui r2, r2, -8           # Move pointer i to the next element for the 3rd iteration

    lw r4, m(r0)                # Load value of m into register r4
    l.d f1, v1(r2)              # Load value of v1[i+16] into floating-point register f1
    l.d f2, v2(r2)              # Load value of v2[i+16] into floating-point register f2
    l.d f3, v3(r2)              # Load value of v3[i+16] into floating-point register f3
    ddiv r5, r2, r3             # Divide i by 3 and store the result in r5
    dsllv r5, r4, r2            # Shift left value of m by i bits and store in r5
    dmul r6, r5, r3             # Multiply (i / 3) by 3 and store in r6
    bne r6, r2, else_3          # If i is not a multiple of 3, branch to else_3
    mtc1 r5, f4                 # Move value of (m << i) to floating-point register f4

mult3_3:
    cvt.d.l f4, f4              # Convert integer value in f4 to double-precision
    div.d f5, f1, f4            # Divide v1[i+16] by (m << i) and store in f5
    s.d f5, a(r0)               # Store result in scalar a
    j calc_3                    # Jump to calc_3 to continue calculations

else_3:
    dmul r5, r4, r2             # Multiply m by i and store in r5
    cvt.d.l f4, f4              # Convert integer value in f4 to double-precision
    mul.d f5, f1, f4            # Multiply v1[i+16] by (m * i) and store in f5
    s.d f5, a(r0)               # Store result in scalar a

calc_3:
    mul.d f6, f5, f2            # Multiply a by v2[i+16] and store in f6
    sub.d f8, f6, f0            # Subtract b1 from (a * v2[i+16]) and store in f8
    s.d f8, v4(r2)              # Store result in v4[i+16]
    div.d f9, f8, f3            # Divide v4[i+16] by v3[i+16] and store in f9
    sub.d f9, f9, f0            # Subtract b1 from (v4[i+16] / v3[i+16]) and store in f9
    s.d f9, v5(r2)              # Store result in v5[i+16]
    sub.d f6, f8, f1            # Calculate (v4[i+16] - v1[i+16]) and store in f6
    mul.d f6, f6, f9            # Multiply (v4[i+16] - v1[i+16]) by v5[i+16] and store in f6
    s.d f6, v6(r2)              # Store result in v6[i+16]

    daddui r2, r2, -8           # Move pointer i to the next element
    j unrolled_loop             # Continue the unrolled loop

end:
    halt                        # End of the program
