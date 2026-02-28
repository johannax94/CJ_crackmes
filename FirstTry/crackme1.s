section .data
    prompt      db "Entrez le flag : ", 0
    prompt_len  equ $ - prompt
    kat         db "Z7k!pQ9mR2sT5vW8xY1aB4cE6gH0jL3n"
    tak         db 0x72, 0x07, 0x28, 0x07, 0x3c, 0x66, 0x20, 0x74, 0x06, 0x39, 0x77, 0x0d, 0x3e, 0x7d, 0x63, 0x67
    test1       db "Flag correct !", 10
    test1_len   equ $ - test1
    error1      db "Flag incorrect !", 10
    error1_len  equ $ - error1

section .bss
    input      resb 32
    input1     resq 1

section .text
    global _start

_start:

    rdtsc
    shl rdx, 32
    or rax, rdx
    mov [input1], rax

    mov rax, 1
    mov rdi, 1
    mov rsi, prompt
    mov rdx, prompt_len
    syscall

    mov rax, 0
    mov rdi, 0
    mov rsi, input
    mov rdx, 18
    syscall

    test rax, rax
    js .tuk         

    cmp rax, 17
    jne .tuk

    xor rcx, rcx
.funk:
    cmp rcx, 16
    je .kot

    mov r9, rcx
    add r9, [input1]
    and r9, 0xFF
    push rcx
    
    mov rax, rcx
    mov rbx, 7
    mul rbx
    add rax, 3
    and rax, 31
    
    pop rsi 
    movzx rdx, byte [kat + rax]
    movzx rbx, byte [input + rsi]
    xor rbx, rdx

    lea r10, [rbx + 42]
    sub r10, 42
    
    cmp bl, [tak + rsi]
    jne .tuk

    inc rcx
    mov rax, [input1]
    rol rax, 1
    mov [input1], rax
    
    jmp .funk

.kot:
    mov rax, 1
    mov rdi, 1
    mov rsi, test1
    mov rdx, 14
    syscall
    jmp .tok

.exit:
    mov rdi, 0
    jmp .tok

.tuk:
    mov rax, 1
    mov rdi, 1
    mov rsi, error1
    mov rdx, error1_len
    syscall
    mov rdi, 1
    jmp .tok

.tok:
    mov rax, 60
    syscall