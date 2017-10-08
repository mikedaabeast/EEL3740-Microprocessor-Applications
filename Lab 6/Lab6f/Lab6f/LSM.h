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
void init_interrupt(void);
/*
uint8_t LSM_READ(uint8_t SS_choice, uint8_t reg);
void LSM_WRITE(uint8_t SS_choice, uint8_t reg, uint8_t reg_data);
void RESET_LSM(void);
void accel_init(void);
void gyro_init(void);
*/

uint8_t LSM_READ(uint8_t SS, uint8_t REG);
void LSM_WRITE(uint8_t SS, uint8_t REG, uint8_t DATA);

void READ_DATA_ACCEL(void);
void READ_DATA_GYRO(void);
void DISPLAY_GYROACCEL_INFO(void);



#endif /* LMS_H_ */