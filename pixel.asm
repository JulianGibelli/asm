.8086
.model small
.stack 100h

.data

.code
main proc
    mov ax,@data
    mov ds,ax

;entro en modo video 320x200-segun AL 13h
    mov ah,0
    mov al,13h
    int 10h
;dibujo un pixel e la columna 100 fila 100 con color 9
    mov ah,0ch
    mov cx,100
    mov dx,100
    mov si,0

    mov al,9 ;seteo color

dibujo:
    cmp cx,-200
    je finDibujo
    cmp dx,0
    je findibujo
    int 10h
    call direccion
    cmp bx, 1177h ;hacia arriba
    je haciaArriba
    cmp bx, 1E61h ;haca izq
    je haciaIzq
    cmp bx,2064h;hacia derecha
    je haciaDer
    cmp bx,1F73h
    je haciaAbajo
    cmp bx,011Bh
    je findibujo
    cmp bx, 3920h
    je cambiaColor
aca:    
    jmp dibujo

haciaArriba:
    dec dx
    jmp dibujo

haciaIzq:
    dec cx
    jmp dibujo

haciaDer:
    inc cx
    jmp dibujo

haciaAbajo:
    inc dx
    jmp dibujo

cambiaColor:
    cmp si,1
    je change
    mov al,0
    mov si,1
    jmp dibujo

change:
    mov al,9
    mov si,0
    jmp dibujo

finDibujo:
;espero por una tecla para continuar con la instruccion 16h

    mov ah,00h
    int 16h

;vuelvo al modo de consola de texto para terminar

    mov ah,0
    mov al,03h
    int 10h

    mov ax,4c00h
    int 21h
main endp

direccion proc
    push ax
    mov al,0
    mov ah,0
    int 16h
    mov bx,ax
    pop ax
    ret
direccion endp
end