// compute a greatest common divisor of a and b

t  	IS   	$255
a	GREG	0
a0	GREG	0
b	GREG	0
b0	GREG	0
d	GREG	0
r	GREG	0
i	GREG	0
j	GREG	0
k	GREG	0
tmp	GREG	0
val	GREG	0

	LOC	Data_Segment
ptr_a	GREG	@
Arg_a	OCTA	@,8	// (10-2)Byte格納できる
ptr_b	GREG	@
Arg_b	OCTA	@,8
result	GREG	0
RESULT	OCTA	8

// '0' = #30, '1' = #31, ..., '9' = #39, '\n' = #0a
// gcd(544,119) = 17
// gcd(1769,551) = 17

	LOC	#100
Main	LDA	t,Arg_a		// #100
	TRAP	0,Fgets,StdIn	// #104
	LDA	t,Arg_b		// #108
	TRAP	0,Fgets,StdIn	// #10c
	LDOU	a,ptr_a,0	// #110
	LDOU	b,ptr_b,0	// #114

	/* String -> Int for a*/
2H	LDBU	val,ptr_a,d
	CMP	tmp,val,#a
	INCL	d,1
 	PBNZ	tmp,2B
	SUB	d,d,2
	SET	i,1
3H	LDBU	val,ptr_a,d
	SUB	val,val,'0'
	MUL	val,val,i
	ADD	a0,a0,val
	MUL	i,i,10
	SUB	d,d,1
	PBNN	d,3B
	SET	result,a0

	/* String -> Int for b */
	SET	d,0
2H	LDBU	val,ptr_b,d
	CMP	tmp,val,#a
	INCL	d,1
 	PBNZ	tmp,2B
	SUB	d,d,2
	SET	i,1
3H	LDBU	val,ptr_b,d
	SUB	val,val,'0'
	MUL	val,val,i
	ADD	b0,b0,val
	MUL	i,i,10
	SUB	d,d,1
	PBNN	d,3B
	ADD	a0,a0,b0

	/* calculate gcd(a,b) */
	SET	a,a0
	SET	b,b0
	PBZ	a,FIN
4H	DIV	val,a,b
	GET	tmp,rR
	SET	a,b
	SET	b,tmp
	PBNZ	b,4B
FIN	SET	result,a

	/* for output */
0H	GREG	#2030303030000000
   	STOU	0B,RESULT
	LDA	t,RESULT+4
1H	DIV	result,result,10
	GET	r,rR
	INCL	r,'0'
	STBU	r,t,0
	SUB	t,t,1
	PBNZ	result,1B
	INCL	t,1
	TRAP	0,Fputs,StdOut
	GETA	t,NewLn
	TRAP	0,Fputs,StdOut
	TRAP	0,Halt,0
NewLn	BYTE	#a,0

// a = a0, b = b0
// while (b != 0) {
//   temp = a % b
//   a = b
//   b = tmp
// }
// return a
