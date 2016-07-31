[ org 0x7c00 ]

KERNEL_OFFSET equ 0x1000

mov bp , 0x9000 

mov sp , bp 

mov bx, MSG_REAL_MODE
call print_string

call load_kernel

call switch_to_pm

jmp $

%include "print_string.asm" 
%include "print_hex.asm" 
%include "disk_load.asm"
%include "switch_to_pm.asm"
%include "gdt.asm"
%include "print_string_pm.asm"


[bits 16]

load_kernel:
	mov bx,MSG_LOAD_KERNEL
	call print_string

	mov bx, KERNEL_OFFSET
	mov dh,3
	call disk_load

	ret


[bits 32]

BEGIN_PM:
mov ebx , MSG_PROT_MODE
call print_string_pm

call KERNEL_OFFSET

jmp $

MSG_PROT_MODE: db " Successfully landed in 32 - bit Protected Mode",0
MSG_REAL_MODE: db "Started in 16_bit_real mode",0
MSG_LOAD_KERNEL: db  "Loading Kernel into memory"

times 510 -( $ - $$ ) db 0
dw 0xaa55

times 256 dw 0xdada
times 256 dw 0xface