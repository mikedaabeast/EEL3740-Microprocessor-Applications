#ifndef USART_H_
#define USART_H_
/*
Name: Michael Arboleda
Section #: 7F34
TA Name: Wesley Piard
Description: Set up USART

USART.h
Created: 7/8/2017 3:07:25 AM
 */ 

/*********************Function**************************************
; Function Name: USART_INIT
; Inputs: No inputs
; Outputs: No outputs
*/
void USART_INIT(void);


/*********************Function**************************************
; Function Name: OUT_CHAR
; Inputs: Char c
; Outputs: No outputs
*/
void OUT_CHAR(char c);



/*********************Function**************************************
; Function Name: OUT_STRING
; Inputs: Char pointer c
; Outputs: No outputs
*/
void OUT_STRING(char* str);



/*********************Function**************************************
; Function Name: IN_CHAR
; Inputs: Char c
; Outputs: No outputs
*/
char IN_CHAR(void);

#endif /* USART_H_ */