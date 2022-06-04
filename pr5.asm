.8086
.model small
.stack 100h


.data
	var db 255 dup('$'),0dh,0ah,24
	decReg db 0
	asciiDec db "000",0dh,0ah,24h
	salto db 0ah,0dh,24h

.code
extrn ingreso:proc
extrn regToAscii:proc
extrn imprimir:proc
main proc
	mov ax,@data
	mov ds, ax

	lea bx, var ;coloco el offset de la variable a llenar
	call ingreso ;llamo a la funcion

	
	lea bx, var ;coloco el offset de la variable a llamar
	lea si, decReg
	mov cl, 61h ;caracter a buscar
	call cuenta_cosas ;funcion que cuenta

	lea bx, decReg
	lea si,asciiDec
	call regToAscii

	lea dx,asciiDec
	push dx
	call imprimir

	mov ax,4c00h
	int 21h
main endp

cuenta_cosas proc
	push cx
	busco:
		cmp byte ptr[bx],24h
		je termine
		cmp byte ptr[bx],cl ;en cl poner lo que busco
		je encontre
		inc bx
		jmp busco


	encontre:
		add byte ptr[si],1
		inc bx
		jmp busco

	termine:
		pop cx
		ret

cuenta_cosas endp	
end