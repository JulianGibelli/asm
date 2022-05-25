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

	lea bx,decReg ;pongo el offset al numero registro
	lea si, asciiBin ;pongo el offset del binario ascii
	call regToBin

	mov bx,0
	mov si,0

	;lea bx,decReg
	;lea si,num
	;call regToAscii
	mov dx,0

	lea dx,asciiBin
	push dx
	call imprimir


	mov ax,4c00h
	int 21h
main endp

regToBin proc
	push ax
	push cx

	xor ax,ax
	xor cx,cx
	mov al,[bx] ;le pongo el numero en registro a dividir
	add si,7;incremento el offset de SI en 7 "_ _ _ _ _ _ _ X"

aca:
	mov cl,2 ;preparo cl para dividir
	div cl ;divido por 2
	add ah,30h ;al resto 0/1 le sumo 30h
	mov [si],ah ;muevo el resto a la ultima posicion
	dec si
	cmp al,1 ;comparo el cociente contra 1 para saber si termine
	ja aca
	add al,30h ;le sumo al 1 30h	
	mov [si],al
	
	pop cx
	pop ax
	ret
regToBin endp

end