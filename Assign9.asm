%macro scall 4
mov rax,%1
mov rdi,%2
mov rsi,%3
mov rdx,%4
syscall
%endmacro

section .data
msg1: db "Factorial of number is::",10
len1:equ $-msg1

newline db 10

section .bss
a resq 01
b resq 01
count resb 02
ans resb 16
count1 resb 02

section .text
global _start
_start:

pop rbx
pop rbx
pop rbx

mov rax,qword[rbx]
mov qword[a],rax

mov rsi,a
call atoh
mov byte[b],al

xor rbx,rbx

mov bl,byte[b]

xor rax,rax
mov rax,1
up1:

cmp rbx,1
je next1
mul rbx
dec rbx
jmp up1

next1:
mov rbx,rax
call htoa
scall 1,1,msg1,len1
scall 1,1,ans,16
scall 60,0,0,0


htoa:

mov byte[count1],16
mov rdi,ans
up2:
rol rbx,04
mov cl,bl
and cl,0fh
cmp cl,9h
jbe next2
add cl,7h

next2:
add cl,30h
mov byte[rdi],cl
inc rdi
dec byte[count1]
jnz up2
ret




atoh:

mov byte[count],02
xor rax,rax
xor rdx,rdx

up:

rol al,04
mov dl,byte[rsi]
cmp dl,39h
jbe next
sub dl,7h

next:
sub dl,30h
add ax,dx
inc rsi
dec byte[count]
jnz up
ret
