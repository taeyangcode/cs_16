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

; function that draws a row of a chessboard beginning with white and then color
; accepts a variable color parameter to represent the colored squares
white_color_row PROTO,
	p_x: BYTE,
	p_color: DWORD,

; function that draws a row of a chessboard beginning with color and then white
; accepts a variable color parameter to represent the colored squares
color_white_row PROTO,
	p_x: BYTE,
	p_color: DWORD,

; draw a complete chess board accepting a parameter color for the colored squares
draw_board PROTO,
	p_color: DWORD

white_color_row PROC USES eax edx,
	p_x: BYTE,
	p_color: DWORD

	mov dh, p_x			; draw row starting from the x coordinate parameter
	mov dl, 0			; begin drawing squares from y coordinate 0

DRAW_ROW:
	call Gotoxy			; begin by moving to current position

	mov eax, white * 16		; change background color to white
	call SetTextColor		; set background color to white

	mov al, ' '			; move space character to write onto screen
	call WriteChar			; draw space character

	inc dl				; increment y coordinate to draw next square

	call Gotoxy			; move to next position

	mov eax, p_color		; change background color to specified color parameter
	shl eax, 4			; multiply by 16 to get background color value
	call SetTextColor		; set background color to parameter

	mov al, ' '			; move space character to write
	call WriteChar			; draw space character

	inc dl				; increment y coordinate to draw next square

	cmp dl, 7			; if 8 squares have been draw -> exit function
	jae EXIT_FUNCTION

	jmp DRAW_ROW			; else -> loop

EXIT_FUNCTION:
	mov eax, black			; change text color to black to prevent drawing more characters to terminal
	call SetTextColor

	ret
white_color_row ENDP

color_white_row PROC USES eax edx,	; function uses same logic as white_color_row with only the drawing order swapped
	p_x: BYTE,
	p_color: DWORD
	
	mov dh, p_x
	mov dl, 0

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

	mov eax, 0					; initialize row counter

DRAW_ROWS:
	INVOKE white_color_row, al, p_color		; draw white/color row using parameter color
	inc eax						; increment row counter

	INVOKE color_white_row, al, p_color		; draw color/whtie row using parameter color
	inc eax						; increment row counter

	cmp eax, 7					; if 8 rows have been draw -> exit function
	jae EXIT_FUNCTION

	jmp DRAW_ROWS					; else -> draw more rows

EXIT_FUNCTION:
	ret
draw_board ENDP

part_01 PROC
	INVOKE draw_board, gray		; draw gray chessboard

	ret
part_01 ENDP

part_02 PROC USES eax ebx
	mov ebx, 0			; initialize color tracker

DRAW_BOARDS:
	INVOKE draw_board, ebx		; draw chessboard with current color
	inc ebx				; increment color tracker

	mov eax, 500			; 500 millisecond delay
	call Delay

	cmp ebx, 15			; if 16 colors have been displayed -> exit function
	jae EXIT_FUNCTION

	jmp DRAW_BOARDS			; else -> draw next chessboard
	
EXIT_FUNCTION:
	ret
part_02 ENDP

main PROC
	; call part_01
	; call part_02

	INVOKE ExitProcess, 1
main ENDP

END main
