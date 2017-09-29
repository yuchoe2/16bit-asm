;Yuna Choe
;yuchoe@ucsc.edu
;lab #: 5
;Section: 5

		.ORIG	x3000		;set where code starts in memory
		LEA	R0	HELLO	;load "hello..." string into R0
		LD	R1	count	;count = 5
WHILE		BRnz	ENDWHILE	;if count <= 0 go to ENDWHILE
		TRAP	x22		;print R0
		ADD	R1,R1,	#-1	;subtract 1 from count 
		BR	WHILE		;branch to WHILE
ENDWHILE	TRAP	x25

HELLO		.STRINGZ	" Hello World, this is Yuna!"
count		.FILL		x0005
		.END