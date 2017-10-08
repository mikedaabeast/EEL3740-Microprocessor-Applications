;
; Test1a.asm
; Created: 6/15/2017 10:05:54 AM

; Constant equates
.equ new_clock_freq = 0b00000010
.equ intr_crtl_lvl_config = 0b00000011	; 0x03
.equ PMIC_crtl_lvl_config = 0b00000111  ; 
; Reg Defs

;ORG defs
.ORG PORTA_INT0_vect
	rjmp Change

.ORG 0x0000			;Code starts running from address 0x0000.
	rjmp MAIN		;Relative jump to start of program.


.org 0x0200
MAIN:
	ldi R16, PORT_ISC_FALLING_gc
	mov R4, R16
	ldi R16, PORT_ISC_RISING_gc
	mov R5,R16

	; Run at 32MHz
	call Change_CLK_32HZ	; Change Clk to 32MHz

	; Set Port C
	ldi R21, 0xFF			; LOAD FF to r21
	sts PORTC_DIRSET, R21	; Set to write
	sts PORTC_OUT, R21		; Turn off LEDS
	
	; Set Port A switches
	ldi R16, 0x00 
	sts PORTA_DIRCLR, R16	; Set to read
	ldi R16, 0x01

	lds R10, PORTA_IN			; Load Switches
	and R16, R10					; And with bitmask 0b00000001
	cpi R16, 0x01
	brne Else

;IF VCC
	ldi R16, PORT_ISC_FALLING_gc
	mov R6, R16
	ldi R20, 0x01
	mov r9, r20
	call BLINKING
	rjmp ENDIF
ELSE:
	ldi R16, PORT_ISC_RISING_gc
	mov R6, R16
	ldi R20, 0x00
	mov r9, r20
	ldi R17, 0b11111111
	sts PORTC_OUT, R17
ENDIF:

	call SET_PORTA_INT

	ldi R16, PMIC_crtl_lvl_config	; LOAD PMIC lvl config
	sts PMIC_CTRL, R16				; Set PMIC lvl config

	sei;


Never_End:
	; IF R9 = 0
	ldi R16, 0x01
	cp R9, R16
	brne other
	ldi R18, 0xFF
	call DELAYx10ms			; Call Delay X subroutine 
	sts PORTC_OUT, r18	; LED data to be displayed (1 LED on)
	call BLINKING
	call DELAYx10ms			; Call Delay X subroutine
	call restart	
other:
	ldi R18, 0xFF
	sts PORTC_OUT, r18	; LED data to be displayed (1 LED off)

restart:	
	rjmp Never_End



;*********************SUB**************************************	
; Subroutine Name: BLINKING
; Inputs: No direct input (from stack)
; Outputs: No direct outputs
; Affected: None
SET_PORTA_INT:

	; Set Port A switches
	ldi R16, 0x00 
	sts PORTA_DIRCLR, R16	; Set to read

	; Set PORTA interupt control
	ldi R16, intr_crtl_lvl_config	; LOAD config into R16
	sts PORTA_INTCTRL, R16			; Set interupt control lvl config

	; Set PORT  MASK
	ldi R16, 0b00000001			; LOAD 0b00000100 into R16
	sts PORTA_INT0MASK, R16		; Set intrerupt mask

	sts PORTA_PIN0CTRL, R6			; Set PFP2 config
	ret


;*********************ISR**************************************	
; Subroutine Name: 
; Inputs: No direct input (from stack)
; Outputs: No direct outputs
; Affected: None
Change:
	;Disable inter
	ldi R16, 0x00
	sts PORTA_INTCTRL, R16

;Check if Gnd	
	cp R6, R4		; PORT_ISC_FALLING_gc
	brne ELSE2
	;Turn LED OFF
	ldi R17, 0b11111111
	sts PORTC_OUT, R17
	ldi R20, 0x00
	mov r9, r20
	mov R6, R5	
	jmp end2
ELSE2:
	call BLINKING
	ldi R20, 0x01
	mov r9, r20 	
	mov R6, R4
end2:
	call SET_PORTA_INT
	reti

;*********************SUBROUTINES**************************************	
; Subroutine Name: BLINKING
; Inputs: No direct input (from stack)
; Outputs: No direct outputs
; Affected: None
BLINKING:
		ldi R17, 0b11111110
		sts PORTC_OUT, R17
	ret

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
DELAYx10MS: 
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