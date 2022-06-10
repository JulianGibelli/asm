.8086
.model small
.stack 100h
.data
	db 64 dup (' ')
	window_width dw 140h ;320px
	window_height dw 0c8h ;200px
	window_bounds dw 6    ;variable para chequear antes las colisiones

	time_aux db 0 ;variable auxiliar para chequear el cambio de tiempo
	
	ball_original_x dw 0a0h
	ball_original_y dw 64h
	ball_x dw 0a0h
	ball_y dw 64h
	ball_size dw 04h
	ball_speed_x dw 05h
	ball_speed_y dw 02h

	paddle_x dw 0ah
	paddle_y dw 0b4h

	paddle_width dw 1fh
	paddle_height dw 05h

	cartel db "  _______  _______  __    _  _______ ",0dh,0ah
		   db " |       ||       ||  |  | ||       |",0dh,0ah
		   db " |    _  ||   _   ||   |_| ||    ___|",0dh,0ah
		   db " |   |_| ||  | |  ||       ||   | __ ",0dh,0ah
		   db " |    ___||  |_|  ||  _    ||   ||  |",0dh,0ah
		   db " |   |    |       || | |   ||   |_| |",0dh,0ah
		   db " |___|    |_______||_|  |__||_______|",0dh,0ah
		   db "                                    ",0dh,0ah
		   db "                                    ",0dh,0ah
		   db "                                    ",0dh,0ah
		   db "                                    ",0dh,0ah
		   db "                                    ",0dh,0ah
		   db "      PRESIONE 'A' PARA INICIAR",0dh,0ah
		   db "        'ESC' PARA SALIR",0dh,0ah,24h



.code

	main proc

		mov ax, @data
		mov ds, ax

		call clear_screen
		
		mov ax,@data
		mov es,ax

		mov ah,13h
		mov al,00h
		mov bh,00
		mov bl,01h
		mov cx,520
		mov dh,0
		mov dl,0
		lea bp,cartel
		int 10h

	tecla:
		mov ah,00h
    	int 16h
		mov bx, ax
		cmp bx, 1E61h ;comparo con A
    	je inicio;si es A
		cmp bx,011Bh ;comparo con ESC
    	je fin
		jmp tecla

	inicio:

		check_time:
			mov ah, 2ch ;obtiene la hora del sistema
			int 21h     ;devuelve en CH=hora, CL=minutos DH=segundos, DL= 1/100 segundos

			cmp dl, time_aux ;comparar tiempo actual con el anterior(time_aux)
			je check_time    ;comparar de nuevo si es el mismo

			;si es diferente, dibuja y mueve...

			mov time_aux, dl ;actualiza el tiempo

			call clear_screen

			call move_ball
			call draw_ball

			call draw_paddle

			jmp check_time


		ret

		fin:
			mov ah,0
   			mov al,03h
    		int 10h

    		mov ax,4c00h
   			int 21h
	main endp

	draw_ball proc
		
		mov cx, ball_x ;configurar posicion inicial en x
		mov dx, ball_y ;configurar posicion inicial en x

		draw_ball_h:
			mov ah, 0ch 
			mov al, 0fh          ;color blanco para el pixel
			mov bh, 00h          ;numero de pagina
			int 10h

			inc cx
			mov ax, cx           ;cx - ball_x > ball_size (Verdadero-> movemos a la siguiente linea, Falso -> siguiente columna)
			sub ax, ball_x
			cmp ax, ball_size
			jng draw_ball_h

			mov cx, ball_x        ;vuelve a columna inicial
			inc dx               ;siguiente linea

			mov ax, dx           ;dx - ball_x > ball_size (Verdadero-> terminamos, Falso -> siguiente linea)
			sub ax, ball_y
			cmp ax, ball_size
			jng draw_ball_h



		ret

	draw_ball endp

	draw_paddle proc
		mov cx, paddle_x     ;columna inicial de pedal
		mov dx, paddle_y     ;fila inicial de pedal

		draw_paddle_h:

			mov ah, 0ch 
			mov al, 0fh          ;color blanco para el pixel
			mov bh, 00h          ;numero de pagina
			int 10h

			inc cx
			mov ax, cx           ;cx - paddle_x > paddle_width(Verdadero-> movemos a la siguiente linea, Falso -> siguiente columna)
			sub ax, paddle_x
			cmp ax, paddle_width
			jng draw_paddle_h

			mov cx, paddle_x        ;vuelve a columna inicial
			inc dx               ;siguiente linea

			mov ax, dx           ;dx - paddle y > paddle_height (Verdadero-> terminamos, Falso -> siguiente linea)
			sub ax, paddle_y
			cmp ax, paddle_height
			jng draw_paddle_h

			ret
	draw_paddle endp

	move_ball proc
		mov ax, ball_speed_x	        ;mueve la pelota horizontalmente
		add ball_x, ax

		mov ax, window_bounds
		cmp ball_x, ax	                ;ball_x < 0. Colision
		jl neg_speed_x  

		mov ax, window_width
		sub ax, ball_size 
		sub ax, window_bounds 
		cmp ball_x, ax                  ;ball_x > window_widht. Colision
		jg neg_speed_x

		mov ax, ball_speed_y	        ;mueve la pelota verticalmente
		add ball_y, ax

		mov ax, window_bounds
		cmp ball_y, ax		            ;ball_y < 0. Colision
		jl neg_speed_y

		mov ax, window_height
		sub ax, ball_size
		sub ax, window_bounds 
		cmp ball_y, ax                  ;ball_y > window_height. Colision
		jg reset_position

		ret

		neg_speed_x:
			neg ball_speed_x

			ret 

		neg_speed_y: 
			neg ball_speed_y

			ret

		reset_position:
			call reset_ball
			ret

	move_ball endp

	reset_ball proc
		mov ax, ball_original_x
		mov ball_x, ax

		mov ax, ball_original_y
		mov ball_y, ax

		ret

	reset_ball endp

	clear_screen proc
		mov ah, 00h ;configurar modo video
		mov al, 13h ;elegir modo video
		int 10h

		mov ah, 0bh 
		mov bh, 00h ;color de fondo
		mov bl, 00h
		int 10h

		ret
	clear_screen endp


	end main


