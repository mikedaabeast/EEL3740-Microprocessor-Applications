; Lab 0 Part C
; Name:		Michael Arboleda
; Section:	7F34
; TA Name:	Wesley Piard
; Description: This code filters data based on ASCII Value
;
; lab0.asm
; Created: 5/16/2017 4:14:49 PM
;
.include "ATxmega128A1Udef.inc"

.equ outputTable = 0x3744
.equ inputTable	 = 0xF000
.equ upperBound  = 0166
.equ lowerBound  = 38
.equ addition	 = 0x11

.ORG 0x0000			;Code starts running from address 0x0000.
	rjmp MAIN		;Relative jump to start of program.
	
.CSEG				;Code segment start	
	.ORG 0xF000 		;Start table address
	
Input_Table:
	.db 0x3d, 0x7F, 84, 102, 0x7B, 0172, 0x20, 0x64,\
	0x7E, 0x3F, 060, 0x33, 0x7B, 121, 118, 0x21, 0x78,\
	0x77, 0 ; Table Values
	
.DSEG				;Code segment stop

.ORG 0x3744			;Start output table address
Output_Table:
	.byte 18;
	
.CSEG
.ORG 0x0100		;Start program at 0x0100 so we don't overwrite 
			;Vectors that are at 0x0000-0x00FD 
	
MAIN:
	;Set up Y-register 
	ldi YL, low(outputTable);LOAD address to write to - low 2 bits
	ldi YH, high(outputTable);LOAD address to write to - high 2 bits
	
	;Set up z-register
	ldi R16, 1			;LOAD 1 to R16
	sts CPU_RAMPZ, R16		;STORING Extended Address
	ldi ZL, low(inputTable << 1);LOAD adrs to read from-low 2 bits
	ldi ZH, high(inputTable << 1);LOAD adrs to read from-high 2 bits
	
	;set up regs to hold commonly used values
	ldi R16, lowerBound		;LOAD 38 (for comparision)
	ldi R17, upperBound		;LOAD 166 (for comparision)
	ldi R18, addition		;LOAD 0x11 (for addition)
	
;START DO W?HILE LOOP
DO:				;Top of do-while loop
	elpm R19, z+		;LOAD data from array
				;Post increment z-reg
;IF	
	;if greater than 165, it fails
	cp R19, R17		;COMPARE R17 with R19
	BRGE ENDIF 		;BRANCH if R19 >= 0166

;INNER IF
;THIS part corrisponds with an nested if statement
	;If less than 38, if fails
	cp R19, R16		;COMPARE R16 with R19
	BRLT END_INNER_IF	;BRANCH if R19 < R17 (37)
	
	;add 0x11 to data
	add R19, R18 		;Add R19:= R19 + R18 (add 0x11)

END_INNER_IF:
	;Store Value to table
	st  y+, R19	;Store new data to proper location
			;increment location(store) pointer	
;WHILE part of DO-WHILE loop
ENDIF:	
	cpi R19, 0	;Compare R19 with #0	
	BRNE DO		;BRANCH to DO if R19 does not equal 0
	
	;Stores 0 at end
	st  y, R19	;Store new data to proper location
			;HI This will always store 0