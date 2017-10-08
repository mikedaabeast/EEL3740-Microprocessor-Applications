/*Lab 5 Part D


Lab5d.c
Created: 7/12/2017 2:46:07 AM
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
		ADCA.CH1.CTRL |= PIN7_bm;
		x = ADCA.CH1.RESL;
		volt_string(c,x);
		OUT_STRING(c);
	}
}