				
				
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

                ;FUNZIONE CHE CONTROLLA IL MASSIMO E IL MINIMO DI UN ARRAY E SOSTITUISCE I VALORI CON 1 E 0 RISPETTIVAMENTE 
		
				MOV r4, #0
				LDR r7, [r0, r4];carico primo valore array
				MOV r8, r1 ;salvo lunghezza array
				MOV r9, #0 ;inizializzo numero sostituzioni
				
				MOV R5, r7 ; inizializzo max con primo valore array
				MOV r6, r7 ; inizializzo min con primo valore array
				
				MOV r10, #0
				MOV r11, #1
				
				ADD r4, r4, #4 ; pointer increment

loop_1
				LDR r7, [r0, r4] ;carico elemento
				CMP r5, r7 ;confronto
				MOVGT r5, r7
				CMP r6, r7
				MOVLE r6, r7
				ADD r4, r4, #4
				SUBS r1, r1, #1
				BNE loop_1
				
				MOV r4, #0
loop_2
				LDR r7, [r0, r4] ;carico elemento
				CMP r7, r5
				STREQ r11, [r0, r4] ;metto 1 in r0 pos r4
				ADDEQ r9, r9, #1
				CMP r7, r6
				STREQ r10, [r0, r4]
				ADDEQ r9, r9, #1
				ADDS r4, r4, #4
				SUBS r8, r8, #1
				BNE loop_2
				
				MOV r0, r9
				; restore volatile registers
				LDMFD sp!,{r4-r11,pc}
				
		
                END