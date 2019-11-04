section .data
msg1: db "error in opening file 1",10
len1: equ $-msg1
msg2: db "error in opening file 2",10
len2: equ $-msg2

msg3: db "copied sucessfully",10
len3: equ $-msg3

section .bss

filename1: resb 20
filename2: resb 20
fdout: resq 01
fdin: resq 01

buffer: resb 1000
count: resq 01

%macro scall 4
mov rax,%1
mov rdi,%2
mov rsi,%3
mov rdx,%4
syscall
%endmacro

section .text
global _start
_start:

pop rdi
pop rdi
pop rdi

cmp byte[rdi],'C'
je copy

cmp byte[rdi],'T'
je type

cmp byte[rdi],'D'
je delete

copy:
pop rdi
mov rsi,filename1
call getARGUMENTS

;opening of first file
scall 2,filename1,2,0777

bt rax,63
jnc l1
scall 1,1,msg1,len1
jmp exit

l1:
mov qword[fdin],rax

scall 0,qword[fdin],buffer,1000

mov qword[count],rax

;open second file*********************************************************************

pop rdi
mov rsi,filename2
call getARGUMENTS

;opening of first file
scall 2,filename2,2,0777

bt rax,63
jnc l2
scall 1,1,msg2,len2
jmp exit

l2:
mov qword[fdout],rax

scall 1,qword[fdout],buffer,qword[count]


scall 1,1,msg3,len3



jmp exit

;*************************************************************************************************************************

type:
pop rdi
mov rsi,filename1
call getARGUMENTS

;opening of first file
scall 2,filename1,2,0777

bt rax,63
jnc l3
scall 1,1,msg1,len1
jmp exit

l3:
mov qword[fdin],rax

scall 0,qword[fdin],buffer,1000

mov qword[count],rax

scall 1,1,buffer,qword[count]

jmp exit

;*************************************************************************************************

delete:

pop rdi
mov rsi,filename1
call getARGUMENTS

scall 87,filename1,0,0



exit:
scall 60,0,0,0


getARGUMENTS:

up1:
cmp byte[rdi],00h
je done
mov cl,byte[rdi]
mov byte[rsi],cl
inc rsi
inc rdi
loop up1
done:
ret
