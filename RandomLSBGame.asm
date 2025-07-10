; RandomLSBGame.asm
; 

ORG 0
Initialization:
	LOADI	0
    STORE	Score
	OUT		Hex1   

Check_All_SW_Down:
	IN		Switches
    OUT		LEDs
    JNZ		Check_All_SW_Down
    
Check_SW9_Up:
	LOAD	Random_Val
    ADDI	1
    STORE	Random_Val
    IN		Switches
    OUT		LEDs
    AND		Bit9
    JZERO	Check_SW9_Up
    
Round_Setup:
	LOAD	Random_Val
    AND		Bitmask_256
    STORE	Random_Val
    JNZ		Display_Random_Result
    ADDI	1
Display_Random_Result:
    OUT		Hex0
    
Check_SW9_Down:
	IN		Switches
    OUT		LEDs
    AND		Bit9
    JZERO	Reset_Score

Check_SW7to0_Up:
	IN		Switches
    OUT		LEDs
    AND		Bitmask_256
    JZERO	Check_SW9_Down
    
Check_LSB_Match:
	IN		Switches
    OUT		LEDs
    STORE	SW_Input
    LOAD	Random_Val
    AND		SW_Input
    JZERO	Reset_Score
    LOAD	SW_Input
    ADDI	-1
    STORE	Temp
    LOAD	Random_Val
    AND		Temp
    JNZ		Reset_Score
    
Earn_Point:
	LOAD	Score
    ADDI	1
    STORE	Score
	JUMP	Check_All_SW_Down

Reset_Score:
	LOADI	0
    STORE	Score
    JUMP	Check_All_SW_Down

EOP:
	JUMP	EOP

; Variables
SW_Input:  	DW 0
Temp:		DW 0
Score:		DW 0
Random_Val:	DW 0

; Useful values
Bit0:      		DW &B0000000001
Bit9:      		DW &B1000000000
Bitmask_256:	DW &H00FF

; IO address constants
Switches:  	EQU 000
LEDs:      	EQU 001
Timer:     	EQU 002
Hex0:      	EQU 004
Hex1:      	EQU 005
