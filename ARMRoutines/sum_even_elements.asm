				
				
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


				;FUNZIONE ASM che somma tutti gli elementi pari di un vettore
				; se un numero è pari il suo bit meno significativo è 0: 111100110 -> even || 111011101 -> odd
				
				; controllo che ci si almeno un elemento (n > 1)
				CMP r1, #1
				BLT end0
				
				MOV r4, #0 ; pointer array
				MOV r5, #0 ; inizializzo somma
				
loop
				LDR r6, [r0, r4] ; carico elemento array
				ANDS r7, r6, #1  ;and logico r6 con 1 e aggiorno i flag salvo risultato in r7
				ADDEQ R5, R5, R6 ;sommo elemento array a somma perchè pari
				
				ADD r4, r4, #4
				SUBS r1, r1, #1
				BNE loop

end0

				MOV R0, R5
				
				; restore volatile registers
				LDMFD sp!,{r4-r11,pc}
				
		
                END