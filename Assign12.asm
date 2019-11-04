%macro scall 4
mov rax,%1
mov rdi,%2
mov rsi,%3
mov rdx,%4
syscall
%endmacro

section .data

msg1:db "Mean::",10
len1:equ $-msg1

msg2:db "Variance::",10
len2:equ $-msg2

msg3:db "Standerd Deviation::",10
len3:equ $-msg3

newline db 10

dpoint db "."
dlen:equ $-dpoint

array dd 102.44,106.77,145.98,103.99

arrcnt dw 04

dec :dw 100          

section .bss

mean :resb 10
variance: resb 10
sd: resb 10
count: resb 02
count1:resb 02
count2:resb 02
count3:resb 02
buffer: resb 10
temp:resb 02

section .text
global _start
_start:


;------------MEAN------------;

scall 1,1,msg1,len1
mov rsi,array
mov byte[count],4

finit
fldz
up:

fadd dword[rsi]
add rsi,4
dec byte[count]
jnz up

fidiv word[arrcnt]
fst dword[mean]
call display

;--------variance------------;
scall 1,1,newline,1
scall 1,1,msg2,len2
finit
fldz
mov rsi,array
mov byte[count3],4

up1:
fldz                   ;loads zero to the st0 and makes st0 as top9
fadd dword[rsi]
fsub dword[mean]
fmul st0
fadd st1


add rsi,4
dec byte[count3]
jnz up1


fidiv word[arrcnt]
fst dword[variance]
call display


;----------SD---------------;

scall 1,1,newline,1
scall 1,1,msg3,len3

finit
fldz
fadd dword[variance]

fsqrt 
fst dword[sd]
call display


scall 60,0,0,0

display:

fimul word[dec]
fbstp tword[buffer]
mov byte[count2],9
mov rsi,buffer+9

up5:

push rsi
mov bl,byte[rsi]
call htoa
pop rsi
dec rsi
dec byte[count2]
jnz up5


scall 1,1,dpoint,dlen

mov bl,[buffer+1]
call htoa

ret

htoa:
mov rdi,temp
mov byte[count1],02

up9:

rol bl,4
mov al,bl
and al,0fh
cmp al,9h
jbe continue
add al,7h

continue:
add al,30h
mov byte[rdi],al
inc rdi
dec byte[count1]
jnz up9
scall 1,1,temp,2
ret






