/*


SPI.c
Created: 7/17/2017 6:25:57 AM
*/ 

#include <avr/io.h>

//include extern constants
extern const uint8_t PORTF_DIRSET_CONFIG;
extern const uint8_t PORTF_DIRCLR_CONFIG;
extern const uint8_t PORTF_OUTSET_CONFIG;
extern const uint8_t PORTA_DIRSET_CONFIG;
extern const uint8_t PORTA_OUTCLR_CONFIG;
extern const uint8_t SPI_CTRL_CONFIG;

/*********************Function**************************************
; Function Name: spi_init
; Inputs: No direct input
; Outputs: No direct outputs
*/
void spi_init(void){

	//Set up port F
	PORTF.DIRSET = PORTF_DIRSET_CONFIG;
	PORTF.DIRCLR = PORTF_DIRCLR_CONFIG;
	PORTF.OUTSET = PORTF_OUTSET_CONFIG;
	
	//Set up port A
	PORTA.DIRSET = PORTA_DIRSET_CONFIG;
	PORTA.OUTCLR = PORTA_OUTCLR_CONFIG;
	
	//Set up SPI
	SPIF.CTRL = SPI_CTRL_CONFIG;//0x5F
	
	return;
}


/*********************Function**************************************
; Function Name: spiWrite
; Inputs: uint8_t:=DATA
; Outputs: uint8_t:=SPIF.DATA
*/
uint8_t spiWrite(uint8_t data){
	//Enable Slave
	PORTF.OUTCLR = 0x18;
	
	//Write to DATA reg
	SPIF.DATA = data;
	
	//Wait for transfer to finish
	while((SPIF.STATUS & 0x80) != 0x80);
	
	//Turn off slave select
	PORTF.OUTSET = 0x18;
	
	//Return data in SPIF.DATA
	return (SPIF.DATA);
}/*********************Function**************************************
; Function Name: spiRead
; Inputs: No direct input
; Outputs: uint8_t:=SPIF.DATA
*/uint8_t spiRead(){	return(spiWrite(0xFF));}