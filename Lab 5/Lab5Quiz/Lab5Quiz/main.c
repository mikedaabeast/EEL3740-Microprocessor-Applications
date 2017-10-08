/*
Lab5Quiz.c
Created: 7/12/2017 5:12:39 PM
*/ 

#include <avr/io.h>
#include "Clk_32MHz.h"
#include "constants.h"
#include "ADC.h"
#include "EBI.h"
#include "EBI_DRIVER.h"

int main(void){
    //Set up program
	Change_CLK_32HZ();
	ADC_INIT();
	EBI_INIT();
	
	uint8_t x = 0;
	uint8_t y;
	
	//Store values at memory location
	while(TRUE){
		ADCA.CH0.CTRL |= PIN7_bm;
		x = ADCA.CH0.RESL;
		__far_mem_write(0x128000, x);
		y = __far_mem_read(0x128000);
	}
}

