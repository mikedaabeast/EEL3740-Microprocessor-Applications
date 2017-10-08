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
const uint8_t PORTF_DIRSET_CONFIG = 0xBC;//0b10111100
const uint8_t PORTF_DIRCLR_CONFIG = 0x40;//0b01000000
const uint8_t PORTF_OUTSET_CONFIG = 0x18;//0b00011000
//PORT A
const uint8_t PORTA_DIRSET_CONFIG = 0x18;//0b00011000
const uint8_t PORTA_OUTCLR_CONFIG = 0x10;//0b00010000
//SPI
const uint8_t SPI_CTRL_CONFIG = 0x5C;//0b01011100


//****************** LSM.h ***********************************
//PORT C
const uint8_t PORTC_INTCTRL_CONFIG = 0x03;//0b00000011;
const uint8_t PORTC_INT0MASK_CONFIG = 0x80;//0b10000000;
const uint8_t PORTC_PIN7CTRL_CONFIG = 0x02;//0b00000010
//PORT A
const uint8_t PORTA_INTCTRL_CONFIG = 0x03;//0b00000011
const uint8_t PORTA_INT0MASK_CONFIG = 0x02;//0b00000010
const uint8_t PORTA_PIN1CTRL_CONFIG = 0x19;//0b00011001
//FLAGS
volatile uint8_t accelDataReady = 0;
volatile uint8_t gyroDataReady = 0;


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



#endif /* CONSTANTS_H_ */