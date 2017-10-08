#ifndef ADC_H_
#define ADC_H_
/*
Name: Michael Arboleda
Section #: 7F34
TA Name: Wesley Piard
Description: Sets up ADC

ADC.h
Created: 7/11/2017 2:50:03 AM
*/ 

//INCLUDES
#include <avr/io.h>
#include "constants.h"

//IMPORT CONSTANTS
extern const uint8_t ADC_CTRLA_CONFIG;
extern const uint8_t ADC_CTRLB_CONFIG;
extern const uint8_t ADC_REFCTRL_CONFIG;
extern const uint8_t ADC_PRESCALER_CONFIG;
extern const uint8_t ADC_CH0_CTRL_CONFIG;
extern const uint8_t ADC_CH0_MUXCTRL_CONFIG;
extern const uint8_t ADC_PORTA;

void ADC_INIT(){
	//SET PORT A as input
	PORTA_DIRCLR = ADC_PORTA;
	
	//SET up Control A and B
	ADCA.CTRLA = ADC_CTRLA_CONFIG;
	ADCA.CTRLB = ADC_CTRLB_CONFIG;	

	// Set up REf and Pre scaler controls
	ADCA.REFCTRL = ADC_REFCTRL_CONFIG;
	ADCA.PRESCALER = ADC_PRESCALER_CONFIG;
	
	// Set up Chan 0 ctrl/mux ctrl
	ADCA.CH0.CTRL = ADC_CH0_CTRL_CONFIG;
	ADCA.CH0.MUXCTRL = ADC_CH0_MUXCTRL_CONFIG;
}









#endif /* ADC_H_ */