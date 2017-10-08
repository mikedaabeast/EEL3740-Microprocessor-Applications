/*Lab 7 Part B
Name: Michael Arboleda
Section #: 7F34
TA Name: Wesley Piard
Description: Output SINE using DAC

Lab7B.c
Created: 7/25/2017 2:08:59 AM
*/ 

#include <avr/io.h>
#include <avr/interrupt.h>
#include "constants.h"
#include "Clk_32MHz.h"
#include "DAC.h"
#include "TIMER_COUNTER.h"

int main(void){
	//Set up program
	Change_CLK_32HZ();
	DAC_INIT();
	COUNTER_INIT();
	COUNTER_START();
    
	//enable interrupts.
	PMIC_CTRL = 0x07;
    sei();
	
	//Run forever
    while(TRUE);
	
	//Return is 0 status
	return 0;
}