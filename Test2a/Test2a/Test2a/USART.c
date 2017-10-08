/*
 * USART.c
 *
 * Created: 8/1/2017 10:01:20 AM
 *  Author: micha
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
	USARTD0.BAUDCTRLA = BSEL;
	USARTD0.BAUDCTRLB = (BSCALE | upper_BSEL);
	
	return;
}



/*********************Function**************************************
; Function Name: OUT_CHAR
; Inputs: Char c
; Outputs: No outputs
*/
void OUT_CHAR(char c){
	
	// Wait until prev receive done
	while((USARTD0.STATUS & PIN5_bm) == 0);
	
	//Output char thru USART
	USARTD0.DATA = c;

	return;
}



/*********************Function**************************************
; Function Name: OUT_STRING
; Inputs: Char pointer c
; Outputs: No outputs
*/
void OUT_STRING(char* str){
	//While char is not null
	while(*str){
		//Output char
		OUT_CHAR(*str++);
	}
	return;
}



/*********************Function**************************************
; Function Name: IN_CHAR
; Inputs: Char c
; Outputs: No outputs
*/
char IN_CHAR(void){
	while((USARTD0.STATUS & PIN7_bm) == 0);
	return USARTD0_DATA;
}


