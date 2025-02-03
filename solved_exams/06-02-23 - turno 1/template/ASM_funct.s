				AREA asm_functions, CODE, READONLY				
                EXPORT  ASM_funct
ASM_funct
				; save current SP for a faster access 
				; to parameters in the stack
				;POP{r4}
				
				
				
				MOV   r12, sp
				; save volatile registers
				STMFD sp!,{r4-r11,lr}

				;r0 vett
				;r1 size
				;r2 over
				
				
				MOV r4, #0 ;sum positivi
				MOV r5, #0 ;sum negativi
				MOV r6, r1 ; size in r6
				MOV r7, #0 ; offset
				MOV r9, #0 ; num pos
				MOV r10, #0 ;num neg
				
loop
				LDR r8, [r0, r7] ;carico
				CMP r8, #0
				ADDGE r4, r8, r4 ; sum positive
				ADDGE r9, r9, #1 ;num positive
				ADDLT r5, r8, r5 ; sum negative
				ADDLT r10, r10, #1 ; num negative

				ADD r7, r7, #4
				SUBS r6, r6, #1
				bne loop
				
				
				
				UDIV r8, r4, r9 ;media pos
				UDIV r9, r5, r10 ;media neg
				SUBS r11, r8, r9 ;diff pos neg
				MOVVS r4, #0xFF
				STRVS r4, [r2]
				
				MOV r0, r11
				; restore volatile registers
				LDMFD sp!,{r4-r11,pc}
				
                END