; Lab 4 Part E
; Name:		Michael Arboleda
; Section:	7F34
; TA Name:	Wesley Piard
; Description: Revices/Transmit using interrupts
;
; lab4_serial_int.asm
; Created: 7/5/2017 12:22:26 AM

.include "ATxmega128A1Udef.inc" 

; address equates

; Constant equates
.equ new_clock_freq = 0b00000010
.equ TxRx_On = 0b00011000	; 0x18
.equ pin_Tx  = 0b00001000	; 0x08
.equ pin_Rx  = 0b00000100	; 0x04 
; asynch, 8 databits, odd parity, 1 start, and 1 stop
.equ usart_ctrl_C	= 0b00110011
; BSEL 576000 
.equ upper_BSEL		= 0b00000100
.equ BSEL			= 0b00110111
.equ BSCALE			= 0b10110000	; -5  BSCALE
.equ NULL			= 0x00			; Null character
.equ CR				= 0x0D			; Carriage Return
.equ LF				= 0x0A			; Line Feed
.equ low_int_lvl	= 0b00010000	; Low level interupt config
.equ PMIC_crtl_lvl_config = 0b00000111  ; 
.equ clk_div		= 0b00000111	; DIV1024
;Color
.equ BIT456 = 0x70
.equ WHITE = ~(BIT456)

; Reg Defs
.def char_out = R1

;ORG defs
.ORG 0x0000			;Code starts running from address 0x0000.
	rjmp MAIN		;Relative jump to start of program.

.org USARTD0_RXC_vect
	jmp USART_ISR

.org 0x0200

Test_String:
.db "Test for OUT_STRING", NULL

MAIN:

	call Change_CLK_32HZ	; Change Clk to 32MHx
	call USART_INIT			; Initilize USART
	
	ldi R16, PMIC_crtl_lvl_config	; LOAD PMIC lvl config
	sts PMIC_CTRL, R16				; Set PMIC lvl config
	
	sei


	; Set PORT D/LED to output
	ldi R16, BIT456			;load a four bit value (PORTD is only four bits)
	sts PORTD_DIRSET, R16	;set all the GPIO's in the four bit 
							; PORTD as outputs
	call Counter_INIT

; infinite loop
Never_End:
	lds R17, TCF0_CNT; LOAD the counter value 
	lds R18, (TCF0_CNT + 1)				
	
	cpi R18, 0x00		; Compare counter (higher) value with 0
	brne Never_END		; If not 0, restart loop
	cpi R17, 0x00		; Compare counter (lower) value with 0
	brne Never_End		; if not 0, resart loop
	; Turn light on
	ldi R18, BIT456 				; LOAD white LED config
	sts PORTD_OUTTGL, R18	; Output LED config

	rjmp Never_End		; Jump to restart output loop




;*********************SUBROUTINES**************************************	
; Subroutine Name:  Counter_INIT
; Inputs: No direct input (from stack)
; Outputs: No direct outputs
; Affected: None
Counter_INIT:
	
	push R16	; PUSH r16
	push R17	; PUSH r17
	push R18	; PUSH r18

	; Set up Counter 3D09
	ldi R16, 0x09		; LOAD 0x09 into R16
	ldi R17, 0x3D		; LOAD 0x3D into R17
	ldi R18, clk_div	; LOAD Clk prescaler into R18
	
	sts TCF0_PER, R16		; Set Lower Bits of TOP
	sts (TCF0_PER + 1), R17 	; Set Higher Bits of TOP

	sts TCF0_CTRLA, R18		; Set Prescalar for Counter
	
	pop R18		; POP r18
	pop R17		; POP r17
	pop R16		; POP r16
	ret



;*********************Interupt Service Routine**************************************	
; Subroutine Name:  USART_ISR
; Inputs: No direct input (from stack)
; Outputs: No direct outputs
; Affected: None
USART_ISR:
	push R16					; Push R16

	lds r1, USARTD0_DATA		; LOAD R1 with USART data
	lds R16, USARTD0_STATUS		; LOAD R16 with USART STATUS reg
	CBR  r16, 7					; Clear interrupt flag at bit 7
	sts USARTD0_STATUS, R16		; Store R16 into USART STATUS reg
	call OUT_CHAR				; Transmit char
	
	pop R16						; Pop R16	
	reti						; return





;*********************SUBROUTINES**************************************	
; Subroutine Name:  USART_INIT
; Inputs: No direct input (from stack)
; Outputs: No direct outputs
; Affected: None
USART_INIT:
	
	push R16				; Push R16

	ldi R16, pin_Tx			; Pin3 config 
	sts PortD_DIRSET, R16	; Set Pin3 to transmit
	sts PortD_OUTSET, R16	; Output High to Pin3


	ldi R16, pin_Rx			; Pin2 config
	sts PORTD_DIRCLR, R16	; Set Pin2 to recieve

	; Set Control A
	ldi R16, low_int_lvl	; LOAD r16 with interrupt config
	sts USARTD0_CTRLA, R16	; Set USART interrupt

	; Set Control B
	ldi R16, TxRx_On			; LOAD Tx and Rx config				
	sts USARTD0_CTRLB, R16		; Set Tx, Rx lines

	; Set Control C
	ldi R16, usart_ctrl_C		; LOAD CTRL config
	sts USARTD0_CTRLC, R16		; Set USART 

	; Set Baud Rate Ctrl B
	ldi R16, (BSCALE | upper_BSEL)	; OR BSCALE with 11:8 bit of BSEL
	sts USARTD0_BAUDCTRLB, R16		; Set BAUD CTRL B

	; Set Baud Rate Ctrl A
	ldi R16, BSEL					; LOAD 7:0 of BSEL in  R16
	sts USARTD0_BAUDCTRLA, R16		; Set BAUD CTRL A



	pop R16							; POP r16
	ret								; Return 



;*********************SUBROUTINES**************************************	
; Subroutine Name:  OUT_CHAR
; Inputs: R1
; Outputs: No direct outputs
; Affected: None
OUT_CHAR:
	push R16					; Push R16

Transfer_Complete:
	lds R16, USARTD0_STATUS		; LOAD status reg to R16
	sbrs R16, 5					; Skip jump if bit 5 is 1
	rjmp Transfer_Complete		; Restart Loop
	sts USARTD0_DATA, R1		; Output char thru USART

	pop R16						; POP R16
	ret							; Return

;*********************SUBROUTINES**************************************	
; Subroutine Name: OUT_STRING
; Inputs: No direct input (from stack)
; Outputs: No direct outputs
; Affected: None	
OUT_STRING:
	push R16	; Push R16

While_String:	
	lpm R16, Z+				; LOAD Z data and increment pointer
	cpi R16, NULL			; Compare Data and Null char
	breq End_While_String	; If data = null, branch to exit
	mov R1, R16				; move R16 Data to R1
	call OUT_CHAR			; Call OUT_CHAR
	jmp While_String		; Restart Loop

End_While_String:	 

	pop r16		; Pop R16 
	ret			; Return


;*********************SUBROUTINES**************************************	
; Subroutine Name:  IN_CHAR
; Inputs: No direct input (from stack)
; Outputs: No direct outputs
; Affected: None
IN_CHAR:
	
	push R16					; PUSH R16

Recieve_Complete:
	lds  R16, USARTD0_STATUS	; LOAD the status register
	sbrs R16, 7					; Skip jump if bit 7 is 1
	rjmp Recieve_Complete		; Restart Loop
	lds  R1, USARTD0_DATA		; LOAD data into R1

	pop R16						; POP r16
	ret							; Return



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