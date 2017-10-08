; Lab 2 Part C
; Name:		Michael Arboleda
; Section:	7F34
; TA Name:	Wesley Piard
; Description: Display Different colors on uPad LED
;
; lab2c.asm
; Created: 6/7/2017 3:36:05 AM

.include "ATxmega128A1Udef.inc"

; address equates

; Constant equates
.equ new_clock_freq = 0b00000010 
.equ clk_div = 0b00000110
.equ counter_check_Red = 0x00
.equ counter_check_Green = 0xFF
.equ counter_check_Blue = 0xFF
	; COLORS
.equ BIT4 = 0x10
.equ RED = ~(BIT4)
.equ RED_OFF = 0b00010000
.equ BIT5 = 0x20
.equ GREEN = ~(BIT5)
.equ GREEN_OFF = 0b00100000
.equ BIT6 = 0x40
.equ BLUE = ~(BIT6)
.equ BLUE_OFF = 0b01000000
.equ BIT456 = 0x70
.equ WHITE = ~(BIT456)


.ORG 0x0000			;Code starts running from address 0x0000.
	rjmp MAIN		;Relative jump to start of program.

MAIN:
	; Run at 32MHz
	call Change_CLK_32HZ	; Change Clk to 32MHz
	
	; Set up Counter
	ldi R16, 0xFF		; LOAD)0xFF into R16
	ldi R17, 0x00		; LOAD 0x00 into R17
	ldi R18, clk_div	; LOAD Clk prescaler into R18
	
	sts TCF0_PER, R16		; Set Lower Bits of TOP
	sts (TCF0_PER + 1), R17 	; Set Higher Bits of TOP

	sts TCF0_CTRLA, R18		; Set Prescalar for Counter 

	; Set PORT D for output
	ldi R16, BIT456	;load a four bit value (PORTD is only four bits)
	sts PORTD_DIRSET, R16 ;set all the GPIO's in the four bit 
				; PORTD as outputs

While_Loop:
	lds R19, TCF0_CNT; LOAD the counter value 
					
	; If 0, turn on
	cpi R19, 0x00		; Compare counter value with 0
	brne IF_RED		; If not 0, jmp to red check
	; Turn light on
	ldi R18, WHITE		; LOAD white LED config
	sts PORTD_OUT, R18	; Output LED config

IF_RED:
	cpi r19, counter_check_Red; Compare counter to red max time value
	brne IF_GREEN		; If not equal, jump to green check
	; Turn RED LED off
	ldi R20, RED_OFF	; Load Red_OFF config
	lds R21, PORTD_OUT	; Load Port D values
	or R21, R20		; OR Red_OFF config with Port D values 
	sts PORTD_OUT, R21	; Output LED config

IF_GREEN:		
	cpi r19, counter_check_Green; Compare counter to green max 
				;time value
	brne IF_BLUE		; If not equal, jump to Blue check
	; Turn GREEN LED off
	ldi R20, GREEN_OFF	; Load Green_OFF config
	lds R21, PORTD_OUT	; Load Port D values
	or R21, R20		; OR Green_OFF config with Port D values
	sts PORTD_OUT, R21	; Output LED config

IF_BLUE:		
	cpi r19, counter_check_Blue
	brne END_IF		; If not equal, jump to end of loop
	; Turn BLUE LED off
	ldi R20, BLUE_OFF	; Load Blue_OFF config
	lds R21, PORTD_OUT	; Load Port D values
	or R21, R20	; OR Blue_OFF config with Port D values
	sts PORTD_OUT, R21	; Output LED config

END_IF:
	rjmp While_Loop			; Jump to restart loop

	
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