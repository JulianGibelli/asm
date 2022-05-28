.8086
.model small
.stack 100h

.data
	decimal db "124"
	dataMul db 100,10,1
	decReg db 0
	num db "000",24h
	asciiBin db "00000000",0dh,0ah,24h


.code
extrn asciiToReg:proc
extrn imprimir:proc
extrn regToAscii:proc
main proc
	mov ax,@data
	mov ds, ax


	lea bx,decimal
	lea di, dataMul
	lea si, decReg
	call asciiToReg

	mov bx,0
	mov si,0

	mov al,decReg ;pongo en AL el numero registro
	lea bx, asciiBin ;pongo el offset del binario ascii
	call regToBin

	mov bx,0
	mov si,0
	mov dx,0

	lea dx,asciiBin
	push dx
	call imprimir


	mov ax,4c00h
	int 21h
main endp

regToBin proc
;CONVIERTE UNA VARIABLE TIPO REGISTRO A UN ASCII DE 8 DIGITOS "01011010"
;REQUISITOS: MOVER A AL LA VARIABLE REGISTRO
			;PONER EN BX EL OFFSET A LA VARIABLE ASCII QUE TENDRA EL BINARIO 
	
		mov cx, bx						  ;Guardo la direcc a cx
		add cx, 8                         ; cx+8   reng 18: _ _ _ [8]
arriba:
		cmp bx, cx                        ; bx = reng 18: [8]
		je finLaburo
		shr al, 1
		jc esUno
		mov byte ptr [bx],30h; un 0;
continua:
		inc bx
		jmp arriba		


esUno:
		mov byte ptr [bx],31h;un 1;
		jmp continua

finLaburo:	
	ret
regToBin endp

end