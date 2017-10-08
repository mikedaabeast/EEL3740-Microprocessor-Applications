.include "ATxmega128A1Udef.inc"


; Constant equates
.equ table_size = 8						;Size of table
.equ button_PF2 = 0b00000100			; Configuration for S1
.equ button_PF3 = 0b00001000			; Configuration for S2

.ORG 0x0000					;Code starts running from address 0x0000.
	rjmp MAIN				;Relative jump to start of program.

.CSEG						;Code segment start 
	.ORG 0xF000				; Start table address

KITT_Table: 
	.db 0b01111111, 0b10111111, 0b11011111, 0b11101111,\
		0b11110111, 0b11111011, 0b11111101, 0b11111110,\
		0b11111101, 0b11111011, 0b11110111, 0b11101111,\
		0b11011111, 0b10111111, 0b01111111;
		
		; Table Values
.DSEG					;Code segment stop

.CSEG
.ORG 0x0100							;Start program at 0x0100 so we don't overwrite 
									;  vectors that are at 0x0000-0x00FD 
MAIN:

	ldi r16, 0x00			; LOAD r16 with 1
	ldi r17, button_PF2		; Set bitmask 0000 0100 in r17 
	ldi r18, button_PF3		; Set bitmask 0000 1000 in r18
	; R19 HOLDS DATA from buttons
	; R20 HOLDS data from table
	ldi r21, 0xFF
	ldi r22, 0x01	`		; counter
	ldi r23, 0x01			; LOAD CONSTANT 1

	; Set up z?register 						 
	sts CPU_RAMPZ, R23						;STORING Extended Address 
	ldi ZL, low( KITT_Table << 1)			;LOAD adrs to read from?low bits 
	ldi ZH, high ( KITT_Table << 1)			;LOAD adrs to read from?high bits

; Displaying 
	sts PORTC_DIRSET, r21					; Set to write

START:
	elpm r20,  z+				; LOAD From Table, increment z pointer
	sts PORTC_OUT, r20			; Display LED configuration based on r21 data

PRESS_START: 
	sts PORTF_DIRCLR, r16	; Set to write
	lds r19, PORTF_IN		; LOAD Port F into r19
	and r19, r18			; Isolate bit 2 in r19
	cp r19, r18				; COMPARE r19 to r17 bitmask
	breq PRESS_START		; BRANCH if not equal to each other
 	rjmp FOR_IF_F	
PLAY: 
	sts CPU_RAMPZ, R23						;STORING Extended Address 
	ldi ZL, low( KITT_Table << 1)			;LOAD adrs to read from?low bits 
	ldi ZH, high ( KITT_Table << 1)			;LOAD adrs to read from?high bits

FOR_IF_F:
.	 cpi r22, table_size;
	 breq FOR_END_F	
	
	;Display new data
	elpm r20,  z+				; LOAD From Table, increment z pointer
	sts PORTC_OUT, r20			; Display LED configuration based on r21 data
	call DELAY_10ms
		
	add r22, r23			; ADD 1 and r22 (r22 = r22 + 1)						
							; counter ++
	rjmp FOR_IF_F
		
FOR_END_F: 

	; Check if other player hit
	sts PORTF_DIRCLR, r16	; Set to write
	lds r19, PORTF_IN		; LOAD Port F into r19

	and r19, r17			; Isolate bit 3 in r20
	cp r19, r17				; COMPARE r20 to r18 bitmask
	breq RELOAD				; BRANCH if not equal to each other

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

FOR_IF_2:
	 cpi r22, 0x01;
	 breq FOR_END_2;
	
	;Display new data
	elpm r20,  z+				; LOAD From Table, increment z pointer
	sts PORTC_OUT, r20			; Display LED configuration based on r21 data
	call DELAY_10ms



	SUBI r22, 0x01
	rjmp FOR_IF_2
		
FOR_END_2: 

	; Check if other player hit
	sts PORTF_DIRCLR, r16	; Set to write
	lds r19, PORTF_IN		; LOAD Port F into r19

	and r19, r18			; Isolate bit 3 in r20
	cp r19, r18			; COMPARE r20 to r18 bitmask
	breq RELOAD				; BRANCH if not equal to each other
	rjmp PLAY
	; Set up z?register 						 
RELOAD:	
	sts CPU_RAMPZ, R23						;STORING Extended Address 
	ldi ZL, low( KITT_Table << 1)			;LOAD adrs to read from?low bits 
	ldi ZH, high ( KITT_Table << 1)			;LOAD adrs to read from?high bits
	ldi r22, 0x01	`						; counter
	rjmp START


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
	ldi r1_delay, low(20000)		; LOAD lower word with 0x07				
	ldi r2_delay, high(20000)		; LOAD higher word with 0x0B


DFOR_IF:
	cpi r2_delay, 0x00				; COMPARE higher word with 0
	brne  BODY_LOOP					; if not 0, jump to loop body
	cpi r1_delay, 0x00				; COMPARE lower word with 0
	brne  BODY_LOOP					; if not 0, jump to loop body
	; Since counter is 0, end loop
	rjmp DEND_FOR					; JUMP to end of loop

BODY_LOOP:
	sbiw r2_delay:r1_delay, 1			; Subtract 1 from r25:r24	
	rjmp DFOR_IF						; JUMP back to condition check

DEND_FOR:
	
	pop r2_delay						; POP r21 from stack
	pop r1_delay						; POP r21 from stack
	ret									; return from subroutine
.undef r2_delay
.undef r1_delay