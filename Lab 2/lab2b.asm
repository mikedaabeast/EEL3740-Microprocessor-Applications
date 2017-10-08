; Lab 2 Part B
; Name:		Michael Arboleda
; Section:	7F34
; TA Name:	Wesley Piard
; Description: Test Timer/Counter on uPad
;
; lab2b.asm
; Created: 6/6/2017 4:56:30 AM 

.include "ATxmega128A1Udef.inc"

; address equates

; Constant equates
.equ clk_div = 0b00000111

.ORG 0x0000			;Code starts running from address 0x0000.
	rjmp MAIN		;Relative jump to start of program.

MAIN:
	ldi R16, 0xFF		; LOAD 0xFF into R16
	ldi R17, 0x00		; LOAD 0x00 into R17
	ldi R18, clk_div	; LOAD Clk prescaler into R18
	
	sts PORTF_DIRSET, R16	; Set Port F to write
	
	sts TCF0_PER, R16	; Set Lower Bits of TOP
	sts (TCF0_PER + 1), R17 ; Set Higher Bits of TOP

	sts TCF0_CTRLA, R18	; Set Prescalar for Counter 
	
Never_End:	
	lds R19, TCF0_CNT; LOAD the data from memory 
							;to r19
	sts PORTF_OUT, 	R19	; Output counter value

	rjmp Never_End		; Jump to restart output loop