; Lab 1 Part D
; Name:		Michael Arboleda
; Section:	7F34
; TA Name:	Wesley Piard
; Description: Displays LED in KITT pattern
;
; lab1d.asm
; Created: 5/23/2017 11:09:32 PM

.include "ATxmega128A1Udef.inc"

.equ table_size = 9		;Size of table

.ORG 0x0000			;Code starts running from address 0x0000.
	rjmp MAIN		;Relative jump to start of program.

.CSEG					;Code segment start 
	.ORG 0xF000			; Start table address

KITT_Table: 
	.db 0b01111111, 0b00111111, 0b10011111, 0b11001111,\
		0b11100111, 0b11110011, 0b11111001, 0b11111100,\
		0b11111110 ; Table Values
.DSEG					;Code segment stop

.CSEG
.ORG 0x0100		;Start program at 0x0100 so we don't overwrite 
			;  vectors that are at 0x0000-0x00FD 
MAIN:

; Set up constant regs
ldi R16, 1				; LOAD r16 with 1
ldi r18, 0xFF				; LOAD r18 with 0xFF

WHILE: 
; Set up z?register 						 
sts CPU_RAMPZ, R16			;STORING Extended Address 
ldi ZL, low( KITT_Table << 1)		;LOAD adrs to read from?low bits 
ldi ZH, high ( KITT_Table << 1)		;LOAD adrs to read from?high bits

; Set up regs
ldi r17, 0					; LOAD r17 with 0

; Set leds to write
sts PORTC_DIRSET, r18			; Set to write

FOR_IF:
	cpi r17, table_size	; COMPARE r17 and size of data table
	breq END_FOR		; if r17 = size, end loop
;FOR BODY 
	;Load LED data
	elpm r19,  z+		; LOAD From Table, increment z pointer
	
	; LED Blinking
	sts PORTC_OUT, r19		; Display LEDs (on)
	call DELAY_10ms			; Delay by 10ms
	sts PORTC_OUT, r18		; Display LEDs (off)
	call DELAY_10ms			; Delay by 10ms
	sts PORTC_OUT, r19		; Display LEDs (on)
	call DELAY_10ms			; Delay by 10ms
	sts PORTC_OUT, r18		; Display LEDs (off)
	call DELAY_10ms			; Delay by 10ms
	sts PORTC_OUT, r19		; Display LEDs (on)
	call DELAY_10ms			; Delay by 10ms 
;UPDATE
	add r17, r16			; ADD 1 and r17 (r17 = r17 + 1)
	rjmp FOR_IF			; JUMP to conditional statement
END_FOR: 
	rjmp WHILE			; JUMP to restart program


;---------------------------------------------------------------------;
;						SUBROUTINES									  ;
;---------------------------------------------------------------------;
;*********************SUBROUTINES**************************************
; Subroutine Name: DELAY_10ms
;	Delays by 10 ms
; Inputs: No direct input (from stack)
; Outputs: No direct output
; Affected: No register affected 

.def r1_delay = r24
.def r2_delay = r25
DELAY_10ms: 
	push r1_delay			; Push r24
	push r2_delay			; Push r25

	
;FOR_INT none	
	ldi r1_delay, 0x07		; LOAD lower word with 0x07				
	ldi r2_delay, 0x0B		; LOAD higher word with 0x0B


DFOR_IF:
	cpi r2_delay, 0x00		; COMPARE higher word with 0
	brne  BODY_LOOP			; if not 0, jump to loop body
	cpi r1_delay, 0x00		; COMPARE lower word with 0
	brne  BODY_LOOP			; if not 0, jump to loop body
	; Since counter is 0, end loop
	rjmp DEND_FOR			; JUMP to end of loop

BODY_LOOP:
	sbiw r2_delay:r1_delay, 1	; Subtract 1 from r25:r24	
	rjmp DFOR_IF			; JUMP back to condition check

DEND_FOR:
	
	pop r2_delay				; POP r21 from stack
	pop r1_delay				; POP r21 from stack
	ret					; return from subroutine
.undef r2_delay
.undef r1_delay