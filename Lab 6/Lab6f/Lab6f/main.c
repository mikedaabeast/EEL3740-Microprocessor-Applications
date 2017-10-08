/* Lab6 Part F

Lab6f.c
Created: 7/18/2017 12:47:12 AM
*/ 

#include <avr/io.h>
#include <avr/interrupt.h>
#include "constants.h"
#include "Clk_32MHz.h"
#include "SPI.h"
#include "LSM.h"
#include "USART.h"



int main(void){
	//Set up code
	Change_CLK_32HZ();
	USART_INIT();
	spi_init();
	gyro_init();
	accel_init();
	
	PMIC.CTRL = 0x07;
	sei();
	
	while(TRUE){
		if(accelDataReady){
			READ_DATA_ACCEL();
		}
		if(gyroDataReady){
			READ_DATA_GYRO();
		}
		DISPLAY_GYROACCEL_INFO();
	}
	    
}