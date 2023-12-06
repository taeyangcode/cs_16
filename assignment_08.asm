; Assignment #8

; Program Description: This last assignment involves floating-point processing and translation of C++ code to assembly language.
; Author: Corey Mostero 2566652
; Creation Date: 05 December 2023
; Revisions: N/A
; Date: 10 December 2023

.386
.model flat, stdcall
.stack 4096
ExitProcess PROTO, dwExitCode: DWORD

INCLUDE Irvine32.inc

.data

EOL = 10

; part 03

x REAL8 ?
y REAL8 ?

less_string BYTE "X is lower", EOL, 0
geq_string BYTE "X is higher", EOL, 0

; part 04

co_a REAL8 ?
co_b REAL8 ?
co_c REAL8 ?

prompt_a BYTE "Enter coefficient a", EOL, 0
prompt_b BYTE "Enter coefficient b", EOL, 0
prompt_c BYTE "Enter coefficient c", EOL, 0

two_a REAL8 ?

i_zero DWORD 0
i_two DWORD 2
i_four DWORD 4

square_root_value REAL8 ?

b_two_a REAL8 ?

prompt_real BYTE "Real root: ", 0
prompt_imaginary BYTE "Imaginary root: ", 0

.code

; part 01
; a) 0.03125
; 0 01111111010 00000000000000000000000
; b) -17.0625
; 1 10000000011 00010001000000000000000
; c) 181.40625
; 0 10000000110 01101010110100000000000

; part 02
; a)
; -0.875
; b)
; 440.0
; c)
; -2664.0

part_03 PROC USES eax edx
	fld y					; push y to stack
	fld x					; push x to stack

	fcomi ST(0), ST(1)			; compare x to y

	jb LESS					; if x < y -> jmp LESS
	jmp GEQ					; else -> jmp GEQ
	
LESS:
	mov edx, OFFSET less_string
	call WriteString			; write: X is lower
	ret					; exit function

GEQ:
	mov edx, OFFSET geq_string		; write: X is greater
	call WriteString			; exit function
	ret

	ret
part_03 ENDP

part_04 PROC USES edx
	mov edx, OFFSET prompt_a
	call WriteString			; prompt user for a

	call ReadFloat				; read value onto stack
	fstp co_a				; move value into co_a and pop stack

	mov edx, OFFSET prompt_b
	call WriteString			; prompt user for b

	call ReadFloat				; read value onto stack
	fstp co_b				; move value into co_b and pop stack

	mov edx, OFFSET prompt_c
	call WriteString			; prompt user for c

	call ReadFloat				; read value onto stack
	fstp co_c				; move value into co_c and pop stack

						; compute: 2*a
	fld co_a				; push a onto stack
	fild i_two				; push integer 2 onto stack
	fmul					; 2*a
	fstp two_a				; move 2*a into two_a for later use and pop stack (stack is empty)

						; compute: b^(2)
	fld co_b				; push b
	fld co_b				; push b
	fmul					; multiply to get: b^(2) on stack

	fld co_c				; push c
	fld co_a				; push a
	fmul					; multiply to get: a * c on stack

	fild i_four				; push integer 4 onto stack
	fmul					; multiply to get: 4*a*c on stack

	fsub					; subtract: 4*a*c, from: b^(2)

						; now we determine if we have real or imaginary solutions
	fild i_zero				; push integer 0 onto stack
	fcomi ST(0), ST(1)			; compare 0 and computed value above
	fstp ST(0)				; pop temporary 0

	ja IMAGINARY_ROOTS			; if 0 > computed value -> we have imaginary solutions
	jmp REAL_ROOTS				; else -> we have real solutions

IMAGINARY_ROOTS:
	fchs					; change the sign of the negative value computed from: b^(2) - 4*a*c
	fsqrt					; square root value
	fst square_root_value			; move square root value into square_root_value

						; now compute imaginary portion of solution
	fld two_a				; push 2*a onto stack

	fdiv					; divide: 2*a, from: square root value -> imaginary portion calculated

	fld co_b				; push b onto stack
	fchs					; b -> -(b)

	fld two_a				; push 2*a onto stack

	fdiv					; calcuate: (-b) / (2*a) -> real portion calculated

	fst b_two_a				; move result into b_two_a

	mov edx, OFFSET prompt_imaginary
	call WriteString			; write imaginary solution prompt

	call WriteFloat				; write real portion
	fstp ST(0)				; pop real portion from stack
	call WriteFloat				; write imaginary portion
	mov al, 'i'
	call WriteChar				; write 'i' to show the required multiplication with i 

	call CrlF				; new line

	fchs					; change sign of imaginary portion to get second solution
	fld b_two_a				; push b_two_a onto stack again

	call WriteString			; same process as before but writing the other imaginary solution
	call WriteFloat
	fstp ST(0)
	call WriteFloat
	call WriteChar

	ret					; exit function

REAL_ROOTS:
	fsqrt					; since: (b^2) - 4*a*c, is real square root
	fst square_root_value			; move value into square_root_value

	fld co_b				; push b onto stack
	fchs					; b -> -(b)

	fadd					; compute: (-b) + square_root_value

	fld two_a				; push 2*a onto stack

	fdiv					; compute: ((-b) + square_root_value) / (2*a)

	mov edx, OFFSET prompt_real
	call WriteString			; write real solution prompt
	call WriteFloat				; write first real solution
	call CrlF				; new line

	fstp ST(0)				; pop solution from stack

						; now calculate second solution
	fld co_b				; push b onto sstack
	fchs					; b -> -(b)

	fld square_root_value			; push square root value onto stack

	fsub					; compute: (-b) - square_root_value

	fld two_a				; push 2*a onto stack

	fdiv					; copmute second solution

	call WriteString			; write real solution prompt
	call WriteFloat				; write second solution

	ret					; exit function
part_04 ENDP

main PROC
	; call part_03
	; call part_04

	INVOKE ExitProcess, 1
main ENDP

END main
