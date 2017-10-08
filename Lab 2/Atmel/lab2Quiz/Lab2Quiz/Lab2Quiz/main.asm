;
; Lab2Quiz.asm
; Created: 6/7/2017 5:14:04 PM

.include "ATxmega128A1Udef.inc"

; Constant equates
.equ button_PF2 = 0b00000100	; Configuration for S1
.equ new_clock_freq = 0b00000010 
.equ clk_div = 0b00000110
.equ counter_check_Red = 0x00
.equ counter_check_Green = 0x00
.equ counter_check_Blue = 0x00
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

.ORG 0x0100		;Start program at 0x0100 so we don't overwrite 
			;  vectors that are at 0x0000-0x00FD 
MAIN: 
	; Run at 32MHz
	call Change_CLK_32HZ		; Change Clk to 32MHz

	; set up button
	ldi r16, 0x00		; LOAD r16 with 0
	ldi r17, button_PF2	; Set bitmask 0000 0100 in r17 

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


; Set up Counter
	ldi R20, 0x0F		; LOAD 0xFF into R20
	ldi R21, 0x00		; LOAD 0x00 into R21
	ldi R22, clk_div	; LOAD Clk prescaler into R22

	sts TCF0_PER, R20		; Set Lower Bits of TOP
	sts (TCF0_PER + 1), R21 ; Set Higher Bits of TOP

	sts TCF0_CTRLA, R22		; Set Prescalar for Counter 

	; Set PORT D for output
	ldi R16, BIT456			;load a four bit value (PORTD is only four bits)
	sts PORTD_DIRSET, R16	;set all the GPIO's in the four bit PORTD as outputs
	ldi R16, 0b01110000
	sts PORTD_OUT, r16
	ldi R16,0x00
WHILE: 
	; Check if Button Pressed
	sts PORTF_DIRCLR, r16	; Set to write
	lds r24, PORTF_IN		; LOAD Port F into r19
	and r24, r17			; Isolate bit 2 in r19 		
;IF
	cp r24, r17				; COMPARE r19 to r17 bitmask
	breq END_IF1			; BRANCH if not equal to each other
	ldi R23, 0x00			; LOAD 0 to r21
	sts PORTA_DIRCLR, R23	; Set to read 
	lds R23, PORTA_IN
	andi R23, 0b00001111

	; 
END_IF1:

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	lds R19, TCF0_CNT; LOAD the counter value 
					
	; If 0, turn on
	cpi R19, 0x00		; Compare counter value with 0
	brne IF_Green			; If not 0, jmp to red check
	; Turn light on
	;if switch data 0
	cpi R23, 0x00
	breq IF_Green
	ldi R18, GREEN		; LOAD white LED config
	sts PORTD_OUT, R18	; Output LED config
	
IF_Green:
	cp r19, R23				; Compare counter to red max time value
	brne END_IF2				; If not equal, End check
	; Turn GREEN LED off
	ldi R20, GREEN_OFF			; Load Red_OFF config
	lds R21, PORTD_OUT			; Load Port D values
	or R21, R20					; OR Red_OFF config with Port D values 
	sts PORTD_OUT, R21			; Output LED config

END_IF2:
	

	rjmp WHILE









































;*********************SUBROUTINES**************************************	
; Subroutine Name: Change_CLK_32HZ
; 
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
	cp R17, R16				; Compare Mask and Value
	brne While_32_flag		; Restart loop if flag not set

; Write the “IOREG” signature to the CPU_CCP reg
	ldi R17, CCP_IOREG_gc	; Load IOREG into R17
	sts CPU_CCP, R17		; Store IOREG into CPU CCP

;Select the new clock source in the CLK_CTRL reg
	ldi R17, CLK_SCLKSEL_RC32M_gc		; load 32 MHz internal osc config
	sts CLK_CTRL, R17					; Store config in clk control
	
	;Pop Values
	pop R20	; POP r20 from stack 
	pop R19 ; POP r19 from stack
	pop R18 ; POP r18 from stack
	pop R17 ; POP r17 from stack
	
	ret 