;Yuna Choe
;yuchoe
;Lab #: 7
; Section: 5
	.ORIG   x3000
PAStart	LEA 	R0, HELLO       ; load R0 with the "HELLO" string
		TRAP 	x22		
LOOP	AND 	R0, R0, x0	
	AND 	R1, R1, x0	
	AND 	R2, R2, x0	
	AND 	R3, R3, x0	
	AND 	R4, R4, x0	
	AND 	R5, R5, x0	
	AND 	R6, R6, x0	
	AND 	R7, R7, x0	

	LEA 	R0, PROMPT      ; LOAD "PROMPT"
	TRAP 	x22		
	AND 	R0, R0, x0	
READ	GETC	
		PUTC

	AND 	R4, R4, x0	;CHECK X
	AND 	R5, R5, x0	
	LD	R5,CAPX	
	ADD 	R4, R0, R5	
	BRz 	End	

	AND 	R4, R4, x0	; CHECK E
	AND 	R5, R5, x0	
	LD	R5,ECHECK	
	ADD 	R4, R0, R5	
	BRz 	ENC		

	AND 	R4, R4, x0	; CHECK D
	AND 	R5, R5, x0	
	LD	R5,DCHECK	
	ADD 	R4, R0, R5	
	BRz 	DEC		
		
	BRnzp	LOOP		; ASK AGAIN IF NOT X, D OR E


DEC	ADD R2, R2, #1	;FLAG VALUE TO 1 IF DECRYPT
ENC	JSR CIPH	; If the program is encrypting R2 is zero

LEA R6, ARRAY		; LOAD ADDRESS OF ARRAY
LEA 	R0, TAS       	
	TRAP 	x22		

GETLoop	GETC
	AND 	R4, R4, x0	
	ADD 	R4, R0, #-10	; LOAD R4 WITH INPUT CHAR
	BRz 	PRINT		
	STR	R0, R6, #0 	; STORE CHAR IN R6 (ARRAY)
	PUTC			
	AND 	R4, R4, x0	
	AND 	R5, R5, x0	
	LD	R5,DCHECK	; CHECK A
	ADD 	R5, R5, #3	; A in ascii
	ADD 	R4, R0, R5	
	BRn 	STAC						
	AND 	R4, R4, x0	
	AND 	R5, R5, x0	
	LD	R5,LOWERZ	; LOAD "z" VALUE
	ADD 	R4, R0, R5			
	BRp 	STAC		; IF NOT CHAR, STORE AS IS			
	
	AND 	R4, R4, x0					
	ADD	R4, R2, #-1	; CHECK IF POS.
	BRn	ENchar		; ENCRYPT CHAR
	BRzp	DEchar		; DCRYPT CHAR


CIPH	ST	R7, Return	; STORE RETURN ADDRESS IN R7
	LEA 	R0, CPrompt     ; ASK FOR CIPHER
	TRAP 	x22		
	AND 	R0, R0, x0	

RCHAR	GETC			; GER CHAR
	AND 	R4, R4, x0	; R4
	LD	R4, LFCHECK	
	ADD 	R4, R4, R0	;CHAR IN R4
	BRz 	DONE		
	PUTC		

	AND 	R5, R5, x0	
	LD	R5,FOURTYEIGHT	
	ADD	R0, R0, R5	; SUBTRACT 48 TO GET ACTUAL VALUE FROM ASCII VALUE

	AND 	R4, R4, x0	
	ADD	R4, R1, #0	
	ADD	R3, R3, #9	
Sub	ADD	R1, R1, R4	; SUB
	ADD	R3, R3, #-1	; DECREMENET THE COUNTER
	BRp	Sub	
	ADD	R1, R1, R0	; ADD DECIMAL COUNTER TO SUM
	BRnzp	RCHAR		

ENchar	AND 	R3, R3, x0	
	AND 	R4, R4, x0	
	AND 	R5, R5, x0	
	AND 	R7, R7, x0	
	
	LD	R5,CAPX 	
	ADD	R5, R5, #-2		;'Z'
	ADD 	R4, R0, R5	; minus 90			
	BRnz	EnUpper		; Encrypt the letter as Upper case

	LD	R5,LOWERA	; -97 into R5, 90 is 'a' in ascii
	ADD 	R4, R0, R5	; minus 97
	BRzp	EnLower		; Encrypt the letter as Lower case

	BRnzp 	STAC		; the value was not a letter, store as-is 
	
EnUpper	AND 	R3, R3, x0	
		AND 	R4, R4, x0	
		AND 	R5, R5, x0	
		AND 	R7, R7, x0	
		
		LD	R5,CAPX 	
		ADD	R5, R5, #-2	; 'Z' in ascii	
		LD	R4,ALPHA	; 26						
		ADD 	R5, R5, R4	;-64
		NOT	R3, R1		;
		ADD	R3, R3, #1	; NEG ciper
		
		ADD     R4, R4, R3
		ADD	R3, R3, R5
		ADD 	R7, R3, R0	;-Cipher-64+letter code
		BRp	EncDn	; sub
		BRnz	EncUp	;add

EncUp	ADD 	R0, R4, R0		; adds 26-cipher to the char code
			BRnzp	STAC		; saves the encrypted value
	
EncDn	NOT	R3, R1			; cipher
			ADD	R3, R3, #1	; 
			ADD	R0, R0, R3	;
			BRnzp	STAC		; saves the encrypted value
	
EnLower	AND 	R3, R3, x0	
		AND 	R4, R4, x0	
		AND 	R5, R5, x0	
		AND 	R7, R7, x0	

		LD	R5,LOWERZ 	;'z' in ascii	
		LD	R4,ALPHA		; loads 26 into R4						
		ADD 	R5, R5, R4	
		NOT	R3, R1			
		ADD	R3, R3, #1		
		
		ADD     R4, R4, R3	
		ADD	R3, R3, R5		
		ADD 	R7, R3, R0	
		BRp	EncDn		
		BRnz	EncUp	
	

DEchar	AND 	R3, R3, x0	;CLEAR
	AND 	R4, R4, x0	
	AND 	R5, R5, x0	
	AND 	R7, R7, x0	
	
	LD	R5,CAPX 	
	ADD	R5, R5, #-2		;'Z'
	ADD 	R4, R0, R5	; minus 90			
	BRnz	DeUpper		; DECRYPT UPPER CASE

	LD	R5,LOWERA	;'a'	
	ADD 	R4, R0, R5	; minus 97
	BRzp	DeLower		; DECRYPT LOWER CASE

	BRnzp 	STAC		; NOT CHAR, STORE AS IS
	
DeUpper	AND 	R3, R3, x0	;CLEAR
		AND 	R4, R4, x0	
		AND 	R5, R5, x0	
		AND 	R7, R7, x0	

		LD	R5,CAPX 	
		ADD	R5, R5, #-2	;'Z'	
		LD	R4,ALPHA	;26 into R4						
		ADD 	R5, R5, R4
		NOT	R3, R1		;
		ADD	R3, R3, #1	;NEG CIPHER
		
		ADD     R4, R4, R3	
		ADD	R3, R3, R5	
		ADD 	R7, R3, R0	
		BRp	DecUp	
		BRnz	DecDn	

DecDn	ADD 	R0, R1, R0	; CIPHER TO CHAR
		BRnzp	STAC		; DAVE DECRYPT VALUE
	
DecUp	NOT	R3, R4			
			ADD	R3, R3, #1	
			ADD	R0, R0, R3	;NEG CIPHER
			BRnzp	STAC	;SAVE DECRYPT VALUE
	
DeLower	AND 	R3, R3, x0	;CLEAR
		AND 	R4, R4, x0	
		AND 	R5, R5, x0	
		AND 	R7, R7, x0	

		LD	R5,LOWERZ ;'z' in ascii
		LD	R4,ALPHA						
		ADD 	R5, R5, R4
		NOT	R3, R1		
		ADD	R3, R3, #1	
		
		ADD     R4, R4, R3	
		ADD	R3, R3, R5	
		ADD 	R7, R3, R0
		BRp	DecUp	
		BRnz	DecDn	

STAC	LD	R3, SECONDHALF	; STORE ENCRYPTED VALUE IN SECOND HALF OF ARRAY
		ADD	R3, R3, R6	
		STR 	R0, R3, #0 	
		ADD	R6, R6, #1	; INCREMEMENT ARRAY COUNTER
		BRnzp   GETLoop		; GET AGAIN

PRINT	LEA 	R0, NEW     	; ASK FORNEW LINE
	TRAP 	x22		
	AND 	R0, R0, x0	;CLEAR
	AND 	R1, R1, x0	
	AND 	R2, R2, x0	
	AND 	R3, R3, x0	
	AND 	R4, R4, x0	
	AND 	R5, R5, x0	

	LEA 	R5, ARRAY	; LOAD ADDRESS OF ARRAY INTO R5
PRL1	NOT 	R4, R5	;PRINT FIRST HLF OF ARRAY
	ADD 	R4, R4, #1	
	ADD 	R4, R4, R6	
	BRnz	PRTWO		; STOP BEFORE 2ND HALF OF ARRAY
	LDR	R0, R5, #0	
	ADD	R5, R5, #1	; COUNTER++
	PUTC			
	BRnzp	PRL1		

PRTWO	AND 	R0, R0, x0	
	AND 	R1, R1, x0	
	AND 	R2, R2, x0	
	AND 	R3, R3, x0	
	AND 	R4, R4, x0	
	AND 	R5, R5, x0
	
	LEA 	R0, NEW	; new line    
	TRAP 	x22	
	
	LEA 	R5, ARRAY	; LOADS ADDRESS OF ARRAY INTO R5
	LD	R3, SECONDHALF	
	ADD	R5, R5, R3	;2ND HALF OF ARRAY
	ADD	R6, R6, R3	
PRL2	NOT 	R4, R5
	ADD 	R4, R4, #1	
	ADD 	R4, R4, R6	
	BRnz	LOOP		;LOOP
	LDR	R0, R5, #0	
	ADD	R5, R5, #1	
	PUTC				
	BRnzp	PRL2		; LOOP

DONE LD 	R7, Return ; DONE
	JMP 	R7

End	HALT

HELLO	.STRINGZ 	"Hi! Welcome to Caesar salad Cipher progra,.\n"
PROMPT  .STRINGZ 	"\nSelect E to Encrypt, D to Decrypt, or X to exit!\n"
AGAIN  	.STRINGZ 	"\nPlease try again!"
CPrompt .STRINGZ	"\nEnter the cipher! (1-25):\n"
BYE	.STRINGZ	"\nDone!.\n"
TAS	.STRINGZ	"\nEnter a string up to 200 characters.\n"
PRNT	.STRINGZ	"\nOutput:\n"
NEW	.STRINGZ	"\n"
ARRAY	.BLKW #400
FIRSTHALF 	.FILL #100
SECONDHALF 	.FILL #200
LOWERA	.FILL #-97
FOURTYEIGHT	.FILL #-48
LOWERZ	.FILL #-122
LFCHECK		.FILL #-10
CAPX 	.FILL #-88 ;X
DCHECK	.FILL #-68 ;D
ECHECK	.FILL #-69 ;E
ALPHA		.FILL #26 ;alphabet
Return		.FILL x0000
Length		.FILL x0000 
	
.END
