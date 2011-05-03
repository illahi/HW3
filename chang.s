.globl _start
.data
	###TEMPORARY SECTION, FOR TESTING###
ndenoms:
	.long 4
amt:
	.long 87
onhand:
	.long 2
	.long 5
	.long 3
	.long 7
denoms:
	.long 25
	.long 10
	.long 5
	.long 1
thechange:
	.rept 4
	.long 0
	.endr
.text
_start:
	movl ndenoms, %edi
	movl amt, %edx
	movl $thechange, %ecx
	movl $denoms, %ebx
	movl $onhand, %eax
	push %ecx
	push %edi
	push %ebx
	push %eax
	push %edx
	call makechange
	###END TEMPORARY TESTING SECTION###
makechange:
	#push %ebx ###Don't do this unless absolutely necessary
	#push %edi
	#Get arguments
	movl 4(%esp), %eax #amt
	#movl 8(%esp), %ebx #*onhand ###these two steps can be done later so
	#movl 12(%esp), %ecx #*denoms ###that these registers can be used
	movl 16(%esp), %ecx #ndenoms
	#movl 20(%esp), %edx #*thechange ###This, too.
	#See if we're in last cycle
	cmpl $1, %ecx
	je lasttime
	#if not, start storing next arguments on stack
	movl 20(%esp), %eax #*thechange
	addl $4, %eax
	push %eax
	subl $1, %ecx
	push %ecx
	movl 16(%esp), %ecx #*onhand
	addl $4, %ecx
	push %ecx
	movl 24(%esp), %edx #*denoms
	addl $4, %edx
	push %edx
	movl 20(%esp), %eax #amt
	push %eax
	#move pointers back
	subl $4, %ecx
	subl $4, %edx
	#Get data from pointers
	movl (%ecx), %ecx
	#free up ebx
	push %ebx
	movl 44(%esp), %ebx #store ecx
	movl %ecx, (%ebx) #store ecx
	pop %ebx #restore ebx
	movl (%edx), %edx
	#Do multiplication to find amount, store in stack
find_amt:
	movl %edx, %eax
	imull %ecx, %eax
	decl %ecx #Will have to add one before storing number
	subl %eax, (%esp)
	jl find_amt
	jg next_call
	je done
lasttime:
	movl 8(%esp), %ecx #*onhand
	movl 12(%esp), %edx #*denoms
last_loop:
	movl %edx, %eax
	imull %ecx, %eax
	cmpl 4(%esp), %eax #amt
	decl %ecx
	jg last_loop
	je done
	#if less than
	call not_found
	ret
next_call:
	call make_change
not_found:
	movl
done:	
	