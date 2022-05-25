.8086
.model small
.stack 100h

.data
	x db 160
	y db 100
	color db 4,9
.code
main proc
	mov ax, @data
	mov ds,ax

	;set the video mode 320x200 mode 13h
	mov ah,00h
	mov al,13h
	int 10h

	lea bx,x
	lea si,y
	lea di,color
	mov cx,5
dibujar:
	call draw
	inc byte ptr[bx]
	;inc byte ptr[si]
	loop dibujar	

;---------segunda--------
	mov cx,1000
nada:
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	loop nada

	lea bx,x
	lea si,y
	lea di,color+1
	mov cx,5
dibujar2:
	call draw
	inc byte ptr[bx]
	;inc byte ptr[si]
	;inc si
	loop dibujar2	

	;wait for a key press
	mov ah,00h
	int 16h

	;set the video mode to text mode
	mov ah,00h
	mov al,03h
	int 10h

	mov ax,4c00h
	int 21h
main endp


draw proc
	push cx
	push ax
	push dx
	;draw pixel 160column - 100 row - color red
	mov ah,0ch
	mov cx,[bx] ;columna
	mov dx,[si];fila
	mov al,[di];color
	int 10h

	pop dx
	pop ax
	pop cx
	ret

draw endp
end