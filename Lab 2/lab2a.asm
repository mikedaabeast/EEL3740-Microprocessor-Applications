; Lab 2 Part A
; Name:		Michael Arboleda
; Section:	7F34
; TA Name:	Wesley Piard
; Description: Changes clock frequency of up
;
; lab2a.asm
; Created: 5/21/2017 3:34:53 PM

.include "ATxmega128A1Udef.inc"

; address equates

; Constant equates
.equ new_clock_freq = 0b00000010 
.equ div_value = 0b00001100
.equ CLKEVOUT_config = 0b00000001

.ORG 0x0000			;Code starts running from address 0x0000.
	rjmp MAIN		;Relative jump to start of program.

MAIN: 
	call Change_CLK_4HZ
Never_End:
	rjmp Never_End


;*********************SUBROUTINES**************************************	
; Subroutine Name: Change_CLK_4HZ
; 
; Inputs: No direct input (from stack)
; Outputs: No direct outputs
; Affected: R17, R18, R19, R20
Change_CLK_4HZ:

; Enable the new oscillator
ldi R16, new_clock_freq		; Load R16 with the clk-freq config 0x02
sts OSC_CTRL, r16		; Set the clk config

;Wait for the right flag to be set in the OSC_STATUS reg 

; While flag is not set
While_32_flag:
	lds R17, OSC_STATUS		; Load Status Flag
	and R17, R16			; Bit-mask with 00000010
	cp R17, R16			; Compare Mask and Value
	brne While_32_flag		; Restart loop if flag not set

; Write the “IOREG” signature to the CPU_CCP reg
	ldi R17, CCP_IOREG_gc	; Load IOREG into R17
	sts CPU_CCP, R17	; Store IOREG into CPU CCP

;Select the new clock source in the CLK_CTRL reg
	ldi R17, CLK_SCLKSEL_RC32M_gc; load 32 MHz internal osc config
	sts CLK_CTRL, R17		; Store config in clk control

;Set Prescalars
	; Write the “IOREG” signature to the CPU_CCP reg
	ldi R17, CCP_IOREG_gc	; Load IOREG into R17
	ldi R18, div_value	; Load divide config into r18
	sts CPU_CCP, R17	; Store IOREG into CPU_CPP
	
	; Set Prescalar 
	sts CLK_PSCTRL, R18		; Store Prescaler config

;Set clock to port c
	ldi R20, 0xFF
	sts PORTC_DIRSET, R20
	
	ldi R19, CLKEVOUT_config	; Set CLKEVOUT config
	sts PORTCFG_CLKEVOUT, R19	; MAke clock output 
	ret