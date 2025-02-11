
				AREA asm_functions, CODE, READONLY				
                EXPORT  ASM_funct
ASM_funct
				; save current SP for a faster access 
				; to parameters in the stack
				;POP{r4}
				
				
				MOV   r12, sp
				; save volatile registers
				STMFD sp!,{r4-r11,lr}


				;r0  array
				;r1 size
first
				SUB r4, r1, #1
				SUB r8, r1, #1
				
next
				MOV r7, r4
				MOV r5, #0 ;i
				MOV r6, #4 ; i+1
				MOV r11, #1 ;flag for early exit
loop
				LDR r9,[r0, r5]
				LDR r10, [r0, r6]
				CMP r9,r10
				STRGT r9, [r0, r6]
				STRGT r10, [r0, r5]
				MOVGT r11, #0 ;if no changes turn to 0
				
				ADD r5, r5, #4
				ADD r6, r6, #4
				SUBS r7, r7, #1
				bne loop
				
				CMP R11, #1
				BEQ end0
				SUB r4, r4, #1
				SUBS r8, r8, #1
				bne next

end0
				
				; restore volatile registers
				LDMFD sp!,{r4-r11,pc}
				
                END
					
