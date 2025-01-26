				
				
				AREA asm_functions, CODE, READONLY				
                EXPORT  ASM_funct
ASM_funct
				; save current SP for a faster access 
				; to parameters in the stack
				MOV   r12, sp
				; save volatile registers
				STMFD sp!,{r4-r11,lr}				
				
				;r0 vett 32 bit signed -> 4 offset
				;r1 dimensione vett
				;r3 vettore
			
				
				MOV R4, #0 ;pointer
				MOV r5, #0 ;somma
				mov r6, #0 ;media
				mov r8, #0 ;num sostituzioni
				MOV r9, #1 
				MOV r10, #-1
loop_1
				LDR r7, [r0, r4];carico elemento
				ADD r5, r5, r7
				
				ADD R4, R4, #4
				SUBS R1, R1, #1
				BNE loop_1
				
				LSR R4, R4, #2 ; / 4 così ho size array e non spreco un registro
				UDIV R6, R5, R4 
				MOV R5, #0 ; nuovo offset
loop_2
				LDR R7, [r0, r5];carico elemento array
				CMP r7, r6 ;confronto con media
				STRGT r9, [r3, r5]
				STRLE r10, [r3, r5]
				STREQ r7, [r3, r5]
				ADDNE r8, r8, #1 ;uso ne per ottimizzare, se non è uguale per forza ho cambiato
				
				ADD r5, r5, #4
				SUBS R4, R4, #1
				BNE loop_2
				
				MOV r0, r8
				
				; restore volatile registers
				LDMFD sp!,{r4-r11,pc}
				
		
                END