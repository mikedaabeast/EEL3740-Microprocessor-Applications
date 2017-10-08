/*
Name: Michael Arboleda
Section #: 7F34
TA Name: Wesley Piard
Description: LMS functions

LMS.c
Created: 7/18/2017 1:17:10 AM
*/

#include <avr/io.h>
#include <avr/interrupt.h>
#include "USART.h"
#include "SPI.h"
#include "LSM330.h"


//include extern constants
extern const uint8_t PORTC_INTCTRL_CONFIG;
extern const uint8_t PORTC_INT0MASK_CONFIG;
extern const uint8_t PORTC_PIN7CTRL_CONFIG;
extern const uint8_t PORTA_INTCTRL_CONFIG;
extern const uint8_t PORTA_INT0MASK_CONFIG;
extern const uint8_t PORTA_PIN1CTRL_CONFIG;
//FLAGS
extern volatile uint8_t accelDataReady;
extern volatile uint8_t gyroDataReady;


//Set Global(THIS FILE) Variables
//COORDINATES
volatile uint8_t accel_xL = 0;
volatile uint8_t accel_xH = 0;
volatile uint8_t accel_yL = 0;
volatile uint8_t accel_yH = 0;
volatile uint8_t accel_zL = 0;
volatile uint8_t accel_zH = 0;
volatile uint8_t gyro_xL = 0;
volatile uint8_t gyro_xH = 0;
volatile uint8_t gyro_yL = 0;
volatile uint8_t gyro_yH = 0;
volatile uint8_t gyro_zL = 0;
volatile uint8_t gyro_zH = 0;



/*********************Function**************************************
; Function Name: LSM_READ
; Inputs: uint8_t:=SS_choice, uint8_t:=reg
; Outputs: uint8_:=spiRead()
*/
uint8_t LSM_READ(uint8_t SS_choice, uint8_t reg){
	//IF GYRO
	if(SS_choice == 0){
		PORTF.OUTCLR = PIN2_bm;	//SENSOR_SEL
		PORTF.OUTCLR = PIN4_bm; //SSG
	}
	//ELSE IF accelerometer
	else if(SS_choice == 1){
		PORTF.OUTSET = PIN2_bm;	//SENSOR_SEL
		PORTF.OUTCLR = PIN3_bm;	//SSA
	}
	
	//Address OR with READ CYCLE enable
	spiWrite( (reg | PIN7_bm) );
	uint8_t result = spiRead();
	
	//IF GYRO
	if(SS_choice == 0){
		PORTF.OUTSET = PIN4_bm;	//SSG
	}
	//ELSE IF accelerometer
	else if(SS_choice == 1){
		PORTF.OUTSET = PIN3_bm;	//SSA
	}
	
	//return from function
	return(result);
}



/*********************Function**************************************
; Function Name: LSM_WRITE
; Inputs: uint8_t:=SS_choice, uint8_t:=reg, uint8_t:=reg_data
; Outputs: No direct outputs
*/
void LSM_WRITE(uint8_t SS_choice, uint8_t reg, uint8_t reg_data){
	//IF GYRO
	if(SS_choice == 0){
		PORTF.OUTCLR = PIN2_bm;	//SENSOR_SEL
		PORTF.OUTCLR = PIN4_bm; //SSG
	}
	//ELSE IF accelerometer
	else if(SS_choice == 1){
		PORTF.OUTSET = PIN2_bm;	//SENSOR_SEL
		PORTF.OUTCLR = PIN3_bm;	//SSA
	}
	
	//Write reg address then data
	spiWrite(reg);
	spiWrite(reg_data);
	
	//IF GYRO
	if(SS_choice == 0){
		PORTF.OUTSET = PIN4_bm;	//SSG
	}
	//ELSE IF accelerometer
	else if(SS_choice == 1){
		PORTF.OUTSET = PIN3_bm;	//SSA
	}
	
	//return from function
	return;
}



/*********************Function**************************************
; Function Name: accel_init
; Inputs: No direct inputs
; Outputs: No direct outputs
*/
void accel_init(void){
	//Set up interrupt
	PORTC.DIRCLR = PIN7_bm;
	PORTC.INTCTRL = PORTC_INTCTRL_CONFIG;
	PORTC.INT0MASK = PORTC_INT0MASK_CONFIG;
	PORTC.PIN7CTRL = PORTC_PIN7CTRL_CONFIG;

	// route the DRDY signal to INT1_A and enable
	//INT1 with a rising edge (active high)
	LSM_WRITE(1, CTRL_REG4_A, 0xC8);
	
	//configure the accelerometer to have the highest
	//possible output data rate as well as enable the X, Y,
	//and Z axes.
	LSM_WRITE(1, CTRL_REG5_A, 0x97);
	
	//return from function
	return;
}



/*********************Function**************************************
; Function Name: gyro_init
; Inputs: No direct inputs
; Outputs: No direct outputs
*/
void gyro_init(void){
	//Set up interrupt
	PORTA.DIRCLR = PIN1_bm;
	PORTA.INTCTRL = PORTA_INTCTRL_CONFIG;
	PORTA.INT0MASK = PORTA_INT0MASK_CONFIG;
	PORTA.PIN1CTRL = PORTA_PIN1CTRL_CONFIG;
	
	//GYRO_ENABLE bit on PORTA
	PORTA.OUTSET = PIN3_bm;
	
	//configure the gyroscope to have the highest possible
	//output data rate as well as enable the X, Y, and Z axes.
	LSM_WRITE(0, CTRL_REG1_G, 0xCF);
	
	//Set the I2_DRDY bit
	LSM_WRITE(0, CTRL_REG3_G, 0x08);
	
	// Choose 2000 dps for the full-scale selection bits
	LSM_WRITE(0, CTRL_REG4_G, 0x30);

	//Return from function
	return;
}



/*********************ISR**************************************
; Interrupt Type: PORTA_INT0_vect
; Inputs: No direct inputs
; Outputs: No direct outputs
*/
ISR(PORTA_INT0_vect){
	//Preserve Status Reg
	uint8_t temp = CPU_SREG;

	//Set int flags
	PORTA.INTFLAGS = 0x01;

	//Set global var flag
	gyroDataReady = 0x01;
	
	//Restore Status Reg
	CPU_SREG = temp;
	
	//Return from function
	return;
}



/*********************ISR**************************************
; Interrupt Type: PORTC_INT0_vect
; Inputs: No direct inputs
; Outputs: No direct outputs
*/
ISR(PORTC_INT0_vect){
	//Preserve Status Reg
	uint8_t temp = CPU_SREG;

	//Set int flags
	PORTC.INTFLAGS = 0x01;

	//Set global var flag
	accelDataReady = 0x01;
	
	//Restore Status Reg
	CPU_SREG = temp;
	
	//Return from function
	return;
}



/*********************Function**************************************
; Function Name: DISPLAY_GYROACCEL_INFO
; Inputs: No direct inputs
; Outputs: No direct outputs
*/
void DISPLAY_GYROACCEL_INFO(void){
	//Transmit start byte as seen in example
	OUT_CHAR(0x03);
	
	//OUT CHAR ACCEL DATA
	OUT_CHAR(accel_xL);
	OUT_CHAR(accel_xH);
	OUT_CHAR(accel_yL);
	OUT_CHAR(accel_yH);
	OUT_CHAR(accel_zL);
	OUT_CHAR(accel_zH);
	
	//OUT_CHAR GYR0 DATA
	OUT_CHAR(gyro_xL);
	OUT_CHAR(gyro_xH);
	OUT_CHAR(gyro_yL);
	OUT_CHAR(gyro_yH);
	OUT_CHAR(gyro_zL);
	OUT_CHAR(gyro_zH);
	
	//OUT_CHAR ~0xFC
	OUT_CHAR(0xFC);
	
	//Return from function
	return;
}



/*********************Function**************************************
; Function Name: READ_DATA_ACCEL
; Inputs: No direct inputs
; Outputs: No direct outputs
*/
void READ_DATA_ACCEL(void){
	//Read accel data
	accel_xL = LSM_READ(1, OUT_X_L_A);
	accel_xH = LSM_READ(1, OUT_X_H_A);
	accel_yL = LSM_READ(1, OUT_Y_L_A);
	accel_yH = LSM_READ(1, OUT_Y_H_A);
	accel_zL = LSM_READ(1, OUT_Z_L_A);
	accel_zH = LSM_READ(1, OUT_Z_H_A);
	
	//Reset accel global flag
	accelDataReady = 0;

	//Return from function
	return;
}



/*********************Function**************************************
; Function Name: READ_DATA_GYRO
; Inputs: No direct inputs
; Outputs: No direct outputs
*/
void READ_DATA_GYRO(void){
	//Read Gyro data
	gyro_xL = LSM_READ(0, OUT_X_L_G);
	gyro_xH = LSM_READ(0, OUT_X_H_G);
	gyro_yL = LSM_READ(0, OUT_Y_L_G);
	gyro_yH = LSM_READ(0, OUT_Y_H_G);
	gyro_zL = LSM_READ(0, OUT_Z_L_G);
	gyro_zH = LSM_READ(0, OUT_Z_H_G);
	
	//Reset gyro global flag
	gyroDataReady = 0;

	//Return from function
	return;
}



void CLR_GYRO(void){
	
	//STORE GYRO info
	gyro_xH = LSM_READ(0, OUT_X_H_G);
	gyro_xL = LSM_READ(0, OUT_X_L_G);
	gyro_yH = LSM_READ(0, OUT_Y_H_G);
	gyro_yL = LSM_READ(0, OUT_Y_L_G);
	gyro_zH = LSM_READ(0, OUT_Z_H_G);
	gyro_zL = LSM_READ(0, OUT_Z_L_G);

	//Return from function
	return;
}