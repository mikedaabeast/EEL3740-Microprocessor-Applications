; Lab 4 Part D
; Name:		Michael Arboleda
; Section:	7F34
; TA Name:	Wesley Piard
; Description: Revices/Transmit data for menu

; lab4_serial_menu.asm
; Created: 7/4/2017 6:15:54 PM

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

; Reg Defs
.def char_out = R1

;ORG defs
.ORG 0x0000			;Code starts running from address 0x0000.
	rjmp MAIN		;Relative jump to start of program.


.org 0x0200

Test_String:
.db "Test for OUT_STRING", NULL

Menu:
.db "Michael Arboleda's favorite:", LF, CR, 0x09, "1. Food", LF, CR,\
0x09, "2. Quote", LF, CR, 0x09, "3. Movie", LF, CR,\
0x09, "4. UF Course", LF, CR, 0x09, "5. Hobby", LF, CR,\
0x09, "6. Re-display menu", LF, CR, 0x09, "D: Done", LF, CR, NULL

Food:
.db "Michael Arboleda's favorite Food is steak", LF, CR, NULL

Quote:
.db "Michael Arboleda's favorite Quote is ", 0x22, "I know nothing!",\
0x22, " - Michael Scott", LF, CR, NULL

Movie: 
.db "Michael Arboleda's favorite Movie is Scott Pilgrim Vs. The World", LF, CR, NULL

UF_Course:
.db "Michael Arboleda's favorite UF Course is MAA4212, Advanced Calculus 2", LF, CR, NULL

Hobby: 
.db "Michael Arboleda's favorite Hobby is playing Xbox", LF, CR, NULL

Done:
.db "Done!", LF, CR, NULL
MAIN:

	call Change_CLK_32HZ	; Change Clk to 32MHx
	call USART_INIT			; Initilize USART
	
	ldi R20, 0x00			; LOAD R20 with 0

	call Display_Menu		; Transmit menu
	
	
; infinite loop
Never_End:
	call IN_CHAR			; Receive Char
	call Z_POINTER_LOGIC	; Set Z-pointer
	
	sbrs R20, 0				; Skip is R20 is 0
	call Display_Menu		; Transmit menu

	rjmp Never_End		; Jump to restart output loop



;*********************SUBROUTINES**************************************	
; Subroutine Name:  Z_POINTER_LOGIC
; Inputs: No direct input (from stack)
; Outputs: R20, Z-Pointer
; Affected: None
Z_POINTER_LOGIC:
	push R16 ; PUSH R16
	push R17 ; PUSH R17
	
	mov R16, R1		; Move R1 into R16

	ldi R20, 0x00	; Set R20 to 0
; IF '1'
	cpi R16, '1'			; Compare Char to 1
	brne IF2
	ldi ZL, low(Food << 1)	; Set Lower bits for Z-pointer	
	ldi ZH, high(Food << 1)	; Set upper bits for Z-pointer
	jmp END_IF				; JUMP to end switch
; Else if '2'
IF2:
	cpi R16, '2'				; Compare Char to 2
	brne IF3
	ldi ZL, low(Quote << 1)		; Set Lower bits for Z-pointer	
	ldi ZH, high(Quote << 1)	; Set upper bits for Z-pointer
	jmp END_IF					; JUMP to end switch
; Else if '3'
IF3:
	cpi R16, '3'				; Compare Char to 3
	brne IF4	
	ldi ZL, low(Movie << 1)		; Set Lower bits for Z-pointer	
	ldi ZH, high(Movie << 1)	; Set upper bits for Z-pointer
	jmp END_IF					; JUMP to end switch
; Else if '4'
IF4:	
	cpi R16, '4'					; Compare Char to 4
	brne IF5
	ldi ZL, low(UF_Course << 1)		; Set Lower bits for Z-pointer	
	ldi ZH, high(UF_Course << 1)	; Set upper bits for Z-pointer
	jmp END_IF						; JUMP to end switch
; Else if '5'
IF5:
	cpi R16, '5'			; Compare Char to 5
	brne IF6
	ldi ZL, low(Hobby << 1)	; Set Lower bits for Z-pointer	
	ldi ZH, high(Hobby << 1)	; Set upper bits for Z-pointer
	jmp END_IF				; JUMP to end switch
; Else if '6'
IF6:
	cpi R16, '6'			; Compare Char to 6
	brne IFD				
	pop r17					; POP R17
	pop r16					; POP R16
	ret						; return
;Else if 'D' or 'd'
IFD:
	cpi R16, 'D'			; Compare Char to D
	breq PASS				; Start infinite loop
	cpi R16, 'd'			; Compare Char to d
	brne ELSE				; JUMP to else
	ldi ZL, low(Done << 1)	; Set Lower bits for Z-pointer	
	ldi ZH, high(Done << 1)	; Set upper bits for Z-pointer
	call OUT_STRING
PASS:
	jmp PASS

; else
ELSE:
	ldi R20, 0x01			; Set R20 to 1
	pop r17					; POP R17
	pop r16					; POP R16
	ret						; return

END_IF:
	call OUT_STRING			; Call out_string

	pop R17 ; POP R17
	pop R16 ; POP R16
	ret		; Return



;*********************SUBROUTINES**************************************	
; Subroutine Name:  Display_Menu
; Inputs: No direct input (from stack)
; Outputs: No direct outputs
; Affected: None
Display_Menu:
	; Display Menu
	ldi ZL, low(Menu << 1)	; Set Lower bits for Z-pointer	
	ldi ZH, high(Menu << 1)	; Set upper bits for Z-pointer
	call OUT_STRING			; Output String
	ret						; Return








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