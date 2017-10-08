/* Lab6 Part F
Name: Michael Arboleda
Section #: 7F34
TA Name: Wesley Piard
Description: Output data for accel
	and gyro

Lab6f.c
Created: 7/18/2017 12:47:12 AM
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
		}
		
		//IF Gyro data is ready
		if(gyroDataReady){
			READ_DATA_GYRO();
		}
		
		//Display data through USART
		DISPLAY_GYROACCEL_INFO();
	}
		
	// Return with status 0		
	return 0;
}