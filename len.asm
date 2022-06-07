.8086
.model small
.stack 100h


.data
	texto db 255 dup('$'),24h
	decReg db 0
	asciiDec db "000",0dh,0ah,24h
.code
extrn ingreso:proc
extrn imprimir:proc
extrn regToAscii:proc
main proc
	mov ax,@data
	mov ds, ax

	lea bx, texto
	call ingreso

	lea bx, texto
	lea si, decReg
	call len

	lea bx, decReg
	lea si,asciiDec
	call regToAscii

	lea dx,asciiDec
	push dx
	call imprimir

	mov ax,4c00h
	int 21h
main endp
len proc
	
up:
	cmp byte ptr[bx],24h
	je finish
	add byte ptr[si],1
	inc bx
	jmp up
finish:	
	ret
len endp
end