.8086
.model small
.stack 100h

.data
    x db 10
    y db 100
    color db 3,0
    cartel db "PERDISTE",24h
    
.code
main proc
    mov ax,@data
    mov ds,ax

    ;entro en modo video 320x200-segun AL 13h
    mov ah,0
    mov al,13h
    int 10h
    
    ;posiciono el cursor en la fila y columna 100
    call setCursor 

    lea si,color ;coloca el offset al color 3 para el caracter

    call imprimirCaracter ;imprimo por primera vez el caracter en pantalla
arriba:
    cmp x,0
    je enemyX
segui:  
    call scanCode ;tomo el scanCode
    cmp bx,1177h;comparo con W
    je haciaArriba ;si es W
    cmp bx,1F73h ;comparo con S
    je haciaAbajo;si es S
    cmp bx, 1E61h ;comparo con A
    je haciaIzq;si es A
    cmp bx,2064h;comparo con D
    je haciaDer;si es D
    cmp bx,011Bh ;comparo con ESC
    je findibujo 
    jmp arriba

haciaArriba:
    inc si ;cambio el offset del color a 0 (NEGRO) para ocultar el caracter previo dibujado
    call imprimirCaracter ;llamo a imprimirCaracter para "borrar"
    dec y ;cambio la coordenada Y
    call setCursor ;muevo el cursor a la nueva posicion
    dec si ;vuelvo a cambiar a color 3
    call imprimirCaracter ;llamo a imprimirCaracter
    jmp arriba ;vuelvo arriba

haciaAbajo:
    inc si ;cambio el offset del color a 0 (NEGRO) para ocultar el caracter previo dibujado
    call imprimirCaracter ;llamo a imprimirCaracter para "borrar"
    inc y ;cambio la coordenada Y
    call setCursor ;muevo el cursor a la nueva posicion
    dec si ;vuelvo a cambiar a color 3
    call imprimirCaracter ;llamo a imprimirCaracter
    jmp arriba ;vuelvo arriba

haciaIzq:
    inc si ;cambio el offset del color a 0 (NEGRO) para ocultar el caracter previo dibujado
    call imprimirCaracter ;llamo a imprimirCaracter para "borrar"
    dec x ;cambio la coordenada Y
    call setCursor ;muevo el cursor a la nueva posicion
    dec si ;vuelvo a cambiar a color 3
    call imprimirCaracter ;llamo a imprimirCaracter
    jmp arriba ;vuelvo arriba

haciaDer:
    inc si ;cambio el offset del color a 0 (NEGRO) para ocultar el caracter previo dibujado
    call imprimirCaracter ;llamo a imprimirCaracter para "borrar"
    inc x ;cambio la coordenada Y
    call setCursor ;muevo el cursor a la nueva posicion
    dec si ;vuelvo a cambiar a color 3
    call imprimirCaracter ;llamo a imprimirCaracter
    jmp arriba ;vuelvo arriba

enemyX:
    cmp y,100
    je HIT
    jmp segui

HIT:
    call imprimirEnemigo
    jmp findibujo

finDibujo:
    mov x,-150
    mov y, -150
    call setCursor
    mov ah,09h
    lea dx,cartel
    int 21h
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

setCursor proc
    mov ah,02h
    mov bh,0
    mov dh,y
    mov dl,x
    int 10h
setCursor endp

imprimirCaracter proc
    push ax
    push bx
    push cx
    ;dibujo un caracter en la posicion donde se encuentre el cursor
    mov ah,0ah
    mov al,'*'
    mov bl,[si]
    mov cx,1
    int 10h

    pop cx
    pop bx
    pop ax
    ret
imprimirCaracter endp

scanCode proc
    push ax
    mov al,0
    mov ah,0
    int 16h
    mov bx,ax
    pop ax
    ret
scanCode endp

imprimirEnemigo proc
    push ax
    push bx
    push cx
    ;dibujo un caracter en la posicion donde se encuentre el cursor
    mov ah,0ah
    mov al,'+'
    mov bl,6
    mov cx,1
    int 10h

    pop cx
    pop bx
    pop ax
    ret
imprimirEnemigo endp

end