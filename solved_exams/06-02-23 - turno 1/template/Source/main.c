#include <stdio.h>
#include "LPC17xx.h"                    /* LPC17xx definitions                */
#include "led/led.h"
#include "button_EXINT/button.h"
#include "timer/timer.h"
#include "RIT/RIT.h"
#include "joystick/joystick.h"


#ifdef SIMULATOR
extern uint8_t ScaleFlag; // <- ScaleFlag needs to visible in order for the emulator to find the symbol (can be placed also inside system_LPC17xx.h but since it is RO, it needs more work)
#endif
/*----------------------------------------------------------------------------
  Main Program
	VIVARELLI NICOLA MAT. S336797
	
	SRI bit timer
	
	Formula Tempo = s * 25*10^6

							n	   pre	  MR    SRI			tempo
	init_timer (1,    0,    0,     7,    0x17D7840) ;  
	
	PCLK = 100 MHZ -> 100 * 10 ^6 HZ
	Standard clock for each timer -> Pclk = CCLK / 4
	
	Tempo di un timer = 1/ Hz richiesti * cclk timer
	periodo di 100 Hz, ed alimentato da un clock di 50 MHz -> tempo = 1/100 * 50*10^6

 *----------------------------------------------------------------------------*/
int main (void) {
  	
	SystemInit();  												/* System Initialization (i.e., PLL)  */
  LED_init();                           /* LED Initialization                 */
  BUTTON_init();												/* BUTTON Initialization              */
	joystick_init();											/* Joystick Initialization            */
	init_RIT(0x004C4B40);									/* RIT Initialization 50 msec       	*/
	enable_RIT();													/* RIT enabled												*/
	LPC_SC -> PCONP |= (1 << 22); 				/* Enable timer 2                     */ 
	LPC_SC -> PCONP |= (1 << 23); 				/* Enable timer 3                     */
	
	init_timer(2, 0, 0, 2, 0xFD51DA80); //timer 2 no interrupt cyclical every 2 min 50 secs
	enable_timer(2);
	
	init_timer(0,0,0,1, 0xBEBC20/2);
	init_timer(0,0,1,3, 0xBEBC20);
	
	init_timer(1,0,0, 1, 0x7F2815/2); // 1/3 * 25*10^6
	init_timer(1,0,1, 3, 0x7F2815); // 1/3 * 25*10^6
	
	
	azzera(); //azzero il vettore
	
	
	
	//LPC_SC->PCON |= 0x1;									/* power-down	mode										*/
	//LPC_SC->PCON &= ~(0x2);						
		
  while (1) {                           /* Loop forever                       */	
		__ASM("wfi");
  }

}
