/*Lab 7 Part A
Name: Michael Arboleda
Section #: 7F34
TA Name: Wesley Piard
Description: Output 1.3V using DAC

Lab7A.c
Created: 7/25/2017 12:48:48 AM
*/ 

#include <avr/io.h>
#include "constants.h"
#include "Clk_32MHz.h"
#include "DAC.h"

int main(void){
	//Set up program
	Change_CLK_32HZ();
	DAC_INIT();
	UPDATE_DACA_CH0(2130);
    
	//Run forever
    while(TRUE);
	
	//Return is 0 status
	return 0;
}