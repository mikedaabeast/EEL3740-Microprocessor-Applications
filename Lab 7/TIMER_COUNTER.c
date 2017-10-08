/*
Name: Michael Arboleda
Section #: 7F34
TA Name: Wesley Piard
Description: Functions for TIMER_COUNTER

TIMER_COUNTER.c
Created: 7/25/2017 2:21:42 AM
*/ 

#include <avr/io.h>
#include <avr/interrupt.h>
#include "DAC.h"

//Include extern constants
extern const uint16_t TC_PER_CONFIG;
extern const uint8_t INTCTRLA_CONFIG;
extern const uint8_t CLK_DIV_CONFIG;

/*********************Function**************************************
; Function Name: COUNTER_INIT
; Inputs: Char c
; Outputs: No outputs
*/
void COUNTER_INIT(void){
	// SET top of counter
	TCC0.PER = TC_PER_CONFIG;
	
	//Return from function
	return;
}



/*********************Function**************************************
; Function Name: COUNTER_START
; Inputs: No inputs
; Outputs: No outputs
*/
void COUNTER_START(void){
	//SET interupt for counter
	TCC0.INTCTRLA = INTCTRLA_CONFIG;
	
	//Start COUNTER
	TCC0_CTRLA = CLK_DIV_CONFIG;
	
	//Return from function
	return;
}



/*********************Function**************************************
; Function Name: COUNTER_STOP
; Inputs: No inputs
; Outputs: No outputs
*/
void COUNTER_STOP(void){
	
	//STOP TIMER INTERRUPT
	TCC0.INTCTRLA = 0x00;
	
	//STOP TIMER
	TCC0.CTRLA = 0x00;
	
	//RESET TIMER
	TCC0_CTRLFCLR = TC_CMD_RESTART_gc;
	
	//Return from function
	return;
}



/*********************Function**************************************
; Function Name: COUNTER_STOP
; Inputs: uint8_t:input
; Outputs: No outputs
*/
void UPDATE_PER(uint8_t input){
	//Stop Timer
	COUNTER_STOP();
	
	//Update PER (Hz)
	TCC0.PER = (TC_PER_CONFIG/input);	
	//Start Timer
	COUNTER_START();
	
	//Return from function
	return;
}


/*********************ISR**************************************
; ISR TYPE: TCC0_OVF_vect
; Inputs: NO inputs
; Outputs: No outputs
*/
ISR(TCC0_OVF_vect){
	//Preserve Status Reg
	uint8_t temp = CPU_SREG;
		
	//Clear interrupt flags
	TCC0.INTFLAGS = 0x01;
	
	//Restore Status Reg
	CPU_SREG = temp;
	
	//Return from ISR
	return;

}