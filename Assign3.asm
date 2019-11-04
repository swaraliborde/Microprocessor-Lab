%macro scall 4
mov rax,%1
mov rdi,%2
mov rsi,%3
mov rdx,%4
syscall
%endmacro

section .data
menu:db "Enter the choice",10
	db"1.HEX TO BCD",10
	db"2.BCD TO HEX",10
	db"3.Exit",10
menulen:equ $-menu

msg1:db "Enter the hex number::",10
len1:equ $-msg1

msg2:db "Equivalent BCD number is::",10
len2:equ $-msg2

msg3:db "Enter the 5 digit BCD number::",10
len3:equ $-msg3

msg4:db "HEX equivalent is::",10
len4:equ $-msg4

newline db 10

section .bss
choice resb 02
count resb 05
count1 resb 02
count2 resb 02
count3 resb 02
num1:resb 06
num2:resb 06
ans:resb 06
ans1:resb 04


section .text
global _start
_start:

scall 1,1,menu,menulen

repeat:
scall 0,1,choice,02

cmp byte[choice],31h
je HEXTOBCD

cmp byte[choice],32h
je BCDTOHEX

cmp byte[choice],33h
jmp exit

jmp repeat


HEXTOBCD:

scall 1,1,msg1,len1
scall 0,1,num1,06

mov rsi,num1
call atoh

mov rbx,10


up1:
xor rdx,rdx
div rbx               ;divisor in rbx
push rdx
inc byte[count]
cmp ax,00
jne up1

scall 1,1,msg2,len2
print:

pop rdx
mov byte[ans],dl
add byte[ans],30h
scall 1,1,ans,06
dec byte[count]
jnz print

scall 1,1,newline,1
jmp repeat

BCDTOHEX:
scall 1,1,msg3,len3
scall 0,1,num2,6
scall 1,1,newline,1

mov rsi,num2
mov rbx,10
mov rax,00
mov byte[count2],5

up9:
xor rdx,rdx
mul rbx
mov dl,byte[rsi]
sub dl,30h
add rax,rdx
inc rsi
dec byte[count2]
jnz up9

mov rbx,rax
call htoa
scall 1,1,msg4,len4
scall 1,1,ans1,4



exit:
scall 60,0,0,0

htoa:
mov rdi,ans1
mov byte[count3],4


up3:

rol bx,04
mov cl,bl
and cl,0fh
cmp cl,9h
jbe next3
add cl,7h

next3:
add cl,30h
mov byte[rdi],cl
inc rdi
dec byte[count3]
jnz up3
ret

atoh:

mov byte[count1],04
xor rax,rax
xor rdx,rdx

up:

rol ax,04
mov dl,byte[rsi]
cmp dl,39h
jbe next
sub dl,7h
next:
sub dl,30h
add ax,dx
inc rsi
dec byte[count1]
jnz up

ret




