#ifndef ATXMEGA_DISPLAY_H_
#define ATXMEGA_DISPLAY_H_
/*
Name: Michael Arboleda
Section #: 7F34
TA Name: Wesley Piard
Description: Sets up Chars 
			and strings for USART

ATXMEGA_DISPLAY.h
Created: 7/11/2017 6:22:24 AM
*/ 

#include <avr/io.h>


/*********************Function**************************************
Function Name: int_to_char
Inputs: uint8_t x
Outputs: No outputs
*/
char int_to_char(uint8_t x){
	
	// Return char verion of hex digit
	switch(x){
		case 0: return '0';
		case 1: return '1';
		case 2: return '2';
		case 3: return '3';
		case 4: return '4';
		case 5: return '5';
		case 6: return '6';
		case 7: return '7';
		case 8: return '8';
		case 9: return '9';
		case 10: return 'A';
		case 11: return 'B';
		case 12: return 'C';
		case 13: return 'D';
		case 14: return 'E';
		case 15: return 'F';
	}
	// Return NULL if invalid number
	return NULL;
}



/*********************Function**************************************
Function Name: volt_string
Inputs: char * c, uint8_t x
Outputs: No outputs
*/
void volt_string(char * c, uint8_t x){
	
	// Change to decimal form of signed num
	float f1;
	uint8_t y = x;
	
	if((x&PIN7_bm) == PIN7_bm){
		y = ((~(x))+1);
	}
	f1 = ((y*1.0)*0.02);

	
	
	//Store first digit of f1
	uint8_t d1 = (uint8_t)((int)f1);
	
	//Bring digit 2 to front
	float f2 = 10.0*(f1-d1);
	
	//Store 2nd digit of f1
	uint8_t d2 = (uint8_t) ((int)f2);
	
	//Store 3rd digit of f1
	uint8_t d3 = (uint8_t) ((int) (10.0*(f2-d2)));
	
	//Make string with volt output
	char ca[] = { ((x & PIN7_bm) == PIN7_bm ? '-': '+'), int_to_char(d1),
		'.', int_to_char(d2), int_to_char(d3), ' ', 'V', ' ', '(',
		int_to_char((x >> 4) & 0x0F) ,int_to_char(x & 0x0F), ')', '\r', '\n',NULL
	};
	
	//Store string in char array passed in
	for(int i = 0; i < 15; i++){
		//store each char in order
		c[i] = ca[i];
	}
	//return
	return;
}






#endif /* ATXMEGA_DISPLAY_H_ */