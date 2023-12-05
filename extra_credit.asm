; Extra Credit Assignment

; Program Description: This extra credit assignment allows you to further incorporate graphical components in assembly language.
; Author: Corey Mostero 2566652
; Creation Date: 04 December 2023
; Revisions: N/A
; Date: 11 December 2023

.386
.model flat, stdcall
.stack 4096
ExitProcess PROTO, dwExitCode: DWORD

INCLUDE Irvine32.inc

.data

.code

white_color_row PROTO,
	p_x: BYTE,
	p_color: DWORD,

color_white_row PROTO,
	p_x: BYTE,
	p_color: DWORD,

draw_board PROTO,
	p_color: DWORD

white_color_row PROC USES eax edx,
	p_x: BYTE,
	p_color: DWORD

	mov dh, p_x
	mov dl, 0

	mov ecx, 4

DRAW_ROW:
	call Gotoxy

	mov eax, white * 16
	call SetTextColor

	mov al, ' '
	call WriteChar

	inc dl

	call Gotoxy

	mov eax, p_color
	shl eax, 4
	call SetTextColor

	mov al, ' '
	call WriteChar

	inc dl

	cmp dl, 7
	jae EXIT_FUNCTION

	jmp DRAW_ROW

EXIT_FUNCTION:
	mov eax, black
	call SetTextColor

	ret
white_color_row ENDP

color_white_row PROC USES eax edx,
	p_x: BYTE,
	p_color: DWORD
	
	mov dh, p_x
	mov dl, 0

	mov ecx, 4

DRAW_ROW:
	call Gotoxy

	mov eax, p_color
	shl eax, 4
	call SetTextColor

	mov al, ' '
	call WriteChar

	inc dl

	call Gotoxy

	mov eax, white * 16
	call SetTextColor

	mov al, ' '
	call WriteChar

	inc dl

	cmp dl, 7
	jae EXIT_FUNCTION

	jmp DRAW_ROW

EXIT_FUNCTION:
	mov eax, black
	call SetTextColor
	call CrlF

	ret
color_white_row ENDP

draw_board PROC USES eax,
	p_color: DWORD

	mov eax, 0

DRAW_ROWS:
	INVOKE white_color_row, al, p_color
	inc eax

	INVOKE color_white_row, al, p_color
	inc eax

	cmp eax, 7
	jae EXIT_FUNCTION

	jmp DRAW_ROWS

EXIT_FUNCTION:
	ret
draw_board ENDP

part_01 PROC
	INVOKE draw_board, gray

	ret
part_01 ENDP

part_02 PROC USES eax ebx
	mov ebx, 0

DRAW_BOARDS:
	INVOKE draw_board, ebx
	inc ebx

	mov eax, 500
	call Delay

	cmp ebx, 15
	jae EXIT_FUNCTION

	jmp DRAW_BOARDS
	
EXIT_FUNCTION:
	ret
part_02 ENDP

main PROC
	; call part_01
	call part_02

	INVOKE ExitProcess, 1
main ENDP

END main
