#ifndef CONSTANTS_H_
#define CONSTANTS_H_

/*Lab 5

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

//****************** CLK_32MHz.h ***********************************
const uint8_t NEW_CLOCK_FREQ = 0b00000010;



//****************** USART.h ***************************************
const uint8_t pin_Tx = PIN3_bm;
const uint8_t pin_Rx = PIN2_bm;
const uint8_t TxRx_On = 0b00011000;	// 0x18
// asynch, 8 databits, odd parity, 1 start, and 1 stop
const uint8_t usart_ctrl_C = 0b00110011;
// BSEL 576000
const uint8_t upper_BSEL = 0b00000100;
const uint8_t BSEL = 0b00110111;
const uint8_t BSCALE = 0b10110000;	// -5  BSCALE



//****************** EBI.h ***************************************
const uint8_t ebi_ctrl_config = 0b00000001;
const uint8_t ebi_ctrla_config = 0b00010101;
const uint8_t ebi_baseaddlL_config = 0x80;
const uint8_t ebi_baseaddlH_config = 0b00000000;
const uint8_t PORTH_CONFIG = 0b00010111;
const uint8_t PORTK_CONFIG = 0b11111111;




#endif /* CONSTANTS_H_ */