                AREA    asm_functions, CODE, READONLY
                EXPORT  ASM_funct

ASM_funct
                ; -----------------------------------------------------------------------------
                ; Salvataggio del contesto
                MOV     r12, sp
                STMFD   sp!, {r4-r11, lr}

                ; -----------------------------------------------------------------------------
                ; Parametri:
                ; r0 = indirizzo di base dell'array
                ; r1 = numero di elementi (n)
                ; Li copiamo in registri di lavoro:
                MOV     r4, r0                ; r4 = base dell'array
                MOV     r5, r1                ; r5 = dimensione n

                ; L'idea è di usare r5 come contatore che parte da n
                ; e decrementarne il valore ad ogni passata (outer loop).
                ; Ad ogni giro, la porzione finale dell’array è già ordinata.

outer_loop
                ; -- i = r5 - 1 (equivalente a "se i scende a 0, ferma")
                SUBS    r5, r5, #1            ; r5 = r5 - 1, imposta le flag
                BLE     fine                  ; se r5 <= 0, esci

                ; j = 0
                MOV     r6, #0

inner_loop
                ; Controlliamo se j >= r5; in tal caso finiamo l'inner loop e torniamo all'outer
                CMP     r6, r5
                BGE     outer_loop

                ; Calcolo indirizzo di array[j]
                ; (ogni elemento è 4 byte, quindi offset = j * 4)
                ADD     r10, r4, r6, LSL #2

                ; Carichiamo array[j] in r0 e array[j+1] in r1
                LDR     r0, [r10]
                LDR     r1, [r10, #4]

                ; Se array[j] > array[j+1], scambiamo i due valori
                CMP     r0, r1
                STRGT   r1, [r10]             ; STR se (r0 > r1)
                STRGT   r0, [r10, #4]

                ; j++
                ADD     r6, r6, #1
                B       inner_loop

fine
                ; -----------------------------------------------------------------------------
                ; Ripristino del contesto e ritorno
                LDMFD   sp!, {r4-r11, pc}
                END
