; Lab 1 Part B
; Name:		Michael Arboleda
; Section:	7F34
; TA Name:	Wesley Piard
; Description: Fetchs data on a switches and stores it
;			in memory. Displays value in memory
;
; lab1b.asm
; Created: 5/21/2017 3:34:53 PM

.include "ATxmega128A1Udef.inc"

;Stack Pointer location
.equ stack_init = 0x2FFF	;initialize stack pointer (between 0x2000 & 0x3FFF)

; address equates 
.equ adrs_data_bank = 0x3744			; Address to store switch data
.equ adrs_subrout_display = 0x5000		; Address for display subroutine
.equ adrs_subrout_fetchStore = 0x6000	; Address for reading and storing subroutine

; Constant equates
.equ button_PF2 = 0b00000100			; Configuration for S1
.equ button_PF3 = 0b00001000			; Configuration for S2

.ORG 0x0000					;Code starts running from address 0x0000.
	rjmp MAIN				;Relative jump to start of program.

.ORG 0x0100					;Start program at 0x0100 so we don't overwrite 
	
							;  vectors that are at 0x0000-0x00FD 
MAIN: 
	ldi r16, 0x00			; LOAD r16 with 0
	ldi r17, button_PF2		; Set bitmask 0000 0100 in r17 
	ldi r18, button_PF3		; Set bitmask 0000 1000 in r18
	 

	;Set Stack Pointer
	ldi YL, low(stack_init)	; LOAD lower part of Stack Pointer
	out CPU_SPL, YL			; initialize low byte of stack pointer
	ldi YL, high(stack_init); LOAD higher part of Stack Pointer
	out CPU_SPH, YL			; initialize high byte of stack pointer
	 
	ldi r17, button_PF2		; Set bitmask 0000 0100 in r17 
	ldi r18, button_PF3		; Set bitmask 0000 1000 in r18

WHILE: 
	sts PORTF_DIRCLR, r16	; Set to write
	lds r19, PORTF_IN		; LOAD Port F into r19
	mov r20, r19			; Copy Port F data into r20
	and r19, r17			; Isolate bit 2 in r19 		
;IF
	cp r19, r17				; COMPARE r19 to r17 bitmask
	breq ELSEIF				; BRANCH if not equal to each other
	
	;IF-BODY
	call Fetch_Store		; CALL subroutine DISPLAY
	rjmp ENDIF
;ELSE IF
ELSEIF:	
	and r20, r18			; Isolate bit 3 in r20
	cp r20, r18				; COMPARE r20 to r18 bitmask
	breq ENDIF				; BRANCH if not equal to each other
	
	;ELSE IF-BODY
	call Display			; CALL subroutine Fetch_Store

ENDIF:
	rjmp WHILE				; Jump/Restart program


;---------------------------------------------------------------------;
;						SUBROUTINES									  ;
;---------------------------------------------------------------------;
;*********************SUBROUTINES**************************************
; Subroutine Name: Display
; 
; Inputs: No direct input (from stack)
; Outputs: No direct output 
; Affected: R21
.def r21_display = r21 
.ORG adrs_subrout_display				; Set subroutine to start at specified address
Display:
	push r21_display					; PUSH r21 to stack
	ldi r21_display, 0xFF				; LOAD FF to r21
	sts PORTC_DIRSET, r21_display		; Set to write
	lds r21_display,  adrs_data_bank	; LOAD the data from memory to r21
	sts PORTC_OUT, r21_display			; Display LED configuration based on r21 data
	pop r21_display						; POP r21 from stack 
	ret									; return from subroutine
.undef r21_display						; undefine r16_by_value


;*********************SUBROUTINES**************************************	
; Subroutine Name: Fetch_Store
; 
; Inputs: No direct input (from stack)
; Outputs: No direct outputs
; Affected: None
.def r21_fetch_store = r21
.ORG adrs_subrout_fetchStore			; Set subroutine to start at specified address
Fetch_Store:
	push r21_fetch_store				; PUSH r21 to stack
	ldi r21_fetch_store, 0x00			; LOAD 0 to r21
	sts PORTA_DIRCLR, r21_fetch_store	; Set to read 
	lds r21_fetch_store, PORTA_IN		; READ switches and store in reg
	sts adrs_data_bank, r21_fetch_store	; STORE values in 0x3744
	pop r21_fetch_store					; POP r21 from stack
	ret									; return from subroutine
.undef r21_fetch_store					; undefine r21_fetch_store