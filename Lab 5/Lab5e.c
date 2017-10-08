/*Lab 5 Part E
Name: Michael Arboleda
Section #: 7F34
TA Name: Wesley Piard
Description: EBI, and ADC


Lab5e.c
Created: 7/11/2017 10:48:13 AM
*/ 

#include <avr/io.h>
#include <avr/interrupt.h>
#include "Clk_32MHz.h"
#include "constants.h"
#include "ADC.h"
#include "USART.h"
#include "ATXMEGA_DISPLAY.h"
#include "TIMER_COUNTER.h"
#include "EBI.h"

//Prototype
void display_menu(void);

int main(void){
	//Set up program
	Change_CLK_32HZ();
	USART_INIT();
	ADC_INIT();
	COUNTER_INIT();
	EBI_INIT();
	
	//Display Menu
	display_menu();

	//Set up variables
	char c_in;
	char c[15];
	volatile uint8_t x;
	volatile uint8_t *ptr1 = 0x8000;
	
	//TURN ON LED
	PORTD_DIRSET = (PIN4_bm | PIN6_bm);
	PORTD_OUTSET =  0x50;
	
	//Set up interrupts
	uint8_t PMIC_crtl_lvl_config = 0b00000111;
	PMIC_CTRL = PMIC_crtl_lvl_config;
	sei();
	
	
	
	while(TRUE){
		//Take user input
		c_in = IN_CHAR();	
		
		//Switch on choice
		switch(c_in){
			//IF a
			case 'a':
			case 'A':
				//Start conversion on CdS Cell
				ADCA.CH0.CTRL |= PIN7_bm;
				x = ADCA.CH0.RESL;
				
				//Display on terminal
				volt_string(c,x);
				OUT_STRING(c);
				break;
			//IF b
			case 'b':
			case 'B':
				//Start conversion on PINs for ch1
				ADCA.CH1.CTRL |= PIN7_bm;
				x = ADCA.CH1.RESL;
				
				//Display on terminal
				volt_string(c,x);
				OUT_STRING(c);
				
				break;	
			//If c
			case 'c':
			case 'C':
				//Start counter
				COUNTER_START();
				break;
			//IF d
			case 'd':
			case 'D':
				//Stop counter
				COUNTER_STOP();
				break;
			//IF e
			case 'e':
			case 'E':
				//Get CdS ande store in SRAM
				ADCA.CH0.CTRL |= PIN7_bm;
				x = ADCA.CH0.RESL;
				*ptr1 = x;
				break;
			case 'f':
			case 'F':
				//Take SRAM vulue
				x = *ptr1;
				
				//Display on terminal
				volt_string(c,x);
				OUT_STRING(c);
				break;
		}
	}
	return 0;
}

void display_menu(void){
	uint8_t menu_size = 6;
	
	//Menu String
	char *menuA = "A/a: Start/Display conversion on CdS Cell\r\n";
	char *menuB = "B/b: Start/Display conversion on DAD/NAD channel\r\n";
	char *menuC = "C/c: 1 second timer CdS\r\n";
	char *menuD = "D/d: Turn off timer\r\n";
	char *menuE = "E/e: Store CdS in SRAM\r\n";
	char *menuF = "F/f: Read/Display SRAM data\r\n";	
	
	//Set up array of menu strings
	char *menu[] = {menuA, menuB, menuC, menuD, menuE, menuF};
	
	//Loop thru menu array to display
	for(uint8_t i = 0; i < menu_size; i++){
		OUT_STRING(menu[i]);
	}
	
	//return
	return;
}