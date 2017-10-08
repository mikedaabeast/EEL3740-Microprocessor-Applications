; Lab 1 Part C
; Name:		Michael Arboleda
; Section:	7F34
; TA Name:	Wesley Piard
; Description: Toggles LED based on time 
;
; lab1c.asm
; Created: 5/23/2017 2:29:17 AM

.include "ATxmega128A1Udef.inc"

;Stack Pointer location
.equ stack_init = 0x2FFF	;initialize stack pointer 
				;(between 0x2000 & 0x3FFF)

; Constant equates
.equ button_PF2 = 0b11111101; 1 bit on
.equ multi = 1				; Multiplier for 10ms 

.ORG 0x0000			;Code starts running from address 0x0000.
	rjmp MAIN		;Relative jump to start of program.

.ORG 0x0100		;Start program at 0x0100 so we don't overwrite 
				;  vectors that are at 0x0000-0x00FD 
MAIN:
	
	;Load constants
	ldi r16, 0xFF			; LOAD r16 with FF
	ldi r17, 0x00			; LOAD r17 with 0
	ldi r18, button_PF2		; LOAD r18 with LED data
	ldi r20, multi			; LOAD r19 with multiplier

;While loop
WHILE: 
	;Display Toggle off
	sts PORTC_DIRSET, r16		; Set to write
	sts PORTC_OUT, r16	; LED data to be displayed (LEDS off)
	
	call DELAYx10ms			; Call Delay X subroutine 
	
	;Display 
	sts PORTC_OUT, r18	; LED data to be displayed (1 LED on)
	
	call DELAYx10ms			; Call Delay X subroutine
	rjmp WHILE			; Restart loop to rerun program



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


FOR_IF:
	cpi r2_delay, 0x00		; COMPARE higher word with 0
	brne  BODY_LOOP			; if not 0, jump to loop body
	cpi r1_delay, 0x00		; COMPARE lower word with 0
	brne  BODY_LOOP			; if not 0, jump to loop body
	; Since counter is 0, end loop
	rjmp END_FOR			; JUMP to end of loop

BODY_LOOP:
	sbiw r2_delay:r1_delay, 1	; Subtract 1 from r25:r24	
	rjmp FOR_IF			; JUMP back to condition check

END_FOR:
	
	pop r2_delay				; POP r21 from stack
	pop r1_delay				; POP r21 from stack
	ret					; return from subroutine
.undef r2_delay
.undef r1_delay


;---------------------------------------------------------------------;
;*********************SUBROUTINES**************************************
; Subroutine Name: DELAYx10ms,
;	Delays by 10ms times a multiplier 
; Inputs: r20
; Outputs: No direct outputs
; Affected: r19, r27

.def multiplier = r20		
DELAYx10ms:
	push multiplier			; PUSH r20
	ldi r19, 1			; LOAD r19 with 1

;FOR_INT
	ldi r27, 0;			; LOAD r27 with 0

DxFOR_IF:
	cp r27, multiplier	; COMPARE r27 and the Multiplier
	breq DxEND_FOR		; If r27 = multiplier then end loop
	
;FOR BODY	
	call DELAY_10ms		; Call DELAY_10ms to delay by 10ms
;Update	
	add r27, r19		; increment r27 by 1
	rjmp DxFOR_IF		; jump to conditional check
DxEND_FOR:
	pop multiplier
	ret
.undef multiplier