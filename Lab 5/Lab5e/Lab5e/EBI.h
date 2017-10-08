#ifndef EBI_H_
#define EBI_H_

/*
Name: Michael Arboleda
Section #: 7F34
TA Name: Wesley Piard
Description: Set up EBI

EBI.h 
Created: 7/10/2017 1:20:14 AM
 */
extern const uint8_t ebi_ctrl_config;
extern const uint8_t ebi_baseaddlL_config;
extern const uint8_t ebi_baseaddlH_config;
extern const uint8_t PORTH_CONFIG;
extern const uint8_t PORTK_CONFIG;


void EBI_INIT(void){
	// Set up EBI CTRL
	EBI.CTRL = ebi_ctrl_config;
	
	//Set up EBI CHIP 0 and base address
	EBI.CS0.CTRLA = ebi_ctrla_config;
	EBI.CS0.BASEADDRH = ebi_baseaddlH_config;
	EBI.CS0.BASEADDRL = ebi_baseaddlL_config;

	//Set up PORT H
	PORTH_DIRSET = PORTH_CONFIG;
	PORTH_OUTSET = PORTH_CONFIG; 
	
	//Set up PORT K
	PORTK_DIRSET = PORTK_CONFIG;

}




#endif /* EBI_H_ */