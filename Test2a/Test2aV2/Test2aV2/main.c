/*

Test2a.c
Created: 8/1/2017 9:35:13 AM
*/

#include <avr/io.h>
#include <avr/interrupt.h>
#include "constants.h"
#include "Clk_32MHz.h"
#include "USART.h"
#include "SPI.h"
#include "LSM.h"
#include "LSM330.h"
#include "PULSE.h"

int main(void){
	//Set up code
	Change_CLK_32HZ();
	USART_INIT();
	spi_init();
	accel_init();
	gyro_init();
	PWM_setup();
	
	//Set up interrupts
	PMIC.CTRL = 0x07;
	sei();

	//Clear data in Gyro
	CLR_GYRO();
	
	//TURN ON LED
	PORTD_DIRSET = (PIN4_bm | PIN5_bm | PIN6_bm);
	PORTD_OUTSET =  0x50;
	
	//WHILE(1)
	while(TRUE){
		//IF accel data is ready
		if(accelDataReady){
			READ_DATA_ACCEL();
			DISPLAY_PER_AXIS();
		}
	}
}