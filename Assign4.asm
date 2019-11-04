%macro scall 4
mov rax,%1
mov rdi,%2
mov rsi,%3
mov rdx,%4
syscall
%endmacro

section .data

msg1: db "Enter the Multiplier::",10
len1:equ $-msg1

msg2: db "Enter the Multiplicand::",10
len2:equ $-msg2

msg3:db "Answer using successive addition is::",10
len3:equ $-msg3

msg4:db "Answer using add and shift is::",10
len4:equ $-msg4

menu:db "1.Successive addition",10
	db "2.Add and shift",10
	db "3.Exit",10
menulen:equ $-menu

newline:db 10


section .bss
num1:resb 3
num2:resb 3
result:resb 6
count:resb 2
count1:resb 2
choice resb 02
res:resb 6
hex1:resb 3
hex2:resb 3

section .text
global _start
_start:

scall 1,1,menu,menulen

repeat:
scall 0,1,choice,2

cmp byte[choice],31h
je successive

cmp byte[choice],32h
je addShift

cmp byte[choice],33h
je exit

jmp repeat

successive:

scall 1,1,msg1,len1
scall 0,1,num1,3


scall 1,1,msg2,len2
scall 0,1,num2,3

mov rsi,num1
call atoh
xor rbx,rbx
mov bl,al


mov rsi,num2
call atoh
xor rcx,rcx
mov cl,al
xor ax,ax

up2:
add ax,bx
dec cx
jnz up2

call htoa
scall 1,1,msg3,len3
scall 1,1,result,6
jmp repeat

;------------ADD AND SHIFT-------------;
addShift:

scall 1,1,msg1,len1
scall 0,1,num1,3

scall 1,1,msg2,len2
scall 0,1,num2,3

mov rsi,num1
call atoh
mov byte[hex1],al


mov rsi,num2
call atoh
mov byte[hex2],al

xor rax,rax
xor rcx,rcx
mov rcx,08

mov bl,byte[hex2]
mov dl,byte[hex1]


up3:

SHR bl,1
jnc next3

add ax,dx
next3:
SHL dx,1
loop up3


call htoa

scall 1,1,result,6
scall 1,1,newline,1
jmp repeat

exit:
scall 60,0,0,0


atoh:

	mov byte[count],02
	xor rax,rax
	xor rdx,rdx
	
up:
	rol al,04
	mov dl,byte[rsi]
	cmp dl,39h
	jbe below
	sub dl,07h
	
below:
	sub dl,30h
	add al,dl
	inc rsi
	dec byte[count]
	jnz up
ret


htoa:

mov rdi,result
mov byte[count1],4
xor rbx,rbx
up1:
	rol ax,04
	mov bl,al
	and bl,0fh
	cmp bl,09h
	jbe next1
	add bl,07h
next1:
	add bl,30h
	mov byte[rdi],bl
	inc rdi
	dec byte[count1]
	jnz up1
	ret
		


