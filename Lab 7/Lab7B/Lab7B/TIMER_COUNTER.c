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
extern volatile uint16_t sine[];

//Global Varibles
volatile uint8_t counter = 0;

/*********************Function**************************************
; Function Name: COUNTER_INIT
; Inputs: No direct input
; Outputs: No direct outputs
*/
void COUNTER_INIT(void){
	// SET top of counter
	TCC0.PER = TC_PER_CONFIG;
	
	return;
}



/*********************Function**************************************
; Function Name: COUNTER_START
; Inputs: No direct input
; Outputs: No direct outputs
*/
void COUNTER_START(void){
	//SET interupt for counter
	TCC0.INTCTRLA = INTCTRLA_CONFIG;
	
	//Start COUNTER
	TCC0_CTRLA = CLK_DIV_CONFIG;
	
	//Return from function
	return;
}

/*********************ISR**************************************
; ISR TYPE: TCC0_OVF_vect
; Inputs: No direct input
; Outputs: No direct outputs
*/
ISR(TCC0_OVF_vect){
	//Preserve Status Reg
	uint8_t temp = CPU_SREG;
	
	//Change output
	UPDATE_DACA_CH0(sine[counter++]);
	
	//IF END OF SINE TABLE
	if(counter == 100){
		//Reset Counter
		counter = 0;
	}
		
	//Clear interrupt flags
	TCC0.INTFLAGS = 0x01;
	
	//Restore Status Reg
	CPU_SREG = temp;
	
	//Return from ISR
	return;

}