; Assignment #7

; Program Description: This assignment allows you to incorporate graphical components in assembly language.
; Author: Corey Mostero 2566652
; Creation Date: 04 December 2023
; Revisions: N/A
; Date: 03 December 2023

.386
.model flat, stdcall
.stack 4096
ExitProcess PROTO, dwExitCode: DWORD

INCLUDE Irvine32.inc

.data

UNDERSCORE = 95
PIPE = 124
SPACE = 32
FORWARD_SLASH = 47
BACKWARD_SLASH = 92

out_handle HANDLE ?
cells_written DWORD ?
xy_pos COORD <0,0>

buffer_size DWORD 6

; part 01
underscore_buffer BYTE 6 DUP(UNDERSCORE)
pipe_buffer BYTE PIPE, 4 DUP(SPACE), PIPE

; part 02
triangle_buffer_01 BYTE SPACE, SPACE, FORWARD_SLASH, BACKWARD_SLASH, SPACE, SPACE
triangle_buffer_02 BYTE SPACE, FORWARD_SLASH, SPACE, SPACE, BACKWARD_SLASH, SPACE
triangle_buffer_03 BYTE FORWARD_SLASH, SPACE, SPACE, SPACE, SPACE, BACKWARD_SLASH 

; part 03
window_buffer BYTE PIPE, SPACE, 79, SPACE, SPACE, PIPE
door_top_buffer BYTE PIPE, SPACE, SPACE, UNDERSCORE, UNDERSCORE, PIPE
door_buffer BYTE PIPE, 2 DUP(UNDERSCORE), 3 DUP(PIPE)

; part 04
square_size DWORD 3

square_attributes WORD 3 DUP(219)
square_top BYTE SPACE, UNDERSCORE, SPACE
square_bottom BYTE PIPE, UNDERSCORE, PIPE

.code

; helper method to print buffer given pointer
print_buffer PROC USES eax,
	p_x_position: WORD,
	p_y_position: WORD,
	buffer_address: PTR WORD

	mov ax, p_x_position
	mov xy_pos.X, ax
	mov ax, p_y_position
	mov xy_pos.Y, ax

	INVOKE WriteConsoleOutputCharacter,
		out_handle,
		buffer_address,
		buffer_size,
		xy_pos,
		ADDR cells_written

	ret
print_buffer ENDP

part_01 PROC
	INVOKE print_buffer, 0, 0, ADDR underscore_buffer
	INVOKE print_buffer, 0, 1, ADDR pipe_buffer
	INVOKE print_buffer, 0, 2, ADDR pipe_buffer
	INVOKE print_buffer, 0, 3, ADDR pipe_buffer
	INVOKE print_buffer, 0, 4, ADDR pipe_buffer
	INVOKE print_buffer, 0, 5, ADDR underscore_buffer

	ret
part_01 ENDP

print_slashes PROC USES eax,
	p_x_position: WORD,
	p_y_position: WORD,
	slash_array: PTR BYTE

	mov ax, p_x_position
	mov xy_pos.X, ax
	mov ax, p_y_position
	mov xy_pos.Y, ax

	INVOKE WriteConsoleOutputCharacter,
		out_handle,
		slash_array,
		buffer_size,
		xy_pos,
		ADDR cells_written

	ret
print_slashes ENDP

part_02 PROC
	INVOKE print_slashes, 0, 0, ADDR triangle_buffer_01
	INVOKE print_slashes, 0, 1, ADDR triangle_buffer_02
	INVOKE print_slashes, 0, 2, ADDR triangle_buffer_03

	ret
part_02 ENDP

part_03 PROC
	; roof
	INVOKE part_02

	; house
	INVOKE print_buffer, 0, 3, ADDR underscore_buffer
	INVOKE print_buffer, 0, 4, ADDR pipe_buffer
	INVOKE print_buffer, 0, 5, ADDR window_buffer
	INVOKE print_buffer, 0, 6, ADDR door_top_buffer
	INVOKE print_buffer, 0, 7, ADDR door_buffer

	ret
part_03 ENDP

print_square PROC
	; print square top

	INVOKE WriteConsoleOutputAttribute,
		out_handle,
		ADDR square_attributes,
		square_size,
		xy_pos,
		ADDR cells_written


	INVOKE WriteConsoleOutputCharacter,
		out_handle,
		ADDR square_top,
		square_size,
		xy_pos,
		ADDR cells_written

	; print square bottom

	inc xy_pos.Y

	INVOKE WriteConsoleOutputAttribute,
		out_handle,
		ADDR square_attributes,
		square_size,
		xy_pos,
		ADDR cells_written


	INVOKE WriteConsoleOutputCharacter,
		out_handle,
		ADDR square_bottom,
		square_size,
		xy_pos,
		ADDR cells_written

	dec xy_pos.Y ; reset y coordinate

	ret
print_square ENDP

random_position PROC
	call Randomize

	mov eax, 3
	call RandomRange

	cmp eax, 0
	je increment_x

	cmp eax, 1
	je decrement_x

	jmp y_procedure

increment_x:
	inc xy_pos.X
	jmp y_procedure

decrement_x:
	dec xy_pos.X
	jmp y_procedure

y_procedure:
	mov eax, 3
	call RandomRange

	cmp eax, 0
	je increment_y

	cmp eax, 1
	je decrement_y

	ret

increment_y:
	inc xy_pos.Y
	ret

decrement_y:
	dec xy_pos.Y
	ret

	ret
random_position ENDP

part_04 PROC
	mov xy_pos.X, 10
	mov xy_pos.Y, 10

move_loop:
	INVOKE print_square

	call random_position

	call Randomize
	mov eax, 91
	call RandomRange
	add eax, 10

	call Delay

	call ClrScr

	jmp move_loop

	ret
part_04 ENDP

main PROC
	INVOKE GetStdHandle, STD_OUTPUT_HANDLE
	mov out_handle, eax

	; please call procedures within here (after receiving handle, before ReadChar function call)
	; call part_01
	; call part_02
	; call part_03
	; call part_04

	call ReadChar
	INVOKE ExitProcess, 0
main ENDP


END main
