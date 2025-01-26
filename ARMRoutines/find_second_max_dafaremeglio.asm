				
				
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

				;FUNZIONE CHE TROVA IL SECONDO MASSIMO IN UN ARRAY 
                ;CONTA LE OCCORRENZE E LE RETURNA
				
				
				MOV R4, #0 ;offset
				LDR r6, [r0, r4]
				MOV r5, r6 ;max
				ADD r4, r4, #4
				MOV R8, r6; #min
				
loop1
				LDR R6, [r0, r4]
				CMP r6, r5
				MOVGT R5, R6
				CMP r6, R8
				MOVLE R8, R6
					
				ADD r4, r4, #4	
				SUBS r1, r1, #1
				BNE loop1

				LSR r4, r4, #2
				MOV r7, #0 ;offset nuovo
				
remove_max
				LDR r6, [r0, r7]
				CMP r6, r5
				STREQ R8, [R0, R7]
				
				ADD R7, R7, #4
				SUBS r4, r4, #1
				BNE remove_max
				
				LSR r7, r7, #2
				MOV R4, #0 ; offset nuovo
				LDR r6, [r0, r4] 
				MOV r5, r6 ; max nuovo
				ADD r4, r4, #4
				
find_second_max
				LDR r6, [r0, r4]
				CMP r6, r5
				MOVGT r5, r6
				
				add r4, r4, #4
				subs R7, R7, #1
				BNE find_second_max
				
				LSR r4, r4, #2
				MOV r7, #0 ;offset nuovo
				MOV R9, #0 ;occorrenze
count_times
				LDR r6, [r0, r7]
				CMP r6, r5
				ADDEQ R9, R9, #1
				
				
				ADD r7, r7, #4
				SUBS r4, r4, #1
				BNE count_times
				
				MOV r0, r9
				; restore volatile registers
				LDMFD sp!,{r4-r11,pc}
				
		
                END