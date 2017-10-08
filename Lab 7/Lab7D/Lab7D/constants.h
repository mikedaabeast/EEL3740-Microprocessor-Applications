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
const uint16_t TC_PER_CONFIG = 822;//50hz
const uint8_t INTCTRLA_CONFIG = 0b00000011;//0x03
const uint8_t CLK_DIV_CONFIG = 0b00000100;//0x04


//****************** DMA.c *****************************************
const uint8_t DMA_CTRL_CONFIG = 0b10000000;//0x80
const uint8_t DMA_CH0_ADDRCTRL_CONFIG = 0b01011001 ;//0x59
const uint8_t DMA_CH0_TRIGSRC_CONFIG = 0b01000000;//0x40
const uint8_t DMA_CH0_TRFCNT_CONFIG = 200;
const uint8_t DMA_CH0_REPCNT_CONFIG = 0x00;
const uint8_t DMA_CH0_CTRLA_CONFIG = 0b10100101;//0xA5


//****************** USART.h ***************************************
const uint8_t pin_Tx = PIN3_bm;
const uint8_t pin_Rx = PIN2_bm;
const uint8_t TxRx_On = 0b00011000;	// 0x18
// asynch, 8 databits, no parity, 1 start, and 1 stop
const uint8_t usart_ctrl_C = 0b00000011;
// BSEL 28,800
const uint8_t upper_BSEL = 0b00001000;
const uint8_t BSEL = 0b10001110;
const uint8_t BSCALE = 0b10110000;	// -5  BSCALE


// SINEWAVE FROM http:/ /www.daycounter.com/Calculators/Sine-GeneratorCalculator.phtml
// PARAMETERS: 100 POINTS, AMPLITUDE FFF(4096)
uint16_t sine[] = {0x800,0x881,0x901,0x980,0x9fd,0xa79,0xaf2,0xb68,0xbdb,0xc49,
	0xcb4,0xd19,0xd7a,0xdd5,0xe2a,0xe79,0xec1,0xf03,0xf3d,0xf70,
	0xf9c,0xfc0,0xfdc,0xff0,0xffc,0xfff,0xffc,0xff0,0xfdc,0xfc0,
	0xf9c,0xf70,0xf3d,0xf03,0xec1,0xe79,0xe2a,0xdd5,0xd7a,0xd19,
	0xcb4,0xc49,0xbdb,0xb68,0xaf2,0xa79,0x9fd,0x980,0x901,0x881,
	0x800,0x77f,0x6ff,0x680,0x603,0x587,0x50e,0x498,0x425,0x3b7,
	0x34c,0x2e7,0x286,0x22b,0x1d6,0x187,0x13f,0xfd,0xc3,0x90,
	0x64,0x40,0x24,0x10,0x4,0x0,0x4,0x10,0x24,0x40,
	0x64,0x90,0xc3,0xfd,0x13f,0x187,0x1d6,0x22b,0x286,0x2e7,
0x34c,0x3b7,0x425,0x498,0x50e,0x587,0x603,0x680,0x6ff,0x77F};

//TRIANGLE WAVE FROM http:/ /www.daycounter.com/Calculators/Triangle-WaveGenerator
//-Calculator.phtml
//PARAMETERS: 100 POINTS, AMPLITUDE FFF(4096)
uint16_t triangle[] = {0x52,0xa4,0xf6,0x148,0x19a,0x1ec,0x23d,0x28f,0x2e1,0x333,
	0x385,0x3d7,0x429,0x47b,0x4cd,0x51f,0x571,0x5c3,0x614,0x666,
	0x6b8,0x70a,0x75c,0x7ae,0x800,0x852,0x8a4,0x8f6,0x948,0x99a,
	0x9ec,0xa3d,0xa8f,0xae1,0xb33,0xb85,0xbd7,0xc29,0xc7b,0xccd,
	0xd1f,0xd71,0xdc3,0xe14,0xe66,0xeb8,0xf0a,0xf5c,0xfae,0xfff,
	0xfae,0xf5c,0xf0a,0xeb8,0xe66,0xe14,0xdc3,0xd71,0xd1f,0xccd,
	0xc7b,0xc29,0xbd7,0xb85,0xb33,0xae1,0xa8f,0xa3d,0x9ec,0x99a,
	0x948,0x8f6,0x8a4,0x852,0x800,0x7ae,0x75c,0x70a,0x6b8,0x666,
	0x614,0x5c3,0x571,0x51f,0x4cd,0x47b,0x429,0x3d7,0x385,0x333,
0x2e1,0x28f,0x23d,0x1ec,0x19a,0x148,0xf6,0xa4,0x52,0x0};

#endif /* CONSTANTS_H_ */