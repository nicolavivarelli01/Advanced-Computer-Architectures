				AREA asm_functions, CODE, READONLY				
                EXPORT  avg_vett
avg_vett
				; save current SP for a faster access 
				; to parameters in the stack
				MOV   r12, sp
				; save volatile registers
				STMFD sp!,{r4-r11,lr}				

				;r0 vett
				;r1 size
				;r2 flag address
				
				
				MOV r4, #0 ;offset
				MOV r5, #0 ;somma inizializzata
				mov r6, r1
				
loop
				LDR r7, [r0, r4]
				ADD r5, r5, r7 ;sum += vett[i]
				ADD r4, r4, #4
				SUBS r6,r6, #1
				bne loop
					
				LSR r4, r4, #2
				UDIV r8, r5, r4 ;media
				MOV r6, #0 ;offset nuovo
				MOV r5, #0 ; nuova somma > media
loop_2
				
				LDR R7, [r0, r6]
				CMP r7, r8
				ADDGT r5, r5, #1
				
				ADD r6, r6, #4
				SUBS r4, r4, #1
				bne loop_2
				
				AND r9, r5, #1
				CMP r9, #1
				MOVEQ r9, #0 ;se dispari
				MOVNE r9, #1 ;se pari
				STRB r9, [r2, #0] ; ricorda di passarlo in c come &char e dichiararlo normale
				
				
				; restore volatile registers
				LDMFD sp!,{r4-r11,pc}
				
                END
