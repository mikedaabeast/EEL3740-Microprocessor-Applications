;
; lab3quiz.asm
;
; Created: 6/14/2017 5:00:31 PM

.include "ATxmega128A1Udef.inc"

; address equates

; Constant equates
.equ BIT456 = 0x70
.equ new_clock_freq = 0b00000010
.equ PORTD_PIN_CTRL = 0b01000000
.equ MAX_PERIOD = 0xFF
.equ clk_div = 0b00000111
;-----------------------------------------------;
.equ intr_crtl_lvl_config = 0b00000011	; 0x03
.equ button_PF2 = 0b00000100			; 0x04
.equ PORTA_PIN2_CONFIG = 0b00010000		; 0x10
.equ PMIC_crtl_lvl_config = 0b00000111  ; 
;-----------------------------------------------;
.equ clk_div_timer = 0b00000111
.equ delay_cycles = 0xFF
.equ delay_cycles_top = 0x00
.equ INTCTRLA_config = 0b00000011
;-----------------------------------------------;
.equ mod4 = 0b00000011
.equ port_map_config = 0b00000111
.equ ctrlb_config	= 0b01110011

.equ HULKP_RED = 0x8A
.equ HULKP_GREEN = 0x2C
.equ HULKP_BLUE = 0x9A

; Reg Defs
.def external_counter = R4
.def switcher_counter = R5
.def RED1_PERIOD = R23
.def GREEN1_PERIOD = R24
.def BLUE1_PERIOD = R25
.def RED2_PERIOD = R20
.def GREEN2_PERIOD = R21
.def BLUE2_PERIOD = R22

;ORG defs
.ORG PORTA_INT0_vect
	rjmp ext_int_logic

.ORG TCC0_OVF_vect
	rjmp overflow_logic

.ORG 0x0000			;Code starts running from address 0x0000.
	rjmp MAIN		;Relative jump to start of program.


.org 0x0200
MAIN:

	; Run at 32MHz
	call Change_CLK_32HZ	; Change Clk to 32MHz

	call PURPLE_PWM
	; Set PORT A
	ldi R16, 0xFF			; LOAD r16 with FF
	sts PORTA_DIRCLR, r16	; Set to write

	; Set Port C
	ldi R21, 0xFF			; LOAD FF to r21
	sts PORTC_DIRSET, R21	; Set to write
	ldi R16, 0b11111110
	sts PORTC_OUT, R16		; Turn off LEDS

	; Set PORTA interupt control
	ldi R16, intr_crtl_lvl_config	; LOAD config into R16
	sts PORTA_INTCTRL, R16			; Set interupt control lvl config

	; Set PORT F MASK
	ldi R16, 0b00000001			; LOAD 0b00000100 into R16
	sts PORTA_INT0MASK, R16		; Set intrerupt mask
	
	;
	ldi R16, PORT_ISC_RISING_gc	; LOAD PFP2 config
	sts PORTA_PIN0CTRL, R16			; Set PFP2 config

	ldi R16, PMIC_crtl_lvl_config	; LOAD PMIC lvl config
	sts PMIC_CTRL, R16				; Set PMIC lvl config

	sei;
Never_End:
	rjmp Never_End		; Jump to restart output loop







;*********************SUBROUTINES**************************************	
; Subroutine Name:  BLUE_PWM
; Inputs: No direct input (from stack)
; Outputs: No direct outputs
; Affected: None
PURPLE_PWM:
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

	; Set up Compare Chanel C
	ldi R16, 0x50
	sts TCD0_CCC, R16		; LOAD compare chanel (lower)
	ldi R16, 0x00
	sts (TCD0_CCC + 1), R16 ; LOAD compare chanel (higher)

	; Set up Compare Chanel B
	ldi R16, 0x00
	sts TCD0_CCB, R16		; LOAD compare chanel (lower)
	ldi R16, 0x00
	sts (TCD0_CCB + 1), R16 ; LOAD compare chanel (higher)

	; Set up Compare Chanel A
	ldi R16, 0x50
	sts TCD0_CCA, R16		; LOAD compare chanel (lower)
	ldi R16, 0x00
	sts (TCD0_CCA + 1), R16 ; LOAD compare chanel (higher)

	;control a
	ldi R16, clk_div		; LOAD 0b00000111
	sts TCD0_CTRLA, R16		; store clk prescaler in ctrl A

	;Pop Values
	pop R17 ; POP r17 from stack
	pop R16 ; POP r16 from stack
	ret















;*********************SUBROUTINES**************************************	
; Subroutine Name:  SET_COUNTER
; Inputs: No direct input (from stack)
; Outputs: No direct outputs
; Affected: None

SET_COUNTER:
	push R16	; PUSH r16 to stack
	push R17	; PUSH r17 to stack

	ldi r17, delay_cycles_top
	ldi r16, delay_cycles

	sts TCC0_PER, R16		; Set Lower Bits of TOP
	sts (TCC0_PER + 1), R17	; Set Higher Bits of TOP

	pop R17
	pop R16
	ret

;*********************SUBROUTINES**************************************	
; Subroutine Name:  SET_COUNTER_INT
; Inputs: No direct input (from stack)
; Outputs: No direct outputs
; Affected: None
SET_COUNTER_INT:
	push R16	; PUSH r16 to stack
	push R18	; PUSH r18 to stack
	
	ldi R16, INTCTRLA_config	; LOAD CTRLA config into R16
	sts TCC0_INTCTRLA, R16		; Set COUNTER for CTRLA 

	ldi R18, clk_div	; LOAD Clk prescaler into R18
	sts TCC0_CTRLA, R18		; Set Prescalar for Counter

	pop R18 ; Pop r18 from stack
	pop R16	; POP r16 from stack
	ret


;*********************ISR**************************************	
; ISR Name: overflow_logic
; Inputs: No direct input (from stack)
; Outputs: R20
; Affected: R21
overflow_logic:
	PUSH R16	; PUSH r16 to stack
	PUSH R17	; PUSH r17 to stack
	PUSH R19	; PUSH r19 to stack
	PUSH R21	; PUSH r21 to stack
;IF
	lds r19, PORTA_IN		; LOAD Port F into r19
	ldi r17, 0b00000001		; Set bitmask 0000 0100 in r17
	and r19, r17			; Isolate bit 2 in r19
	cp R19, R17
	brne ENDIF
;IF_BODY
	lds r19, PORTC_OUT
	com R19
	LSL R19
	
	cpi R19, 0x00
	brne Display	
	ldi R19, 0b00000001

Display:
	com R19	
	sts PORTC_OUT, R19		; Display LED config 
	
ENDIF:		

	;Disable Timer interrupt
	ldi R16, 0x00		; LOAD 0 into R16
	sts TCC0_INTCTRLA, R16	; Store 0 into INT CTRL A

	;Disable Timer 
	sts TCC0_CTRLA, R16	; Store 0 into INT CTRL A

	;Enable external interrupt
	ldi R16, intr_crtl_lvl_config	; LOAD config into R16
	sts PORTA_INTCTRL, R16			; Set interupt control lvl config

	;Clear Interupts flags
	ldi R21,  0b00000001		; LOAD 0x01 into R21 
	sts PORTA_INTFLAGS, R21		; Clear Interupts flags

	POP R21	; POP r21 from stack
	POP R19	; POP r19 from stack
	POP	R17	; POP r17 from stack
	POP R16	; POP r16 from stack
	reti	; Return from interrupt


;*********************ISR**************************************	
; ISR Name: ext_int_logic 
; Inputs: No direct input (from stack)
; Outputs: R20
; Affected: R21
ext_int_logic:
	
	push R16
	push R21
	
	; Disable external interrupt
	ldi R16, 0x00
	sts PORTA_INTCTRL, R16
	
	; Initialize Timer and Timer interrupt; 
	call SET_COUNTER	 ; Set the counter
	call SET_COUNTER_INT ; Set coinfig for overflow interrupt
	
	
	ldi R21,  0b00000001		; LOAD 0x01 into R21 
	sts PORTA_INTFLAGS, R21		; Clear Interupts flags

	pop R21 ; POP r21 from stack
	pop R16 ; POP r16 from stack
	reti

















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