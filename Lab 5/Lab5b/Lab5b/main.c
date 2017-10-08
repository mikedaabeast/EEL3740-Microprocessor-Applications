/*
Lab 5 Part B
Name: Michael Arboleda
Section #: 7F34
TA Name: Wesley Piard
Description:

Lab5b.c 
Created: 7/10/2017 4:16:07 AM
 */ 

#include <avr/io.h>
#include "Clk_32MHz.h"
#include "constants.h"
#include "ADC.h"

int main(void){
    
	Change_CLK_32HZ();
	ADC_INIT();
	
	uint8_t x;
	
	
	while(TRUE){
		ADCA.CH0.CTRL |= PIN7_bm;
		x = ADCA.CH0.RESL;	
	}
}