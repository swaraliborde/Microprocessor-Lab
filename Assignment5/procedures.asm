%macro scall 4
mov rax,%1
mov rdi,%2
mov rdi,%3
mov rdx,%4
syscall
%endmacro

global spa,li,freq,answer

section .data
msg0: db"Enter the character::",10
len0 equ $-msg0


section .bss
character:resb 02
answer resb 02

section .text

extern buffer,datalen

spa:
	xor rax,rax
	xor rbx,rbx
	xor rcx,rcx
mov rsi,buffer
mov rcx,[datalen]

up:
	cmp byte[rsi],20h
	jne next
	inc ax
next:
	inc rsi
	loop up

mov word[answer],ax
ret

li:
	xor rax,rax
	xor rbx,rbx
	xor rcx,rcx
mov rsi,buffer
mov rcx,[datalen]

up1:
	cmp byte[rsi],10
	jne next1
	inc ax
next1:
	inc rsi
	loop up1
mov word[answer],ax
ret

freq:
	xor rax,rax
	xor rbx,rbx
	xor rcx,rcx
xor rdx,rdx
scall 1,1,msg0,len0
	scall 0,1,character,02
mov dl,byte[character]

mov rsi,buffer
mov rcx,[datalen]


up2:
	cmp byte[rsi],dl
	jne next2
	inc ax
next2:
	inc rsi
	loop up2
mov word[answer],ax
ret


