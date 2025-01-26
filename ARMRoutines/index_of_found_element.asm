				
				
				AREA asm_functions, CODE, READONLY				
                EXPORT  ASM_funct
ASM_funct
				; save current SP for a faster access 
				; to parameters in the stack
				MOV   r12, sp
				; save volatile registers
				STMFD sp!,{r4-r11,lr}				
				
				;r0 vett 32 bit signed
				;r1 dimensione vett
				;r2 costante intera
				
				
				; FUNZIONE CHE CONTROLLA SE UN ELEMENTO E' UGUALE A UNA COSTANTE
				; SE LO TROVA RITORNA L'INDICE
				; SE NON LO TROVA RITORNA -1
				
				mov r4, #0 ;pointer array

loop			
				LDR r5, [r0, r4]
				CMP r5, r2
				BEQ return_index
				ADD r4, r4, #4 ;pointer array ++
				SUBS r1, r1, #1 ;i --
				BNE loop
				MOV r0, #-1
				b end0
return_index
				LSR r4, r4 #2 ;divido per 4 perchè passo dai bytes all'indice effettivo
				mov r0, r4
				
end0
				; restore volatile registers
				LDMFD sp!,{r4-r11,pc}
				
                END