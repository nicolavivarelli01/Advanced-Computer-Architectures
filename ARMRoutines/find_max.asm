				
				
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


				;FUNZIONE ASM CHE PERMETTE DI TROVARE ELEMENTO MAGGIORE IN UN VETTORE
				
				 
				mov r4, #0 ;pointer array
				LDR r5, [r0, r4]
				mov r6, r5 ;max = r5[0]
				ADD r4, r4, #4
				
loop			
				LDR r5, [r0, r4] ;carico elemento
				CMP r5, r6 ; compare con max
				MOVGT r6, r5 ; if greater allora r6 diventa nuovo max
				
				
				ADD r4, r4, #4 ;pointer array ++
				SUBS r1, r1, #1 ;i --
				BNE loop
			
				
				MOV r0, r6 ;returno max
				; restore volatile registers
				LDMFD sp!,{r4-r11,pc}
				
                END