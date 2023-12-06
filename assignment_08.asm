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
	fld y
	fld x

	fcomi ST(0), ST(1)

	jb LESS
	jmp GEQ
	
LESS:
	mov edx, OFFSET less_string
	call WriteString
	ret

GEQ:
	mov edx, OFFSET geq_string
	call WriteString
	ret

	ret
part_03 ENDP

part_04 PROC USES edx
	mov edx, OFFSET prompt_a
	call WriteString

	call ReadFloat
	fstp co_a

	mov edx, OFFSET prompt_b
	call WriteString

	call ReadFloat
	fstp co_b

	mov edx, OFFSET prompt_c
	call WriteString

	call ReadFloat
	fstp co_c

	fld co_a
	fild i_two
	fmul
	fstp two_a

	fld co_b
	fld co_b
	fmul

	fld co_c
	fld co_a
	fmul

	fild i_four
	fmul

	fsub

	fild i_zero
	fcomi ST(0), ST(1)
	fstp ST(0) ; popping 0

	ja IMAGINARY_ROOTS
	jmp REAL_ROOTS

IMAGINARY_ROOTS:
	fchs
	fsqrt
	fst square_root_value

	fld two_a

	fdiv

	fld co_b
	fchs

	fld two_a

	fdiv

	fst b_two_a

	mov edx, OFFSET prompt_imaginary
	call WriteString

	call WriteFloat
	fstp ST(0)
	call WriteFloat
	mov al, 'i'
	call WriteChar

	call CrlF

	fchs
	fld b_two_a

	call WriteString
	call WriteFloat
	fstp ST(0)
	call WriteFloat
	call WriteChar

	ret

REAL_ROOTS:
	fsqrt
	fst square_root_value

	fld co_b
	fchs

	fadd

	fld co_a
	fild i_two

	fmul
	fdiv

	mov edx, OFFSET prompt_real
	call WriteString
	call WriteFloat
	call CrlF

	fstp ST(0)

	fld co_b
	fchs

	fld square_root_value

	fsub

	fld co_a
	fild i_two

	fmul
	fdiv

	call WriteString
	call WriteFloat

	ret
part_04 ENDP

main PROC
	; call part_03
	; call part_04

	INVOKE ExitProcess, 1
main ENDP

END main
