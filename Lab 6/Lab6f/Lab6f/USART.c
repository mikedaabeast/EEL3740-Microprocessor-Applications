/*
Name: Michael Arboleda
Section #: 7F34
TA Name: Wesley Piard
Description: Set up USART

USART.c
Created: 7/18/2017 5:05:45 AM
*/ 
#include <avr/io.h>

extern const uint8_t pin_Tx;
extern const uint8_t pin_Rx;
extern const uint8_t TxRx_On;
extern const uint8_t usart_ctrl_C;
extern const uint8_t BSCALE;
extern const uint8_t upper_BSEL;
extern const uint8_t BSEL;
/*********************Function**************************************
; Function Name: USART_INIT
; Inputs: No inputs
; Outputs: No outputs
*/
void USART_INIT(void){
	// Set port D for USART com
	PORTD.DIRSET = pin_Tx;
	PORTD.OUTSET = pin_Tx;
	PORTD.DIRCLR = pin_Rx;
	
	//Set up Ctrl B and C
	USARTD0_CTRLB = TxRx_On;
	USARTD0_CTRLC = usart_ctrl_C;
	
	//Set up baud rate
	USARTD0.BAUDCTRLA = BSEL & 0xFF;
	USARTD0.BAUDCTRLB = (BSCALE <<4 & 0xF0);
	
	return;
}



/*********************Function**************************************
; Function Name: OUT_CHAR
; Inputs: Char c
; Outputs: No outputs
*/
void OUT_CHAR(uint8_t c){
	
	// Wait until prev receive done
	while((USARTD0.STATUS & PIN5_bm) == 0);
	
	//Output char thru USART
	USARTD0.DATA = c;

	return;
}