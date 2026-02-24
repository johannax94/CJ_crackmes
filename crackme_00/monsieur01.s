; crackme_flag_FIXED.asm - Linux x86_64
section .data
    prompt      db " qui est le meilleur monsieur du monde : ", 10, 0
    good_msg    db "Good Job! Flag: ejJd09nn3nA9kzk2", 10, 0
    bad_msg     db "Mauvais!", 10, 0
    password    db "MonsieurIbucziapbcuazixpbaz", 0

section .bss
    input       resb 32

section .text
    global _start

_start:

    mov rax, 1
    mov rdi, 1
    mov rsi, prompt
    mov rdx, 43
    syscall

    ; Lire input
    mov rax, 0
    mov rdi, 0
    mov rsi, input
    mov rdx, 32
    syscall

    ; ENLEVER le 
    mov rdi, input
    call trim_newline

    
    mov rdi, input
    mov rsi, password
    call my_strcmp

    test rax, rax
    jz .good

.bad:
    mov rax, 1
    mov rdi, 1
    mov rsi, bad_msg
    mov rdx, 15
    syscall
    jmp .exit

.good:
    mov rax, 1
    mov rdi, 1
    mov rsi, good_msg
    mov rdx, 32
    syscall

.exit:
    mov rax, 60
    xor rdi, rdi
    syscall

;
trim_newline:
    mov rcx, -1
.loop:
    inc rcx
    cmp byte [rdi + rcx], 0
    je .done
    cmp byte [rdi + rcx], 10    ; \n
    je .found_nl
    cmp byte [rdi + rcx], 13    ; \r
    je .found_nl
    jmp .loop

.found_nl:
    mov byte [rdi + rcx], 0   
.done:
    ret

my_strcmp:
.loop:
    mov al, [rdi]
    mov bl, [rsi]
    cmp al, bl
    jne .not_equal
    test al, al
    jz .equal
    inc rdi
    inc rsi
    jmp .loop

.not_equal:
    mov rax, 1
    ret

.equal:
    xor rax, rax
    ret
