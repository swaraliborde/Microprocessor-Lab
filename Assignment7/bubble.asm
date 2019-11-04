%macro scall 4
mov rax,%1
mov rdi,%2
mov rsi,%3
mov rdx,%4
syscall
%endmacro

section .data

menu:db "Enter the choice::",10
	db "1.Ascending order",10
	db "2.Descending order",10
	db "3.Exit",10
menulen equ $-menu

msg1:db "Error in opening file",10
len1: equ $-msg1

msg2:db "Ascending order is performed!",10
len2: equ $-msg2

msg3:db "Descending order is performed!",10
len3: equ $-msg3

fname: db 'xyz.txt',0


section .bss

choice:resb 02
count:resb 02
count1:resb 02
fd_in:resb 10
buffer:resb 100
datalen:resb 100


section .text

global _start

_start:

scall 2,fname,2,0777

bt rax,63
jnc l1
scall 1,1,msg1,len1
jmp exit
l1:
mov qword[fd_in],rax

scall 0,[fd_in],buffer,100
mov qword[datalen],rax

repeat:
scall 1,1,menu,menulen
scall 0,1,choice,02

cmp byte[choice],31h
je ascen

cmp byte[choice],32h
je descen

cmp byte[choice],33h
jmp exit

;---------------------ASCENDING ORDER-------------------------;

ascen:

mov byte[count],05h

outer:

mov rsi,buffer
mov rdi,buffer+2

xor rcx,rcx
mov rcx,05h

inner:

mov al,byte[rsi]
mov bl,byte[rdi]

cmp al,bl
ja abov

jmp l4

abov:
mov byte[rsi],bl
mov byte[rdi],al
l4:
add rsi,2
add rdi,2

loop inner
dec byte[count]
jnz outer

scall 1,1,msg2,len2
scall 1,qword[fd_in],buffer,qword[datalen]
jmp repeat

;-----------------------DESCENDING ORDER--------------------------;

descen:

mov byte[count1],05h

outer1:

mov rsi,buffer
mov rdi,buffer+2

xor rcx,rcx
mov rcx,05h

inner1:

mov al,byte[rsi]
mov bl,byte[rdi]

cmp al,bl
jb belo
jmp l5

belo:
mov byte[rsi],blS
mov byte[rdi],al

l5:
add rsi,2
add rdi,2


loop inner1
dec byte[count1]
jnz outer1


scall 1,1,msg3,len3


scall 1,qword[fd_in],buffer,qword[datalen]
jmp repeat

exit:
scall 60,0,0,0




	





