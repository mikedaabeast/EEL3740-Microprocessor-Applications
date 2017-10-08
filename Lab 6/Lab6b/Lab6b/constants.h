#ifndef CONSTANTS_H_
#define CONSTANTS_H_

/*
Name: Michael Arboleda
Section #: 7F34
TA Name: Wesley Piard
Description: Changes uP freq to 32Mhz

constants.h
Created: 7/7/2017 11:53:20 PM
*/ 
#include <avr/io.h>

//OVERALL DEFS
#define TRUE 1
#define FALSE 0
#define NULL 0

//****************** CLK_32MHz.h ***********************************
const uint8_t NEW_CLOCK_FREQ = 0b00000010;



//****************** SPI.h ***********************************
//PORT F
const uint8_t PORTF_DIRSET_CONFIG = 0b10111100;//0xBC
const uint8_t PORTF_DIRCLR_CONFIG = 0b01000000;//0x40
const uint8_t PORTF_OUTSET_CONFIG = 0b00011000;//0x18
//PORT A
const uint8_t PORTA_DIRSET_CONFIG = 0b00011000;//0x18
const uint8_t PORTA_OUTCLR_CONFIG = 0b00010000;//0x10
//SPI
const uint8_t SPI_CTRL_CONFIG = 0b01011111;	 //0x5F

#endif /* CONSTANTS_H_ */