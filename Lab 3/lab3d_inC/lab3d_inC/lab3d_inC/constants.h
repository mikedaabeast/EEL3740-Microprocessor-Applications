#ifndef CONSTANTS_H_
#define CONSTANTS_H_
/*


constants.h
Created: 7/31/2017 6:13:52 PM
*/ 

#define TRUE 1
#define FALSE 0

//****************** CLK_32MHz.c ***********************************
const uint8_t NEW_CLOCK_FREQ = 0b00000010;

//****************** TIMER_COUNTER.c ***********************************
const uint16_t TCC0_PER_CONFIG = 0xFF00;
const uint8_t TCC0_INTCTRLA_CONFIG = 0b00000011; //0x03
const uint8_t TCC0_CTRLA_CONFIG =  0b00000111; //0x07









#endif /* CONSTANTS_H_ */