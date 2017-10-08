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

//****************** CLK_32MHz.h ***********************************
const uint8_t DAC_CTRLA_CONFIG = 0b00000101;//0x05 
const uint8_t DAC_CTRLC_CONFIG = 0b00011000;//0x18

#endif /* CONSTANTS_H_ */