%macro scall 4
mov rax,%1
mov rdi,%2
mov rsi,%3
mov rdx,%4
%endmacro

section .data
menu:db "1.Display block before data transfer",10
	db "2.Non-overlapped without string instruction",10
	db "3.Non-overlapped with string instruction",10
	db "4.Exit",10
menulen:equ $-menu

msg1:db "Block before data transfer::",10
len1:equ $-msg1

msg2:db "Block after data transfer",10
len2:equ $-msg2

colon:db ":"
colonlen equ $-colon

newline:db " ",10
newlinelen equ $-newline

count db 00

array1 db 1234567891234567h,0fffffff12345678h,1029384756123456h,123451234512345678h,0h,0h,0h,0h,0h



section .bss
value resb 16
choice resb 2
address resb 16
section .text
global _start
_start:

;----------INITIAL ADDRESS----------------;

mov rsi,array
mov byte[count],4

up:

mov rdx,rsi
push rsi
call htoa1
pop rsi
mov rdx,qword[rsi]
push rsi
call htoa2
pop rsi

add rsi,8
dec byte[count]
jnz up


;------------CHOICE-------------;

scall 1,1,menu,menulen

repeat:
scall 0,1,choice,02

	cmp byte[choice],31h
	je Display

	cmp byte[choice],32h
	je next1

	cmp byte[choice],33h
	je next2

	cmp byte[choice],34h
	je exit

loop repeat

;----------NON OVERLAPP WITHOUT STRING---------;
mov rsi,array
mov rdi,array+40

mov byte[count],5

up1:

mov rax,qword[rsi]
mov qword[rdi],rax

add rsi,8
add rdi,8
dec byte[count]
jnz up1

;-----PRINT IT-----------;
xor rsi,rsi
mov rsi,array+48
mov byte[count],4

up2:

mov rdx,rsi
push rsi
call htoa1
pop rsi
mov rdx,qword[rsi]
push rsi
call htoa2
pop rsi

add rsi,8
dec byte[count]
jnz up

;-----------NON OVERLAPP WITH STRING----;
mov rsi,array+24
mov rdi,array+40

mov byte[count],5
cld
rep movsq 

;-----PRINT IT-----------;
xor rsi,rsi
mov rsi,array+48
mov byte[count],4

up2:

mov rdx,rsi
push rsi
call htoa1
pop rsi
mov rdx,qword[rsi]
push rsi
call htoa2
pop rsi

add rsi,8
dec byte[count]
jnz up

;----------OVERLAP WITHOUT STRING----------;


mov rsi,array+24
mov rdi,array+48

mov byte[count],4

up1:

mov rax,qword[rsi]
mov qword[rdi],rax

sub rdi,8
sub rsi,8

dec byte[count]
jnz up1

;-----PRINT IT-----------;
xor rsi,rsi
mov rsi,array+16
mov byte[count],4

up2:

mov rdx,rsi
push rsi
call htoa1
pop rsi
mov rdx,qword[rsi]
push rsi
call htoa2
pop rsi

add rsi,8
dec byte[count]
jnz up

;----------OVERLAP WITHOUT STRING----------;


mov rsi,array+24
mov rdi,array+48

mov rcx,4

std
rep movsq
;-----PRINT IT-----------;
xor rsi,rsi
mov rsi,array+16
mov byte[count],4

up2:

mov rdx,rsi
push rsi
call htoa1
pop rsi
mov rdx,qword[rsi]
push rsi
call htoa2
pop rsi

add rsi,8
dec byte[count]
jnz up







mov rax,60
mov rdi,0
syscall






