/*Lab 6 Part B
Name: Michael Arboleda
Section #: 7F34
TA Name: Wesley Piard
Description: SPI COMMUNICATION TESTING

Lab6b.c
Created: 7/17/2017 4:49:59 AM
*/ 

#include <avr/io.h>
#include "constants.h"
#include "Clk_32MHz.h"
#include "SPI.h"


int main(void){
    //Set up program
	Change_CLK_32HZ();
	spi_init();
	
	//Loop for sending 0x53 continuously
	while(TRUE){
		spiWrite(0x53);
	}
}