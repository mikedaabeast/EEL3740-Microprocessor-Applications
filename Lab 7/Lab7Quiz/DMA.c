/*
Name: Michael Arboleda
Section #: 7F34
TA Name: Wesley Piard
Description: Functions for DMA

DMA.c
Created: 7/25/2017 3:53:36 AM
*/ 

#include <avr/io.h>

//Include constants
extern uint16_t sine[];
extern uint16_t triangle[];
extern const uint8_t DMA_CTRL_CONFIG;
extern const uint8_t DMA_CH0_ADDRCTRL_CONFIG;
extern const uint8_t DMA_CH0_TRIGSRC_CONFIG;
extern const uint8_t DMA_CH0_TRFCNT_CONFIG;
extern const uint8_t DMA_CH0_REPCNT_CONFIG;
extern const uint8_t DMA_CH0_CTRLA_CONFIG; 

//Function Prototype
void SINE_SOURCE_DES(void);

/*********************Function**************************************
; Function Name: DMA_INIT
; Inputs: No inputs
; Outputs: No outputs
*/
void DMA_INIT(uint8_t mode){
	//Enable DMA
	DMA.CTRL = DMA_CTRL_CONFIG;
	
	//ADDRESS CONTROL REG: BLOCK;INCREMENT;BURST;INCREMENT
	DMA.CH0.ADDRCTRL = DMA_CH0_ADDRCTRL_CONFIG;
	
	//TRIGGER SOURCE REG: TCC0
	DMA.CH0.TRIGSRC = DMA_CH0_TRIGSRC_CONFIG;
	
	//CH BLOCK TRANSFER COUNT: 200=100(8bit)*2(16bit)
	DMA.CH0.TRFCNT = DMA_CH0_TRFCNT_CONFIG;
	
	//CONTINOUS DMA
	DMA.CH0.REPCNT = DMA_CH0_REPCNT_CONFIG; 
	
	if(mode == 's'){
		//Set up DMA with sine
		SINE_SOURCE_DES();
	}
	else if(mode == 't'){
		//Set up DMA with sine
		TRIANGLE_SOURCE_DES();
	}
	
	//Set CH0 CTRL: ENABLE;REPEAT;SINGLE;2BYTE
	DMA.CH0.CTRLA = DMA_CH0_CTRLA_CONFIG;
	
	//Return from function
	return;
}



/*********************Function**************************************
; Function Name: SINE_SOURCE_DES
; Inputs: No inputs
; Outputs: No outputs
*/
void SINE_SOURCE_DES(void){
	//Wait until CH is not busy
	while((DMA.CH0.CTRLB & PIN7_bm) == PIN7_bm);
	
	//Set up address with Sine
	uint32_t SINE_ADDRESS = (uint32_t)sine;
	
	//Source Address
	DMA.CH0.SRCADDR0 = (uint8_t)(SINE_ADDRESS >> 0);
	DMA.CH0.SRCADDR1 = (uint8_t)(SINE_ADDRESS >> 8);
	DMA.CH0.SRCADDR2 = (uint8_t)(SINE_ADDRESS >> 16);
	
	uint8_t* dac_ptr = &DACA_CH0DATA;
	uint32_t dac_address = (uint32_t)dac_ptr;
	
	//Destination Address
	DMA.CH0.DESTADDR0 = (uint8_t)(dac_address >> 0);
	DMA.CH0.DESTADDR1 = (uint8_t)(dac_address >> 8);
	DMA.CH0.DESTADDR2 = (uint8_t)(dac_address >> 16);	
	
	//Return from function
	return;
}



/*********************Function**************************************
; Function Name: TRIANGLE_SOURCE_DES
; Inputs: No inputs
; Outputs: No outputs
*/
void TRIANGLE_SOURCE_DES(void){
	//Wait until CH is not busy
	while((DMA.CH0.CTRLB & PIN7_bm) == PIN7_bm);
	
	//Set up address with Triangle
	uint32_t TRIANGLE_ADDRESS = (uint32_t)triangle;
	
	//Source Address
	DMA.CH0.SRCADDR0 = (uint8_t)(TRIANGLE_ADDRESS >> 0);
	DMA.CH0.SRCADDR1 = (uint8_t)(TRIANGLE_ADDRESS >> 8);
	DMA.CH0.SRCADDR2 = (uint8_t)(TRIANGLE_ADDRESS >> 16);
	
	uint8_t* dac_ptr = &DACA_CH0DATA;
	uint32_t dac_address = (uint32_t)dac_ptr;
	
	//Destination Address
	DMA.CH0.DESTADDR0 = (uint8_t)(dac_address >> 0);
	DMA.CH0.DESTADDR1 = (uint8_t)(dac_address >> 8);
	DMA.CH0.DESTADDR2 = (uint8_t)(dac_address >> 16);
	
	//Return from function
	return;
}

void DMA_CHANGE(uint8_t mode){
	//Disable DMA
	DMA.CTRL = 0;
	
	//Software Reset on
	DMA.CTRL = 0b01000000;
	
	//Re initlize DMA with new wave mode
	DMA_INIT(mode);
}