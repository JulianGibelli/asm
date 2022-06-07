.8086
.model small
.stack 100h

.data
	asciiBin db "10010001"
	decReg db 0
	asciiDec db "000",0dh,0ah,24h
	vecMul db 128,64,32,16,8,4,2,1

.code
extrn imprimir:proc
extrn regToAscii:proc
main proc
	mov ax, @data
	mov ds, ax

	lea bx,asciiBin ;el binario en ascii
	lea si, decReg ;el registro acumulador
	lea di,vecMul ;el vector con las bases
	call binToAscii

	lea bx,decReg
	lea si, asciiDec
	call regToAscii

	lea dx,asciiDec
	push dx
	call imprimir



	mov ax, 4c00h
	int 21h
main endp
binToAscii proc
	push ax
	push dx
	mov cx,8
aca3:
	mov al,[bx] ;muevo a AL el primer ascii binario a multiplicar
	sub al,30h ;le resto 30h al "1" o "0"
	mov dl, [di] ;muevo a DL el primer 128 para hacer la multiplicacion
	mul dl
	add [si],al
	inc bx
	inc di
	loop aca

	pop dx
	pop ax
	ret

binToAscii endp

end