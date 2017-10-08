/*Lab 5 Part A

Name: Michael Arboleda
Section #: 7F34
TA Name: Wesley Piard
Description: 

Lab5a.c
Created: 7/7/2017 11:11:20 PM

*/

#include <avr/io.h>
#include "constants.h"
#include "Clk_32MHz.h"
#include "USART.h"
#include "EBI.h"


int main(void){
	
	Change_CLK_32HZ();
	USART_INIT();
	EBI_INIT();
	
	//Set up Pointer at address
	uint8_t *ptr1 = 0x8500;
	uint8_t *ptr2 = 0x8501;
	
	//Store values at mem location
	while(TRUE){
		*ptr1 = 0x37;
		*ptr2 = 0x73;
	}
}