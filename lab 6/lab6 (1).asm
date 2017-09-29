;Yuna Choe
;yuchoe@ucsc.edu
;lab #: 6
;Section : 5

	.ORIG	x3000
	LEA	R0	HELLO
	TRAP	x22
START	LD	R2, 	INT
	LD	R3, 	FLAG
USER	AND	R0,R0,	0
	AND	R1,R1,	0
	AND	R6,R6,	0
	LD	R6,	DIGIT
	LEA	R0, 	ASK
	TRAP	x22		;shows hello string
	GETC			;asking for user input
	PUTC
	ADD	R1,R0,	0	;keeping a backup of user input

END	LD	R7,	EXIT
	ADD	R0,R0,	R7
	BRz	DONE
	BRnp	LF_CHK

LF_CHK	LD	R7,	NEG_LF ; loading NEG_LF into register 7
	ADD	R0,R0,	R7
	BRnp	NEG_CHK	;if char is not LF
	BRz	FLAG_CHK	; if char is LF, go to 2sc
NEG_CHK	AND	R0,R0,	0
	ADD	R0,R1,	0	;restoring register 0 as user input from register 1
	LD	R7,	NEG_MIN
	ADD	R0,R0,	R7	;checking if char is '-'
	BRz	FLAG_SWITCH
	BRp	DIG_SUB


FLAG_SWITCH	ADD	R3,R3,	1
	BR	USER

DIG_SUB	LD	R4,	DIG_VAR
	ADD	R6,R1,	R4	;using backup user input and minus 48

	AND	R0,R0,	0		;clearing register 0 to keep orginal int
	ADD	R0,R2,	0		;let register 0 be the original int
	AND	R7,R7,	0		;clearing reg 7
	ADD	R7,R7,	9	;making the mult counter = 10(9-0)
	LD	R5,	MC_SUB
	
MULT_C	ADD	R2,R2,	R0	;INT = INT +ORIGINAL INT
	ADD	R7,R7,	R5	;decrementing multiply counter
	BRp	MULT_C
	BRz	FIN_INT

FIN_INT	ADD	R2,R2,	R6	;adding intx10 + digit
	BR	USER

FLAG_CHK	LD	R7,NEG_FLAG
	ADD	R3,R3,	R7
	BRz	TWOSC
	BRn	SMASK

TWOSC	AND	R6,R6,	0
	ADD	R6,R2,	R2	;2X INT
	LD	R5,	NEG_INT

FLIP_INT	ADD	R2,R2,	R5
	ADD	R6,R6,	R5
	BRp	FLIP_INT
	BRz	TWOSC_1

TWOSC_1	ADD	R2,R2,	1
	BR	SMASK

SMASK	LD	R3,	COUNT
MASKK	LEA	R1,	MASK
	;ST	R1,	STMASK
	LD	R4,	COUNT
	LD	R5,	COUNT_CHK

CHK_COUNT	LDI	R6,MASK
	ADD	R4,R4,	0
	BRn	DONE
	BRzp	DIGIT_2
	
DIGIT_2	AND	R7,R2,	R6 	;INT PLUS MASK

CHK_DIG	BRp	PRINT_1
	BRz	PRINT_Z

PRINT_Z	LEA	R0,	PRINT0
	TRAP	X22
	BR	INCR

PRINT_1	LEA	R0,	PRINT1
	TRAP	X22
	BR	INCR

INCR	ADD	R1,R1,	1
	ADD	R4,R4,	-1
	BR	CHK_COUNT

DONE	HALT

;--------------------------------------------


HELLO	.STRINGZ	"Hi.\n"
ASK	.STRINGZ	"Please enter a number or X to quit.\n"
INT	.FILL	x0000
FLAG	.FILL	x0000
NEG_MIN	.FILL   #-45
NEG_LF	.FILL   #-10
DIGIT	.FILL	X0000
DIG_VAR	.FILL	#-48
MC_SUB	.FILL	#-1
NEG_FLAG	.FILL	#-1
NEG_INT	.FILL	#-1
MASK	.FILL	#32768
	.FILL	#16384
	.FILL	#8192
	.FILL	#4096
	.FILL	#2048
	.FILL	#1024
	.FILL	#512
	.FILL	#256
	.FILL	#128
	.FILL	#64
	.FILL	#32
	.FILL	#16
	.FILL	#8
	.FILL	#4
	.FILL	#2
	.FILL	#0
COUNT	.FILL	#15
COUNT_CHK	.FILL	#-1
PRINT0	.STRINGZ	"0"
PRINT1	.STRINGZ	"1"
EXIT	.FILL	#-88
.END