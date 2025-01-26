				
				
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
				
				; FUNZIONE CHE TROVA IL MAX E IL MIN DI UN VETTORE
				; POPOLA UN SECONDO VETTORE CON TUTTI GLI ELEMENTI NORMALIZZATI
				; SUCCESSIVAMENTE SOMMA LA NORMA DI TUTTI GLI ELEMENTI DEL VETTORE NORMALIZZATO
				; E LA RESTITUISCE AL CHIAMANTE
				
				CMP r1, #2
				BLT end0
				
				mov r4, #0 ;offset
				ldr r5, [r0, r4] ;carico elemento array
				mov r6, r5 ;max
				mov r7, r5 ;min
				add r4, r4, #1
loop			
				ldr r5, [r0, r4]
				cmp r5, r6
				MOVGT r6, r5
				CMP r7, r5
				MOVLT r7, r5 
				
				
				add r4, r4, #4
				subs r1,r1, #1
				bne loop
				
				CMP R6,R7
				BEQ end0 ;se sono uguali salto perchè non posso dividere per 0
				
				LSR r4, r4, #2 ;size
				MOV R5, #0; offset nuovo
				MOV R9, #0
				SUBS R10, r6, r7 ; max - min lo faccio qui per avere meno operazioni
				MOV R11, #100
				MOV R12, #0
loop_2
				LDR R8, [r0, r5] ;carico primo elemento array
				SUBS R9, r8, r7; elemento[i] - min
				UDIV R9, r9, r10 ; / max - min
				MUL R9, R9, r11 ;tutto * 100
				STR R9, [r3, r5]
				ADD r12, r12, r9
				
				ADD r5, r5, #4
				SUBS r4, r4, #1
				bne loop_2
				
				MOV r0, r12

				
end0				

				; restore volatile registers
				LDMFD sp!,{r4-r11,pc}
				
		
                END