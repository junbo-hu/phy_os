;hello-os
;TAB=4

	org 0x7c00
	
	jmp entry
entry:
	mov ax,0
	mov ss,ax
	mov sp,0x7c00
	mov ds,ax
	mov es,ax

	mov si,msg
putloop:
	mov al,[si]
	add si,1
	cmp al,0

	je fin
	mov ah,0x0e
	mov bx,15
	int 0x10
	jmp putloop
fin:
	hat
	jmp fin
msg:
	db 0x0a,0x0a
	db "hello,world"
	db 0x0a
	db 0
	
