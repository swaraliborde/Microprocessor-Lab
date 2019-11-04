%macro print 2
	mov rax,1
	mov rdi,1
	mov rsi,%1
	mov rdx,%2
	syscall
%endmacro

%macro read 2
	mov rax,0
	mov rdi,1
	mov rsi,%1
	mov rdx,%2
	syscall
%endmacro

%macro myprintf 1
	mov rdi,formatpf
	sub rsp,8
	movsd xmm0,[%1]
	mov rax,1
	call printf	
	add rsp,8
%endmacro

%macro myscanf 1
	mov rdi,formatsf
	mov rax,0
	sub rsp,8
	mov rsi,rsp
	call scanf
	mov r8,qword[rsp]
	mov qword[%1],r8
	add rsp,8
%endmacro

section .data

msg1 db "Enter the value of a :",10
len1 equ $- msg1

msg2 db "Enter the value of b :",10
len2 equ $- msg2

msg3 db "Enter the value of c :",10
len3 equ $- msg3

ff1 : db "%lf +i %lf",10,0        ;Imaginary
ff2 : db "%lf -i %lf",10,0

formatpf : db "%lf",10,0

formatsf : db "%lf",0

four : dq 4
two : dq 2

section .bss

a resq 1
b resq 1
c resq 1
b2 resq 1
fac resq 1
delta resq 1
rdelta resq 1
r1 resq 1
r2 resq 1
ta resq 1
realn resq 1
img1 resq 1
img2 resq 1

section .text

extern printf
extern scanf

global main

main:

;------------------------ACCEPT A B C-------------------------------

print msg1,len1
myscanf a

print msg2,len2
myscanf b

print msg3,len3
myscanf c

;------------------------CALCULATE B-SQUARE------------------------

fld qword[b]
fmul qword[b]           ;fmul st0
fstp qword[b2]
	
;-----------------------CALCULATE 4AC------------------------------

fild qword[four]
fmul qword[a]
fmul qword[c]
fstp qword[fac]

;-----------------------CALCULATE DELTA----------------------------
	
fld qword[b2]
fsub qword[fac]
fstp qword[delta]	

;----------------------CALCULATE 2A-------------------------------

fild qword[two]
fmul qword[a]
fstp qword[ta]

;-------------------CHECK DELTA +VE OR -VE------------------------

btr qword[delta],63
jc imaginary_roots

;-------------------REAL ROOTS------------------------------------

fld qword[delta]
fsqrt
fstp qword[rdelta]

fldz

fsub qword[b]
fadd qword[rdelta]
fdiv qword[ta]

fstp qword[r1]

myprintf r1

fldz

fsub qword[b]
fsub qword[rdelta]
fdiv qword[ta]
fstp qword[r2]

myprintf r2

jmp exit

;-------------------IMAGINARY ROOTS-------------------------------

imaginary_roots:

fld qword[delta]
fsqrt
fstp qword[rdelta]

fldz

fsub qword[b]
fdiv qword[ta]
fstp qword[realn]

fldz

fld qword[rdelta]
fdiv qword[ta]
fstp qword[img1]	

;-------------------PRINT IMAGINARY ROOTS-------------------------

mov rdi,ff1
sub rsp,8
movsd xmm0,[realn]
movsd xmm1,[img1]
mov rax,2
call printf
add rsp,8

mov rdi,ff2
sub rsp,8
movsd xmm0,[realn]
movsd xmm1,[img1]
mov rax,2
call printf
add rsp,8

;-------------------EXIT------------------------------------------

exit:
	mov rax,60
	mov rdi,0
	syscall
	
