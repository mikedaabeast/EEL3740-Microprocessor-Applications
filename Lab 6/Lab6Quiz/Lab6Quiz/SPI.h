#ifndef SPI_H_
#define SPI_H_

/*
Name: Michael Arboleda
Section #: 7F34
TA Name: Wesley Piard
Description: Header for SPI 

SPI.h
Created: 7/17/2017 4:53:25 AM
*/ 


//Function Prototypes
void spi_init(void);
uint8_t spiWrite(uint8_t data);
uint8_t spiRead();


#endif /* SPI_H_ */