.8086
.model small
.stack 100h
.data

.code
public imprimir
public ingreso
public asciiToReg
public regToAscii
public ascii2hexa

imprimir proc
;FUNCION IMPRESION DE TEXTO
;REQUISITO: ENVIAR PREVIAMENTE EL OFFSET EN DX A LA PILA DEL CARTEL A IMPRIMIR

	;------
	;  BP
	;------
	;  IP
	;------
	; OFFSET CARTEL (DX
	;_______

	push bp ;guardo bp en el stack
	mov bp, sp ; le doy a bp el valor de sp
	mov ah,9
	mov dx, ss:[bp+4] ;accedo al parametro 4bytes atras
	int 21h
	pop bp
	ret 2
imprimir endp
;-------------------------------------------------------------------
ingreso proc
;FUNCION INGRESO/CARGA DE TEXTO
;REQUISITO: COLOCAR PREVIAMENTE EL OFFSET EN BX DE LA VARIABLE A LLENAR
;COMPARA CONTRA ENTER Y 255 CARACTERES
	push ax
carga:
	cmp bx,255
	je finCarga
	mov ah,1
	int 21h
	cmp al, 0dh
	je finCarga
	mov [bx],al
	inc bx
	jmp carga

finCarga:	
	pop ax
	ret
ingreso endp
;-------------------------------------------------------------------
asciiToReg proc
;REQUISITO:COLOCAR EN BX EL OFFSET AL ASCII A CONVERTIR
		  ;COLOCAR EN DI EL OFFSET A DATAMUL (100,10,1)
		  ;COLOCAR EN SI EL OFFSET AL REGISTRO ACUMULADOR
	push ax
	push cx

arriba:
	cmp bx, 3
	je termine
	xor ax,ax
	xor cx,cx
	mov cl,[di]
	mov al,[bx]
	sub al, 30h
	mul cl
	add [si],al
	inc bx
	inc di
	jmp arriba

termine:
	pop cx
	pop ax
	ret
asciiToReg endp
;------------------------------------------------------------------
regToAscii proc
;REQUISITO: COLOCAR EN BX EL OFFSET A LA VARIABLE REGISTRO 
		   ;COLOCAR EN SI EL OFFSET A LA VARIABLE QUE CONTENDRA EL ASCII
	push ax
	push cx
	push dx

	mov cx,3 
	xor ax,ax
	mov al,[bx]
aConvertir:
	xor dx,dx
	mov dl,10
	div dl
	add ah,30h
	mov [si+2],ah
	xor ah,ah
	dec si
	loop aConvertir
pop dx
pop cx
pop ax
ret
regToAscii endp
;-----------------------------------------------------------
ascii2hexa proc
;REQUISITO: COLOCAR EN BX EL OFFSET A LA VARIABLE QUE CONTIENE EL ASCII A CONVERTIR
		   ;COLOCAR EN SI EL OFFSET A LA VARIABLE QUE ALOJARA EL HEXA EN ASCII
	push ax
	push cx

	xor ax,ax ;plancho ah y al
	mov cl,16 ;preparo cl para dividir
	mov al,[bx] ;coloco en al el valor que tiene bx
	div cl
	add al,30h
	mov [si],al

	mov al,ah
	cmp al,9
	jbe deUna
	add al,55
	mov [si+1],al
	jmp final


deUna:
	add al,30h
	inc si
	mov [si],al	

final:
	pop cx
	pop ax
	ret

ascii2hexa endp
;---------------------------------------------------
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

