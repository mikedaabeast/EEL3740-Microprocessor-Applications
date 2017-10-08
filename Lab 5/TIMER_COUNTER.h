#ifndef TIMER_COUNTER_H_
#define TIMER_COUNTER_H_

/*
Name: Michael Arboleda
Section #: 7F34
TA Name: Wesley Piard
Description: Timer Counter

TIMER_COUNTER.h
Created: 7/12/2017 6:09:50 AM
*/ 
#include <avr/io.h>
#include <avr/interrupt.h>
#include "constants.h"
#include "ATXMEGA_DISPLAY.h"

extern const uint16_t TC_PER_CONFIG;
extern const uint8_t INTCTRLA_CONFIG;
extern const uint8_t CLK_DIV_CONFIG;

void COUNTER_INIT(void){
	// SET top of counter
	TCC0.PER = TC_PER_CONFIG; 
	
	return;
}

void COUNTER_START(void){
	//SET interupt for counter
	TCC0.INTCTRLA = INTCTRLA_CONFIG;
	
	//Start COUNTER
	TCC0_CTRLA = CLK_DIV_CONFIG;
	
	return;
}

void COUNTER_STOP(void){
	
	//STOP TIMER INTERRUPT
	TCC0.INTCTRLA = 0x00;
	
	//STOP TIMER
	TCC0.CTRLA = 0x00;
	
	//RESET TIMER
	TCC0_CTRLFCLR = TC_CMD_RESTART_gc;
	
	return;
}


ISR(TCC0_OVF_vect){
	char c[15];
	
	ADCA.CH0.CTRL |= PIN7_bm;
	uint8_t x = ADCA.CH0.RESL;
	
	//Display on terminal
	volt_string(c,x);
	OUT_STRING("ISR: ");
	OUT_STRING(c);
}



#endif /* TIMER_COUNTER_H_ */