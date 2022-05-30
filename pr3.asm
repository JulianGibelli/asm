.8086
.model small
.stack 100h

.data
	var db "251",0dh,0ah,24h
	DataMul db 100,10,1
	decReg db 0
	indice dw 7
	asciinario db "00000000",24h
	salto db 0ah,0dh,24h
.code
extrn imprimir:proc
extrn asciiToReg:proc
extrn regToBin:proc
main proc
	mov ax,@data
	mov ds, ax

	lea bx,var
	lea di,DataMul
	lea si,decReg
	call asciiToReg


	mov dx,0
	lea dx,var
	push dx
	call imprimir


	mov dx,0
	lea dx,salto
	push dx
	call imprimir


	mov dx,0
	lea dx,decReg
	push dx
	call imprimir

	mov ax,0
	mov si,0
	mov bx,0

	mov al, decReg
	mov bx,indice
	lea si, asciinario
	call regToBin

	mov dx,0
	lea dx,salto
	push dx
	call imprimir

	mov dx,0
	lea dx,asciinario
	push dx
	call imprimir


	mov ax,4c00h
	int 21h
main endp
end