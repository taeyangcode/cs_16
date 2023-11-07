; Assignment #6

; Program Description: This assignment practices the use of macros, as well as strings and arrays.
; Author: Corey Mostero 2566652
; Creation Date: 06 November 2023
; Revisions: N/A
; Date: 17 November 2023

.386
.model flat, stdcall
.stack 4096
ExitProcess PROTO, dwExitCode: DWORD

INCLUDE Irvine32.inc

.data

targetString BYTE "HELLO", 10 DUP(0)
sourceString BYTE "WORLD", 0

.code

DifferentInputs PROTO,
	value_1: DWORD,
	value_2: DWORD,
	value_3: DWORD

StrConcat PROTO,
	source: PTR BYTE,
	target: PTR BYTE

main PROC
	INVOKE StrConcat, ADDR sourceString, ADDR targetString

    INVOKE ExitProcess, 0
main ENDP

part_01 PROC
	; rows = 10
	; columns = 5

	; .data

	; iVal = 10

	; REPEAT rows * columns
	; 	DWORD iVal
	; 	iVal = iVal + 10
	; ENDM
	
	; The last integer to be generated would be: 510
part_01 ENDP

DifferentInputs PROC USES ebx ecx edx, 
	value_1: DWORD,
	value_2: DWORD,
	value_3: DWORD

	mov ebx, value_1			; move value one into ebx
	mov ecx, value_2			; move value two into ecx
	mov edx, value_3			; move value three into edx

	cmp ebx, ecx				; if value one equals value two
	jne NotEqual				; false -> jump NotEquals

	cmp ecx, ed				; if value two equals value three
	jne NotEqua				; false -> jump NotEquals

	mov eax, 1				; value one == value two == value three -> eax := 1
	ret

NotEqual:
	mov eax, 0				; one value is different -> eax := 0
	ret
DifferentInputs ENDP

test_DifferenceInputs PROC
	INVOKE DifferentInputs, 0, 0, 0		; expected output: eax = 1

	INVOKE DifferentInputs, 1, 0, 0		; expected output: eax = 0

	INVOKE DifferentInputs, 0, 1, 0		; expected output: eax = 0

	INVOKE DifferentInputs, 0, 0, 1		; expected output: eax = 0

	INVOKE DifferentInputs, 1, 0, 1		; expected output: eax = 0
test_DifferenceInputs ENDP

StrConcat PROC USES esi edi,
	source: PTR BYTE,
	target: PTR BYTE

	mov esi, source				; move source pointer to esi
	mov edi, target				; move target pointer to edi

find_target_end:				; find end of target string
	cmp BYTE PTR [edi], 0			; if reached target end
	jz append_target			; true -> jump to append

	inc edi					; increment target pointer
	jmp find_target_end			; loop find_target_end

append_target:					; append source to target
	cmp BYTE PTR [esi], 0			; if reached source end
	jz end_concat				; true -> procedure complete

	push esi				; save current source pointer location
	mov esi, [esi]				; get value at source pointer location
	mov [edi], esi				; move source value to target value
	pop esi					; recover source pointer location

	inc esi					; increment source pointer
	inc edi					; increment target pointer
	jmp append_target			; loop append_target

end_concat:					; procedure complete
	ret
StrConcat ENDP

END main
