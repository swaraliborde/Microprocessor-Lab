%macro scall 4
mov rax,%1
mov rdi,%2
mov rsi,%3
mov rdx,%4
syscall
%endmacro

section .data

msg1:db "Contents of GDTR::",10
len1:equ $-msg1

msg2:db "Contents of IDTR::",10
len2:equ $-msg2

msg3:db "Contents of LDTR::",10
len3:equ $-msg3

msg4:db "Contents of TR::",10
len4:equ $-msg4

msg5:db "Contents of MSW::",10
len5:equ $-msg5

msg6:db "In protected mode.",10
len6:equ $-msg6

msg7:db "In real mode.",10
len7:equ $-msg7

newline:db 10
newlinelen:equ $-newline

section .bss

gdt:	resd 01
	resw 01
idt:	resd 01
	resw 01
ldt:	resd 01
tr:	resw 01	
msw:	resd 01

result resw 1
	
section .text

global _start
_start:

smsw[msw]

mov eax,dword[msw]

bt eax,0
jc l1
scall 1,1,msg7,len7
jmp exit

l1:
scall 1,1,msg6,len6


;CONETNT OF GDTR
scall 1,1,msg1,len1
sgdt[gdt]
mov bx,word[gdt+4]
call htoa
mov bx,word[gdt+2]
call htoa
mov bx,word[gdt]
call htoa
scall 1,1,newline,1

;CONETNT OF IDTR
scall 1,1,msg2,len2
sgdt[gdt]
mov bx,word[idt+4]
call htoa
mov bx,word[idt+2]
call htoa
mov bx,word[idt]
call htoa
scall 1,1,newline,1

;CONTENTS OF LDTR
scall 1,1,msg3,len3
sldt[ldt]
mov bx,word[ldt]
call htoa 
scall 1,1,newline,1

;CONTENTS OF TR
scall 1,1,msg4,len4
str[tr]
mov bx,word[tr]
call htoa 
scall 1,1,newline,1

;CONTENTS OF MSW
scall 1,1,msg5,len5
smsw[msw]
mov bx,word[msw+2]
call htoa
mov bx,word[msw]
call htoa
scall 1,1,newline,1

exit:
mov rax,60
mov rdi,0
syscall

htoa:

mov rdi,result
mov rcx,4

up:
	rol bx,04
	mov al,bl
	and al,0fh
	cmp al,09h
	jbe next
	add al,7h
next:	add al,30h
	mov byte[rdi],al
	inc rdi

	loop up
scall 1,1,result,4
	ret




