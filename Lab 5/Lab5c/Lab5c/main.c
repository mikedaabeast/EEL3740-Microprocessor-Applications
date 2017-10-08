/*
Lab 5 Part C
Name: Michael Arboleda
Section #: 7F34
TA Name: Wesley Piard
Description: Voltmeter

Lab5c.c
Created: 7/10/2017 4:44:33 AM
 */ 

#include <avr/io.h>
#include "Clk_32MHz.h"
#include "USART.h"
#include "constants.h"
#include "ADC.h"
#include "ATXMEGA_DISPLAY.h"

int main(void){
	
	Change_CLK_32HZ();
	USART_INIT();
	ADC_INIT();
	
	char c[15];
	uint8_t x;	
	while(TRUE){
		ADCA.CH0.CTRL |= PIN7_bm;
		x = ADCA.CH0.RESL;
		volt_string(c,x);
		OUT_STRING(c);
	}
}