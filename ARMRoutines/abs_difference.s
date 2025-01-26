				
				
				AREA asm_functions, CODE, READONLY				
                EXPORT  analisi_accuratezza
analisi_accuratezza
				; save current SP for a faster access 
				; to parameters in the stack
				MOV   r12, sp
				; save volatile registers
				STMFD sp!,{r4-r8,r10-r11,lr}
				
				;r0 vett1 8bit
				;r1 vett2 8bit
				;r2 size
				;r3 res
				
				MOV r4, #0 ;offset
				MOV r5, r2
loop
				LDRB r6, [r0, r4] ; carico vett 1
				LDRB r7, [r1, r4] ; carico vett2
				SUB r7, r7, r6 ;calcolo differenza 
				CMP  r7, #0; confronta con 0
				RSBMI r7, r7, #0 ;controllo flag 0 e se negativo faccio r7 = 0-r7
				
				STRB r7, [r3, r4] ;salvo in res
				

				ADD r4, r4, #1 ;8 bit 1 offset
				SUBS r5, r5, #1
			
				
				BNE loop
				
				MOV R5, #0 ; nuovo offset
				MOV r7, #0 ; sum = 0
loop2
				LDRB r6, [r3, r5]
				ADD r7, r7, r6 ; sum += res[i]
				
				ADD r5, r5, #1
				SUBS r4, r4, #1
				BNE loop2
				
				UDIV R8, R7, R5 ;media = sum / size
				
				MOV r0, r8 ; return media
				
				; restore volatile registers
				LDMFD sp!,{r4-r8,r10-r11,pc}
				
                END
