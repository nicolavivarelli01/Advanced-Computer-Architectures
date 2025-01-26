				
				
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
				
				MOV r4, #0 ;pointer array
				mov r5, #0 ; inizializzo count negativi
				
loop			
				LDR r6, [r0, r4]
				CMP r6, #0
				ADDLT r5, r5, #1
				

				ADD r4, r4, #4
				SUBS r1, r1, #1
				BNE loop
				
				
				MOV r0, r5
				; restore volatile registers
				LDMFD sp!,{r4-r11,pc}
				
		
                END