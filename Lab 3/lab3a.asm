; Lab 3 Part A
; Name:		Michael Arboleda
; Section:	7F34
; TA Name:	Wesley Piard
; Description: Use interuptx for LED
;
; lab3a.asm
; Created: 6/11/2017 1:48:59 AM

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

.ORG 0x0000			;Code starts running from address 0x0000.
	rjmp MAIN		;Relative jump to start of program.

MAIN:
	; Run at 32MHz
	call Change_CLK_32HZ	; Change Clk to 32MHz

	; Remap ports
	ldi R16, port_map_config	; Load port map config into R16
	sts PORTD_REMAP, R16		; LOAD port map config

	; Set PORT D/LED to output
	ldi R16, BIT456	 ;load a four bit value (PORTD is only four bits)
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