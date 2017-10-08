/*
 * PULSE.c
 *
 * Created: 8/1/2017 10:13:14 AM
 *  Author: micha
 */ 
#include <avr/io.h>


void PWM_setup(void){
	
	PORTD.REMAP = 0b00000111;
	PORTD.DIRSET = 0x70;

	
//Invert Port D
	//PORTD.PIN0CTRL = 0b01000000;
	//PORTD.PIN1CTRL = 0b01000000;
	//PORTD.PIN2CTRL = 0b01000000; 
	//PORTD.PIN3CTRL = 0b01000000; 
	PORTD.PIN4CTRL = 0b01000000; 
	PORTD.PIN5CTRL = 0b01000000; 	
	PORTD.PIN6CTRL = 0b01000000;	
	//PORTD.PIN7CTRL = 0b01000000; 

	TCD0.PER = 0x00FF; 
	

	//Set up Control D
	TCD0.CTRLD = 0X00;//		; LOAD CTRLD with 0x00

	//; Set up Control B
	TCD0.CTRLB = 0b01110011;//		; Store contrl b config
}