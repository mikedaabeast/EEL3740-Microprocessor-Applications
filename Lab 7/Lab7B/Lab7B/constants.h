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

//****************** CLK_32MHz.c ***********************************
const uint8_t NEW_CLOCK_FREQ = 0b00000010;

//****************** DAC.c *****************************************
const uint8_t DAC_CTRLA_CONFIG = 0b00000101;//0x05 
const uint8_t DAC_CTRLC_CONFIG = 0b00011000;//0x18


//****************** TIMER_COUNTER.c *******************************
const uint16_t TC_PER_CONFIG = 137;
const uint8_t INTCTRLA_CONFIG = 0b00000011;//0x03
const uint8_t CLK_DIV_CONFIG = 0b00000100;//0x04




// SINEWAVE FROM http:/ /www.daycounter.com/Calculators/Sine-GeneratorCalculator.phtml
// PARAMETERS: 100 POINTS, AMPLITUDE FFF(4096)
volatile sine[] = {0x800,0x881,0x901,0x980,0x9fd,0xa79,0xaf2,0xb68,0xbdb,0xc49,
	0xcb4,0xd19,0xd7a,0xdd5,0xe2a,0xe79,0xec1,0xf03,0xf3d,0xf70,
	0xf9c,0xfc0,0xfdc,0xff0,0xffc,0xfff,0xffc,0xff0,0xfdc,0xfc0,
	0xf9c,0xf70,0xf3d,0xf03,0xec1,0xe79,0xe2a,0xdd5,0xd7a,0xd19,
	0xcb4,0xc49,0xbdb,0xb68,0xaf2,0xa79,0x9fd,0x980,0x901,0x881,
	0x800,0x77f,0x6ff,0x680,0x603,0x587,0x50e,0x498,0x425,0x3b7,
	0x34c,0x2e7,0x286,0x22b,0x1d6,0x187,0x13f,0xfd,0xc3,0x90,
	0x64,0x40,0x24,0x10,0x4,0x0,0x4,0x10,0x24,0x40,
	0x64,0x90,0xc3,0xfd,0x13f,0x187,0x1d6,0x22b,0x286,0x2e7,
	0x34c,0x3b7,0x425,0x498,0x50e,0x587,0x603,0x680,0x6ff,0x77F};

#endif /* CONSTANTS_H_ */