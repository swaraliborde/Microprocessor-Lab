global buffer,datalen

%macro scall 4
mov rax,%1
mov rdi,%2
mov rsi,%3
mov rdx,%4
syscall
%endmacro
section .data

menu:db "Enter the choice",10
	db "1.No.of spaces",10
	db "2.No. of lines",10
	db "3.No of occurance of a particular character",10
	db "4.Exit.",10

menulen equ $-menu

msg1:db "No. of spaces are::",10
len1 equ $-msg1

msg2:db "No. of lines are::",10
len2 equ $-msg2

msg3:db "No. of occurance of particular are::",10
len3 equ $-msg3

msg4:db "File opened successfully",10
len4 equ $-msg4

msg5:db "Error in opening file",10
len5 equ $-msg5

lastmsg:db "Continue(YES/NO)",10
	db "1.YES",10
	db "2.NO",10
	db "Choice",10
lastlen equ $-lastmsg

fname:db 'abc.txt',0

section .bss
choice:resb 02
choice1:resb 02
buffer:resb 1000
fd_in:resq 01
datalen:resq 01
ans resb 02

section .text
extern li,freq,answer,spa
global _start
_start:


;open the file

scall 2,fname,2,0777

bt rax,63

jnc l1

scall 1,1,msg5,len5
jmp exit

l1:


mov qword[fd_in],rax

;Read the file

scall 0,qword[fd_in],buffer,1000
mov qword[datalen],rax


scall 1,1,menu,menulen
scall 0,1,choice,02

cmp byte[choice],31h
je spaces

cmp byte[choice],32h
je lines

cmp byte[choice],33h
je frequency

cmp byte[choice],34h
jmp exit



spaces:
	call spa
	xor rbx,rbx
	mov bx,[answer]
	call htoa
	;scall 1,1,msg1,len1
	jmp exit

lines:
	call li
	xor rbx,rbx
	mov bx,[answer]
	call htoa
	;scall 1,1,msg2,len2
	jmp exit

frequency:
	call freq
	xor rbx,rbx
	mov bx,[answer]
	call htoa
	;scall 1,1,msg3,len3
	


exit:
scall 1,1,lastmsg,lastlen
scall 0,1,choice1,02

cmp byte[choice1],31h
je _start


scall 60,0,0,0

htoa:
mov rdi,ans
mov rcx,02

up4:

	rol bl,04
	mov al,bl
	and al,0fh
	cmp al,9h
	jbe next4
	add al,7h
next4:
	add al,30h
	mov byte[rdi],al
	inc rdi
	loop up4
scall 1,1,ans,02
ret


