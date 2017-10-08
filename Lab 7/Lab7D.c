/*Lab 7 Part D
Name: Michael Arboleda
Section #: 7F34
TA Name: Wesley Piard
Description: Advance Waveform Generation

Lab7D.c
Created: 7/26/2017 2:57:37 AM
*/ 

#include <avr/io.h>
#include <avr/interrupt.h>
#include "constants.h"
#include "Clk_32MHz.h"
#include "DAC.h"
#include "TIMER_COUNTER.h"
#include "DMA.h"
#include "USART.h"


//Function Prototypes
void DISPLAY_MENU(void);

int main(void){
	//Set up program
	Change_CLK_32HZ();
	DAC_INIT();
	DMA_INIT('s');
	COUNTER_INIT();
	COUNTER_START();
	USART_INIT();	
	
	//enable interrupts.
	PMIC_CTRL = 0x07;
	sei();
	
	//Set up vars
	char choice;
	
	//Run forever
	while(TRUE){
		//Display Menu, User input
		DISPLAY_MENU();
		choice = IN_CHAR();
		OUT_STRING("USER CHOICE: ");
		OUT_CHAR(choice);
		OUT_STRING("\r\n");
		
		//Output based on choice
		switch(choice){
			case 'S':
			case 's':
				DMA_CHANGE('s');
				break;
			case 'T':
			case 't':
				DMA_CHANGE('t');
				break;
			case '0':
				//Turn off TCC0, Output 0
				COUNTER_STOP();
				TCC0.PER = 0;
				DACA.CH0DATA = 0;	
				break;
			case '1':
				UPDATE_PER(1);
				break;
			case '2':
				UPDATE_PER(2);
				break;
			case '3':
				UPDATE_PER(3);
				break;
			case '4':
				UPDATE_PER(4);
				break;
			case '5':
				UPDATE_PER(5);
				break;
			case '6':
				UPDATE_PER(6);
				break;
			case '7':
				UPDATE_PER(7);
				break;
			case '8':
				UPDATE_PER(8);
				break;
			case '9':
				UPDATE_PER(9);
				break;
		}
		//Restart counter from when 0
		if(choice >= '1' && choice <= '9'){
				COUNTER_START();
		}
	}
	
	//Return is 0 status
	return 0;
}



void DISPLAY_MENU(void){
	uint8_t menu_size = 12;
	
	//Menu String
	char *menuS = "S/s: Output a sinusoid\r\n";
	char *menuT = "T/t: Output a triangle wave\r\n";
	char *menu0 = "0: Make the output waveform:0 Hz and 0 V\r\n";
	char *menu1 = "1: Make the output waveform:50Hz (1 x 50 Hz)\r\n";
	char *menu2 = "2: Make the output waveform:100Hz (2 x 50 Hz)\r\n";
	char *menu3 = "3: Make the output waveform:150Hz (3 x 50 Hz)\r\n";
	char *menu4 = "4: Make the output waveform:100Hz (4 x 50 Hz)\r\n";
	char *menu5 = "5: Make the output waveform:250Hz (5 x 50 Hz)\r\n";
	char *menu6 = "6: Make the output waveform:300Hz (6 x 50 Hz)\r\n";
	char *menu7 = "7: Make the output waveform:350Hz (7 x 50 Hz)\r\n";
	char *menu8 = "8: Make the output waveform:400Hz (8 x 50 Hz)\r\n";
	char *menu9 = "9: Make the output waveform:450Hz (9 x 50 Hz)\r\n";
	
	//Set up array of menu strings
	char *menu[] = {menuS, menuT, menu0, menu1, menu2, menu3, menu4, 
		menu5, menu6, menu7, menu8, menu9};
	
	//Loop thru menu array to display
	for(uint8_t i = 0; i < menu_size; i++){
		OUT_STRING(menu[i]);
	}
	
	//return
	return;
}