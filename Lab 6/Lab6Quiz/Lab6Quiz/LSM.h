#ifndef LMS_H_
#define LMS_H_

/*
Name: Michael Arboleda
Section #: 7F34
TA Name: Wesley Piard
Description: Header for LMS.c

LMS.h
Created: 7/18/2017 1:18:03 AM
*/ 

//Function Prototype

uint8_t LSM_READ(uint8_t SS_choice, uint8_t reg);
void LSM_WRITE(uint8_t SS_choice, uint8_t reg, uint8_t reg_data);
void accel_init(void);
void gyro_init(void);
//void DISPLAY_GYROACCEL_INFO(void);
void READ_DATA_ACCEL(void);
//void READ_DATA_GYRO(void);
void CLR_GYRO(void);
void DISPLAY_PER_AXIS(void);


#endif /* LMS_H_ */