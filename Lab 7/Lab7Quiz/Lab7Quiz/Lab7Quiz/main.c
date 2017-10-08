/*


Lab7Quiz.c
Created: 7/31/2017 9:34:35 PM
*/ 

#include <avr/io.h>
#include <avr/interrupt.h>
#include "constants.h"
#include "Clk_32MHz.h"
#include "DAC.h"
#include "TIMER_COUNTER.h"
#include "DMA.h"
#include "ADC.h"

int main(void){
    //Set up program
	Change_CLK_32HZ();
	DAC_INIT();
	ADC_INIT();
	COUNTER_INIT();
	//UPDATE_PER(2);//Change to 100Hz
	DMA_INIT('d');
	COUNTER_START();
	
	//enable interrupts.
	PMIC_CTRL = 0x07;
	sei();
	
	
	while(TRUE);
	
}

