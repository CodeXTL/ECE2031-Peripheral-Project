; MyIODemo.asm
; Produces a "bouncing" animation on the LEDs.
; The LED pattern is initialized with the switch state.
; Includes modification that pause the program when more than two switches are up

ORG 0
Main:
	; Get and store the switch values
	IN     	Switches
	OUT    	LEDs
	STORE  	Pattern
    
    STORE	Temp_Pattern
    LOADI	0
    STORE	Bit_Count
    STORE	Num_Checked_Bits
Count_Bits:
	LOAD	Temp_Pattern
	AND		Bit0
    JZERO	No_Increment
    LOAD	Bit_Count
    ADDI	1
    STORE	Bit_Count
No_Increment:
	LOAD	Num_Checked_Bits
    ADDI	1
    STORE	Num_Checked_Bits
	LOAD	Temp_Pattern
    SHIFT	-1
    STORE	Temp_Pattern
    LOAD	Bit_Count
    ADDI	-2
    JPOS	Main
    LOAD	Num_Checked_Bits
    ADDI	-16
    JNZ		Count_Bits
	
Left:
	; Slow down the loop so humans can watch it.
	CALL	Delay

	; Check if the left place is 1 and if so, switch direction
	LOAD	Pattern
	AND		Bit9         ; bit mask
	JNZ    	Right        ; bit9 is 1; go right
	
	LOAD   	Pattern
	SHIFT  	1
	STORE  	Pattern
	OUT    	LEDs

	JUMP   	Left
	
Right:
	; Slow down the loop so humans can watch it.
	CALL   	Delay

	; Check if the right place is 1 and if so, switch direction
	LOAD   	Pattern
	AND    	Bit0         ; bit mask
	JNZ    	Left         ; bit0 is 1; go left
	
	LOAD   	Pattern
	SHIFT  	-1
	STORE  	Pattern
	OUT    	LEDs
	
	JUMP   Right
	
; To make things happen on a human timescale, the timer is
; used to delay for half a second.
Delay:
	OUT    	Timer
WaitingLoop:
	IN     	Timer
	ADDI   	-5
	JNEG   	WaitingLoop
	RETURN

; Variables
Pattern:   			DW 0
Temp_Pattern:		DW 0
Bit_Count:			DW 0
Num_Checked_Bits:	DW 0

; Useful values
Bit0:      	DW &B0000000001
Bit9:      	DW &B1000000000

; IO address constants
Switches:  	EQU 000
LEDs:      	EQU 001
Timer:     	EQU 002
Hex0:      	EQU 004
Hex1:      	EQU 005
