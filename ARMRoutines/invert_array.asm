				
				
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


				;FUNZIONE ASM CHE INVERTE UN VETTORE E CHECKA SE HA ALMENO 2 ELEMENTI
				
				; controllo che ci siano almeno due elementi (n > 2)
				MOV r4, #2
				CMP r1, r4
				BLT end0
				
				MOV r4, #0 ;i = 0
				SUB r5, r1, #1 ;j = size-1
				LSL r5 ,r5, #2 ;diventa in bytes * 4
loop
				LDR r6, [r0, r4] ;temp = array[i]
				LDR R7, [r0, r5]; array[j]
				STR r7, [r0, r4] ; salvo r7 in r0 pos r4 || array[i] = array[j]
				STR r6, [r0, r5] ; salvo r6 in r0, pos r5 || array[j] = temp
 				
				
				ADDS r4, r4, #4
				SUBS r5, r5, #4
				CMP r4, r5
				BLT loop

end0
				; restore volatile registers
				LDMFD sp!,{r4-r11,pc}
				
		
                END