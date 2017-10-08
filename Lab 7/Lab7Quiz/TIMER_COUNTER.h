#ifndef TIMER_COUNTER_H_
#define TIMER_COUNTER_H_

/*
Name: Michael Arboleda
Section #: 7F34
TA Name: Wesley Piard
Description: Header for TIMER_COUNTER

TIMER_COUNTER.h
Created: 7/12/2017 6:09:50 AM
*/ 


void COUNTER_INIT(void);
void COUNTER_START(void);
void COUNTER_STOP(void);
void UPDATE_PER(uint8_t input);


#endif /* TIMER_COUNTER_H_ */