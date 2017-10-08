#ifndef CLK_32MHZ_H_
#define CLK_32MHZ_H_

/*
Name: Michael Arboleda
Section #: 7F34
TA Name: Wesley Piard
Description: Changes uP freq to 32Mhz

Clk_32MHz.h
Created: 7/7/2017 11:20:13 PM
*/ 
#include <avr/io.h>
#include "constants.h"

//include extern constants
extern const uint8_t NEW_CLOCK_FREQ;


/*********************Function**************************************
; Function Name: Change_CLK_32HZ
; Inputs: No direct input (from stack)
; Outputs: No direct outputs
*/
void Change_CLK_32HZ(){
	
	//Set the clk config
	OSC_CTRL = NEW_CLOCK_FREQ;
	
	//Wait for the right flag to be set in the OSC_STATUS reg 
	while((OSC_STATUS & PIN1_bm) != PIN1_bm);
	
	//Write the “IOREG” signature to the CPU_CCP reg
	CPU_CCP = CCP_IOREG_gc;
	
	//Select the new clock source in the CLK_CTRL reg
	CLK_CTRL = CLK_SCLKSEL_RC32M_gc;
	
	return;
}

#endif /* CLK_32MHZ_H_ */