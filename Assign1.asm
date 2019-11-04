%macro scall 4
mov rax,%1
mov rdi,%2
mov rsi,%3
mov rdx,%4
syscall
%endmacro

section .data

msg1:db "Count of positive number is::",10
len1: equ $-msg1

msg2:db "Count of negative number is::",10
len2:equ $-msg2

array: dq 1234567891234567h,9876543211234567h,0ffffffff12345678h,9999998888887777h

pcount: db 00
ncount: db 00


section .bss
num resb 02


section .text
global _start
_start:

mov rsi,array
mov rcx,04

up:

bt qword[rsi],63
jnc l1

inc byte[ncount]
jmp l2

l1:
inc byte[pcount]
l2:
add rsi,8
loop up

mov bl,byte[pcount]
call htoa
scall 1,1,msg1,len1
scall 1,1,num,02

mov bl,byte[ncount]
call htoa
scall 1,1,msg2,len2
scall 1,1,num,02


mov rax,60
mov rdi,0
syscall


htoa:

mov rdi,num
mov rcx,02

	up1:
		rol bl,04
		mov al,bl
		and al,0fh
		cmp al,09h
		jbe next
		add al,7h
	next:
		add al,30h
		mov byte[rdi],l
		inc rdi
		loop up1
RET

