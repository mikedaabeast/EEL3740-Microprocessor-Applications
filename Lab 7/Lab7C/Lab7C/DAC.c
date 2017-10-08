/*
Name: Michael Arboleda
Section #: 7F34
TA Name: Wesley Piard
Description: Functions for DAC

DAC.c
Created: 7/25/2017 1:08:39 AM
*/ 


#include <avr/io.h>

//include extern constants
extern const uint8_t DAC_CTRLA_CONFIG;
extern const uint8_t DAC_CTRLC_CONFIG;

/*********************Function**************************************
; Function Name: DAC_INIT
; Inputs: No direct input
; Outputs: No direct outputs
*/
void DAC_INIT(void){
	//Set port A for output
	PORTA.DIRSET = PIN2_bm;//0x04
	
	//Set up DAC controls
	DACA.CTRLA = DAC_CTRLA_CONFIG;
	DACA.CTRLC = DAC_CTRLC_CONFIG;
	
}

/*********************Function**************************************
; Function Name: UPDATE_DACA_CH0
; Inputs: uint8_t:data
; Outputs: No direct outputs
*/
void UPDATE_DACA_CH0(uint16_t data){
	//Store data in CH0
	DACA.CH0DATA = data;
	
	//Return from function
	return;
}