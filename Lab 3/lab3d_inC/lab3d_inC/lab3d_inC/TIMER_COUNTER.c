/*
 * TIMER_COUNTER.c
 *
 * Created: 7/31/2017 6:22:25 PM
 *  Author: micha
 */ 


extern const uint16_t TCC0_PER_CONFIG;
extern const uint8_t TCC0_INTCTRLA_CONFIG;
extern const uint8_t TCC0_CTRLA_CONFIG;


void SET_COUNTER(void){
	TCC0.PER = TCC0_PER_CONFIG;
	
	//Return from function
	return;
}

void START_COUNTER(void){
	//SET interupt for counter
	TCC0.INTCTRLA = TCC0_INTCTRLA_CONFIG;
	
	//Start COUNTER
	TCC0.CTRLA = TCC0_CTRLA_CONFIG;
	
	
	//Return from function
	return;
}




void STOP_COUNTER(void){
	//STOP TIMER INTERRUPT
	TCC0.INTCTRLA = FALSE;
	
	//STOP TIMER
	TCC0.CTRLA = FALSE;
	
	//RESET TIMER
	TCC0_CTRLFCLR = TC_CMD_RESTART_gc;
	
	//Return from function
	return;
}


