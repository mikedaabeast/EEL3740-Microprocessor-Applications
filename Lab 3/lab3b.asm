; Lab 3 Part B
; Name:		Michael Arboleda
; Section:	7F34
; TA Name:	Wesley Piard
; Description: 
;
; lab3b.asm



.include "ATxmega128A1Udef.inc"

; address equates

; Constant equates
.equ BIT456 = 0x70
.equ new_clock_freq = 0b00000010
.equ port_map_config = 0b00000100
.equ ctrlb_config	= 0b01000011
.equ PORTD_PIN_CTRL = 0b01000000
.equ MAX_PERIOD = 0xFF
.equ BLUE_PERIOD = 0x0F
.equ clk_div = 0b00000111
;------------------------------;
.equ intr_crtl_lvl_config = 0b00000011	; 0x03
.equ button_PF2 = 0b00000100			; 0x04
.equ PORTF_PIN2_CONFIG = 0b00010000		; 0x10
.equ PMIC_crtl_lvl_config = 0b00000100  ; 

;
.def external_counter = R20

.ORG PORTF_INT0_vect
	rjmp inc_display
.ORG 0x0000			;Code starts running from address 0x0000.
	rjmp MAIN		;Relative jump to start of program.

MAIN:
	;
	ldi external_counter, 0x00 

	; Run at 32MHz
	call Change_CLK_32HZ	; Change Clk to 32MHz

	call BLUE_PWM			; Run bluw pulse

	; Set PORT F
	ldi R16, 0xFF			; LOAD r16 with FF
	sts PORTF_DIRCLR, r16	; Set to write
	
	; Set Port C
	ldi R21, 0xFF			; LOAD FF to r21
	sts PORTC_DIRSET, R21	; Set to write
	sts PORTC_OUT, R21

	; Set PORTF interupt control
	ldi R16, intr_crtl_lvl_config	; LOAD config into R16
	sts PORTF_INTCTRL, R16			; Set interupt control lvl config

	; Set PORT F MASK
	ldi R16, button_PF2			; LOAD 0b00000100 into R16
	sts PORTF_INT0MASK, R16		; Set intrerupt mask
	
	;
	ldi R16, PORT_ISC_FALLING_gc	; LOAD PFP2 config
	sts PORTF_PIN2CTRL, R16			; Set PFP2 config

	ldi R16, PMIC_crtl_lvl_config	; LOAD PMIC lvl config
	sts PMIC_CTRL, R16				; Set PMIC lvl config
	
	;
	sei


; infinite loop
Never_End:

	rjmp Never_End		; Jump to restart output loop


;*********************SUBROUTINES**************************************	
; Subroutine Name: Change_CLK_32HZ
; Inputs: No direct input (from stack)
; Outputs: No direct outputs
; Affected: None
Change_CLK_32HZ:
	;Push Values
	push R17 ; PUSH r17 to stack
	push R18 ; PUSH r18 to stack
	push R19 ; PUSH r19 to stack
	push R20 ; PUSH r20 to stack

; Enable the new oscillator
ldi R16, new_clock_freq		; Load R16 with the clk-freq config 0x02
sts OSC_CTRL, r16			; Set the clk config

;Wait for the right flag to be set in the OSC_STATUS reg 
; While flag is not set
While_32_flag:
	lds R17, OSC_STATUS		; Load Status Flag
	and R17, R16			; Bit-mask with 00000010
	cp R17, R16			; Compare Mask and Value
	brne While_32_flag		; Restart loop if flag not set

; Write the “IOREG” signature to the CPU_CCP reg
	ldi R17, CCP_IOREG_gc	; Load IOREG into R17
	sts CPU_CCP, R17		; Store IOREG into CPU CCP

;Select the new clock source in the CLK_CTRL reg
	ldi R17, CLK_SCLKSEL_RC32M_gc; load 32 MHz internal osc config
	sts CLK_CTRL, R17		; Store config in clk control
	
	;Pop Values
	pop R20	; POP r20 from stack 
	pop R19 ; POP r19 from stack
	pop R18 ; POP r18 from stack
	pop R17 ; POP r17 from stack
	ret 





;*********************SUBROUTINES**************************************	
; Subroutine Name:  BLUE_PWM
; Inputs: No direct input (from stack)
; Outputs: No direct outputs
; Affected: None
BLUE_PWM:
	;Push Values
	push R16 ; PUSH r17 to stack
	push R17 ; PUSH r17 to stack

	; Remap ports
	ldi R16, port_map_config	; Load port map config into R16
	sts PORTD_REMAP, R16		; LOAD port map config

	; Set PORT D/LED to output
	ldi R16, BIT456			;load a four bit value (PORTD is only four bits)
	sts PORTD_DIRSET, R16	;set all the GPIO's in the four bit 
							; PORTD as outputs

	; Invert Port D
	ldi R16, PORTD_PIN_CTRL ; LOAD PIN CTRL config
	sts PORTD_PIN0CTRL, R16	; Invert Pin 0 of Port D
	sts PORTD_PIN1CTRL, R16	; Invert Pin 1 of Port D
	sts PORTD_PIN2CTRL, R16	; Invert Pin 2 of Port D
	sts PORTD_PIN3CTRL, R16	; Invert Pin 3 of Port D
	sts PORTD_PIN4CTRL, R16	; Invert Pin 4 of Port D
	sts PORTD_PIN5CTRL, R16	; Invert Pin 5 of Port D
	sts PORTD_PIN6CTRL, R16	; Invert Pin 6 of Port D
	sts PORTD_PIN7CTRL, R16	; Invert Pin 7 of Port D

	; Set TOP of PWM
	ldi R16, MAX_PERIOD
	ldi R17, 0x00			; LOAD R17 with 0x00
	sts TCD0_PER, R16		; Set Lower Bits of TOP
	sts (TCD0_PER + 1), R17	; Set Higher Bits of TOP
		
	; Set up Control D
	sts TCD0_CTRLD, R17		; LOAD CTRLD with 0x00
	
	; Set up Control B
	ldi R17, ctrlb_config	; LOAD 0b01000011 into R17
	sts TCD0_CTRLB, R17		; Store contrl b config

	; Set up Compare Chanel
	ldi R16, BLUE_PERIOD	; LOAD r16 with blue time
	ldi R17, 0x00			; LOAD R17 with 0x00
	sts TCD0_CCC, R16		; LOAD compare chanel (lower)
	sts (TCD0_CCC + 1), R17 ; LOAD compare chanel (higher)


	;control a
	ldi R16, clk_div		; LOAD 0b00000111
	sts TCD0_CTRLA, R16		; store clk prescaler in ctrl A


	;Pop Values
	pop R17 ; POP r17 from stack
	pop R16 ; POP r16 from stack
	ret 


;*********************ISR**************************************	
; ISR Name: inc_display 
; Inputs: No direct input (from stack)
; Outputs: R20
; Affected: R21
inc_display:
	inc external_counter		; counter = counter + 1
	mov R21, external_counter	; LOAD FF to r21
	com R21						; Compliment R21
	sts PORTC_OUT, R21			; Display LED config 
	ldi R21,  0b00000001		; LOAD 0x01 into R21 
	sts PORTF_INTFLAGS, R21		; Clear Interupts flags
	reti						; return