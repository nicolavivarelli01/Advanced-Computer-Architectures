#include "button.h"
#include "LPC17xx.h"

#include "../led/led.h" 	
#include "../RIT//RIT.h"		  			/* you now need RIT library 			 */

extern int bdown0;
extern int bdown1;
extern int bdown2;


void EINT0_IRQHandler (void)	  	/* INT0														 */
{		
	bdown0 = 1;
	NVIC_DisableIRQ(EINT0_IRQn);		/* disable Button interrupts			 */
	LPC_PINCON->PINSEL4    &= ~(1 << 20);     /* GPIO pin selection */
	LPC_SC->EXTINT &= (1 << 0);     /* clear pending interrupt         */
}


void EINT1_IRQHandler (void)	  	/* KEY1														 */
{
	bdown1 = 1;
	NVIC_DisableIRQ(EINT1_IRQn);		/* disable Button interrupts			 */
	LPC_PINCON->PINSEL4    &= ~(1 << 22);     /* GPIO pin selection */
	
	LPC_SC->EXTINT &= (1 << 1);     /* clear pending interrupt         */
}

void EINT2_IRQHandler (void)	  	/* KEY2														 */
{
	bdown2 = 1;
	NVIC_DisableIRQ(EINT2_IRQn);		/* disable Button interrupts			 */	
	LPC_PINCON->PINSEL4    &= ~(1 << 24);     /* GPIO pin selection */
  LPC_SC->EXTINT &= (1 << 2);     /* clear pending interrupt         */    
}
