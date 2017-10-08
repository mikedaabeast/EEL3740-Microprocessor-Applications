/*


ADC.c
Created: 7/31/2017 10:51:27 PM
*/ 


//INCLUDES
#include <avr/io.h>
#include <avr/interrupt.h>

//IMPORT CONSTANTS
extern const uint8_t ADC_CTRLA_CONFIG;
extern const uint8_t ADC_CTRLB_CONFIG;
extern const uint8_t ADC_REFCTRL_CONFIG;
extern const uint8_t ADC_PRESCALER_CONFIG;
extern const uint8_t ADC_CH0_CTRL_CONFIG;
extern const uint8_t ADC_CH0_MUXCTRL_CONFIG;
extern const uint8_t ADC_PORTA;
extern const uint8_t ADC_CH1_CTRL_CONFIG;
extern const uint8_t ADC_CH1_MUXCTRL_CONFIG;
extern const uint8_t ADC_CH0_INTCTRL_CONFIG;
extern const uint8_t ADC_CH1_INTCTRL_CONFIG;
extern const uint8_t ADC_CMP_CONFIG;

void ADC_INIT(){
	ADCA.CTRLA = 0x01;
	ADCA.REFCTRL = ADC_REFSEL_AREFB_gc;
	ADCA.CTRLB = ADC_RESOLUTION_8BIT_gc;
	ADCA.PRESCALER = 0x07;
	PORTA.DIRCLR = PIN1_bm;
	ADCA.CH0.CTRL = ADC_CH_INPUTMODE_SINGLEENDED_gc;
	ADCA.CH0.MUXCTRL = ADC_CH_MUXPOS_PIN1_gc;
}