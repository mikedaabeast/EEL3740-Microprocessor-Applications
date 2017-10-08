/*
 * Lab6Quiz.c
 * Created: 7/19/2017 5:16:24 PM
 */ 

#include <avr/io.h>
#include <avr/interrupt.h>
#include "constants.h"
#include "Clk_32MHz.h"
#include "USART.h"
#include "SPI.h"
#include "LSM.h"
#include "LSM330.h"

int main(void){
	//Set up code
	Change_CLK_32HZ();
	USART_INIT();
	spi_init();
	accel_init();
	gyro_init();
	
	//Set up interrupts
	PMIC.CTRL = 0x07;
	sei();

	//Clear data in Gyro
	CLR_GYRO();
	
	//WHILE(1)
	while(TRUE){
		//IF accel data is ready
		if(accelDataReady){
			READ_DATA_ACCEL();
			DISPLAY_PER_AXIS();
		}
	}
	
	// Return with status 0
	return 0;
}