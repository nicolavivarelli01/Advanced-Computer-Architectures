				
				
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
				;r2 costante
				
				;funzione che conta numeri maggiori di una costante in input
				; cambia anche i valori dell array maggiori di quella costante
				; con il valore in input
			
				MOV r4, #0 ;pointer array
				MOV r5, #0 ;inizializzo n soluzioni
				
loop			
				LDR R6, [r0, r4];carico elemento
				CMP r6, r2
				ADDGT r5, r5, #1
				STRGT r2, [r0, r4] ;salvo r2 in r0 pos r4
				
				ADD r4, r4, #4
				SUBS r1, r1, #1
				BNE loop
				
				MOV r0, r5
				
				; restore volatile registers
				LDMFD sp!,{r4-r11,pc}
				
		
                END