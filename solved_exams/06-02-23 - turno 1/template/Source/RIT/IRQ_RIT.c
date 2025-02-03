#include "LPC17xx.h"
#include "RIT.h"
#include "../led/led.h"
#include <stdio.h>

#define JOY_UP     (1 << 29) 
#define JOY_DOWN   (1 << 26)  
#define JOY_LEFT   (1 << 27)  
#define JOY_RIGHT  (1 << 28)  

volatile int bdown0=0;
volatile int bdown1=0;
volatile int bdown2=0;
#define N 4


int pressed = 0;
int VETT[N];
int na = 0;
int n = 0;
unsigned char full = 0;
int differenza_media_positivi_negativi(int *, unsigned int , char* );
int diff = 0;
char over = 0;
void azzera(){

	for(na = 0; na < N; na++){
		VETT[na] = 0;
	}
	na = 0;
}


/*--------------------------------------------------------------
per calcolare i ms di pressione di un pulsante:
 valore in ms / 50ms il risultato va come valore nel case
 
 se mi chiede quando tempo un pulsante è stato premuto:
 b_downn *  50 -> ms
---------------------------------------------------------------*/


void RIT_IRQHandler (void)
{		

/***********************JOYSTICK MANAGEMENT*******************************************************/	
	static int j_north=0;
	static int j_south=0;
	static int j_right=0;
	static int j_left=0;
	static int up_right = 0;
	static int up_left = 0;
	static int down_left = 0;
	static int down_right = 0;
	
/***************************** CON DIAGONALI **********************************************************************/
	/* UP RIGHT */
	if ((LPC_GPIO1->FIOPIN & (1<<29)) == 0 && (LPC_GPIO1->FIOPIN & (1<<28)) == 0) {
			/* Joystick UP RIGHT pressed */
			up_right++;
			switch (up_right) {
					case 1:
			
							break;
					case 60: // 3 secondi = 3000ms / 50ms = 60
							
							break;
					default:
							break;
			}
	} else {
			up_right = 0;
	}

	/* UP LEFT */
	if ((LPC_GPIO1->FIOPIN & (1<<29)) == 0 && (LPC_GPIO1->FIOPIN & (1<<27)) == 0) {
			/* Joystick UP LEFT pressed */
			up_left++;
			switch (up_left) {
					case 1:
							
							break;
					case 60: // 3 secondi = 3000ms / 50ms = 60
							
							break;
					default:
							break;
			}
	} else {
			up_left = 0;
	}

	/* DOWN LEFT */
	if ((LPC_GPIO1->FIOPIN & (1<<26)) == 0 && (LPC_GPIO1->FIOPIN & (1<<27)) == 0) {
			/* Joystick DOWN LEFT pressed */
			down_left++;
			switch (down_left) {
					case 1:
							
							break;
					default:
							break;
			}
	} else {
			down_left = 0;
	}

	/* DOWN RIGHT */
	if ((LPC_GPIO1->FIOPIN & (1<<26)) == 0 && (LPC_GPIO1->FIOPIN & (1<<28)) == 0) {
			/* Joystick DOWN RIGHT pressed */
			down_right++;
			switch (down_right) {
					case 1:
						
							break;
					default:
							break;
			}
	} else {
			down_right = 0;
	}


	
	static int position=0;	
	
	if((LPC_GPIO1->FIOPIN & (1<<29)) == 0){	
		/* Joytick UP pressed */
		j_north++;
		switch(j_north){
			case 1:
					
				break;
			case 20:	//1sec = 1000ms/50ms = 20 formula to calculatete time
				
				break;
			default:
				break;
		}
	}
	else{
			j_north=0;
	}
	
	if((LPC_GPIO1->FIOPIN & (1<<26)) == 0){	
		/* Joytick DOWN pressed */
		j_south++;
		switch(j_south){
			case 1:
				if (n < N){
					VETT[n] = LPC_TIM2->TC; 
					n++;
					if(n == N){
						n = 0;
						full++;
						if(full <= 4){
							LED_Out(full - 1);
						}
						else{
							LED_Out(0);
							enable_timer(0);
						
						}
						
					}
				}	
				
				break;
			//LONG PRESSED FOR 1 SEC  (1sec = 1000ms/50ms = 20) 
			case 20:	
				//code here
				break;
			default:
				break;
		}
	}
	else{
			// JOYSTICK DOWN RELEASED
			j_south = 0;

	}
	
	if((LPC_GPIO1->FIOPIN & (1<<27)) == 0){	
		/* Joytick LEFT pressed */
		j_left++;
		switch(j_left){
			case 1:
				
				break;
			//LONG PRESSED FOR 1 SEC  (1sec = 1000ms/50ms = 20) 
			case 20:	
				//code here
				break;
			default:
				break;
		}
	}
	else{
			// JOYSTICK LEFT RELEASED
			j_left = 0;
			
	}
	
	if((LPC_GPIO1->FIOPIN & (1<<28)) == 0){	
		/* Joytick RIGHT pressed */
		j_right++;
		switch(j_right){
			case 1:
				
				break;
			//LONG PRESSED FOR 1 SEC  (1sec = 1000ms/50ms = 20) 
			case 20:	
				//code here
				break;
			default:
				break;
		}
	}
	else{
			// JOYSTICK RIGHT RELEASED
			j_right = 0;
	}
	

/***********************JOYSTICK MANAGEMENT*******************************************************/	

	
	
/*************************INT0***************************/
if(bdown0 !=0){
	bdown0++;
	if((LPC_GPIO2->FIOPIN & (1<<10)) == 0){
		switch(bdown0){
			case 2:
				if(pressed == 0){
					diff = differenza_media_positivi_negativi(VETT, N, &over);
					disable_timer(0);
					LED_Out(0);
					if(over == 0){
						if(diff > 0){
							LED_Out(0xFF);
						}else{
							LED_On(11-4);
						}
					}
					else{
						enable_timer(1);
					}
					pressed = 1;
				}
				else{
					azzera();
					n = 0;
					full = 0;
					disable_timer(0);
					disable_timer(1);
					disable_timer(2);
					diff = 0;
					LED_Out(0);
					pressed = 0;
				
				}
				break;
			default:
				break;
		}
	}
	else {	/* button released */
		bdown0=0;	
		NVIC_EnableIRQ(EINT0_IRQn);							 /* disable Button interrupts			*/
		LPC_PINCON->PINSEL4    |= (1 << 20);     /* External interrupt 0 pin selection */
	}
} // end INT0

/*************************KEY1***************************/
if(bdown1 !=0){
	bdown1++;
	if((LPC_GPIO2->FIOPIN & (1<<11)) == 0){
		switch(bdown1){
			case 2:
				//code here
				break;
			default:
				break;
		}
	}
	else {	/* button released */
		bdown1=0;			
		NVIC_EnableIRQ(EINT1_IRQn);							 /* disable Button interrupts			*/
		LPC_PINCON->PINSEL4    |= (1 << 22);     /* External interrupt 0 pin selection */
	}
} // end KEY1

/*************************KEY2***************************/
if(bdown2 !=0){
	bdown2++;
	if((LPC_GPIO2->FIOPIN & (1<<12)) == 0){
		switch(bdown2){
			case 2:
				//code here
				break;
			default:
				break;
		}
	}
	else {	/* button released */
		bdown2=0;		
		NVIC_EnableIRQ(EINT2_IRQn);							 /* disable Button interrupts			*/
		LPC_PINCON->PINSEL4    |= (1 << 24);     /* External interrupt 0 pin selection */
	}
} // end KEY2


	
  LPC_RIT->RICTRL |= 0x1;	/* clear interrupt flag */
	
  return;
}

/******************************************************************************
**                            End Of File
******************************************************************************/
