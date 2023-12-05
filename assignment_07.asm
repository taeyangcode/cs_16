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
triangle_buffer_03 BYTE FORWARD_SLASH, 4 DUP(UNDERSCORE), BACKWARD_SLASH 

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

; helper function to print buffer given pointer
print_buffer PROC USES eax,
	p_x_position: WORD,
	p_y_position: WORD,
	buffer_address: PTR WORD

	mov ax, p_x_position
	mov xy_pos.X, ax			; move x position argument into COORDS struct
	mov ax, p_y_position
	mov xy_pos.Y, ax			; move y position argument into COORDS struct

	INVOKE WriteConsoleOutputCharacter,	; print out the buffer argument at position specified
		out_handle,
		buffer_address,
		buffer_size,
		xy_pos,
		ADDR cells_written

	ret
print_buffer ENDP

part_01 PROC
	INVOKE print_buffer, 0, 0, ADDR underscore_buffer	; print top width
	INVOKE print_buffer, 0, 1, ADDR pipe_buffer		; print height segment
	INVOKE print_buffer, 0, 2, ADDR pipe_buffer		; print height segment
	INVOKE print_buffer, 0, 3, ADDR pipe_buffer		; print height segment
	INVOKE print_buffer, 0, 4, ADDR pipe_buffer		; print height segment
	INVOKE print_buffer, 0, 5, ADDR underscore_buffer	; print bottom width

	ret
part_01 ENDP

part_02 PROC
	INVOKE print_buffer, 0, 0, ADDR triangle_buffer_01	; print triangle top
	INVOKE print_buffer, 0, 1, ADDR triangle_buffer_02	; print triangle middle
	INVOKE print_buffer, 0, 2, ADDR triangle_buffer_03	; print triangle bottom

	ret
part_02 ENDP

part_03 PROC
	; roof
	INVOKE part_02						; use triangle as roof

	; house
	INVOKE print_buffer, 0, 3, ADDR pipe_buffer		; print walls
	INVOKE print_buffer, 0, 4, ADDR window_buffer		; print walls and circle window
	INVOKE print_buffer, 0, 5, ADDR door_top_buffer		; print walls and top side of door
	INVOKE print_buffer, 0, 6, ADDR door_buffer		; print floor and door sides

	ret
part_03 ENDP

print_square PROC
	; print square top

	INVOKE WriteConsoleOutputAttribute,		; print out background color of square on first row
		out_handle,
		ADDR square_attributes,
		square_size,
		xy_pos,
		ADDR cells_written


	INVOKE WriteConsoleOutputCharacter,		; print out square sides and top width
		out_handle,
		ADDR square_top,
		square_size,
		xy_pos,
		ADDR cells_written

	; print square bottom

	inc xy_pos.Y	; increment Y coordinate to adjust for second row of square

	INVOKE WriteConsoleOutputAttribute,		; print out background color of square on second row
		out_handle,
		ADDR square_attributes,
		square_size,
		xy_pos,
		ADDR cells_written


	INVOKE WriteConsoleOutputCharacter,		; print out square bottom
		out_handle,
		ADDR square_bottom,
		square_size,
		xy_pos,
		ADDR cells_written

	dec xy_pos.Y	; reset y coordinate

	ret
print_square ENDP

random_position PROC
	call Randomize		; reseed randomizer

	mov eax, 3		; set random number range [0, 2) : 3 possible states: increment, decrement, no change
	call RandomRange	; get random range

	cmp eax, 0		; if 0 -> increment x
	je increment_x

	cmp eax, 1		; if 1 -> decrement x
	je decrement_x

	jmp y_procedure		; if 2 -> don't change x, change y

increment_x:
	inc xy_pos.X		; increment x coordinate
	jmp y_procedure		; change y

decrement_x:
	dec xy_pos.X		; decrement x coordinate
	jmp y_procedure		; change y

y_procedure:
	mov eax, 3		; same logic as determining how to change x
	call RandomRange

	cmp eax, 0
	je increment_y

	cmp eax, 1
	je decrement_y

	ret

increment_y:
	inc xy_pos.Y		; increment y coordinate
	ret			; return

decrement_y:
	dec xy_pos.Y		; decrement y coordinate
	ret			; return

	ret
random_position ENDP

part_04 PROC
	mov xy_pos.X, 10		; starting x position
	mov xy_pos.Y, 10		; starting y position

move_loop:
	INVOKE print_square		; print square at current position

	call random_position		; get a new random number for next iteration

	call Randomize			; reseed to find random number [10, 100]
	mov eax, 91			; formula: random_number = random(max - min + 1) + min
	call RandomRange
	add eax, 10

	call Delay			; delay for random number amount of milliseconds [10, 100]

	call ClrScr			; clear screen for next iteration

	jmp move_loop			; repeat move loop

	ret
part_04 ENDP

main PROC
	INVOKE GetStdHandle, STD_OUTPUT_HANDLE	; get std handle
	mov out_handle, eax

	; please call procedures within here (after receiving handle, before ReadChar function call)
	; call part_01
	; call part_02
	; call part_03
	; call part_04

	call ReadChar				; call ReadChar function to preserve terminal stdout
	INVOKE ExitProcess, 0
main ENDP

END main
