section .data
    msg_login    db "Login: ", 0
    msg_pass     db 10, "Password: ", 0
    msg_goodjob  db "Good Job!", 10, 0
    msg_bad      db "Access refused", 10, 0
    flag_enc     db 0x66,0x36,0x58,0x6c,0x6e,0x3b,0x5a,0x41,0x72,0x76,0x3e,0x81,0x58,0x74,0x74,0x5b

section .bss
    buffer       resb 64
    flag_dec     resb 32

section .text
    global _start

_start:
    mov rax, 1
    mov rdi, 1
    mov rsi, msg_login
    mov rdx, 7
    syscall

    mov rax, 0
    mov rdi, 0
    mov rsi, buffer
    mov rdx, 32
    syscall

    call check_login
    test rax, rax
    jz bad_label


    mov rax, 1
    mov rdi, 1
    mov rsi, msg_pass
    mov rdx, 11
    syscall

    mov rax, 0
    mov rdi, 0
    mov rsi, buffer
    mov rdx, 32
    syscall

    call check_pass
    test rax, rax
    jz bad_label


    mov rax, 1
    mov rdi, 1
    mov rsi, msg_goodjob
    mov rdx, 9
    syscall

    
    lea rdi, [flag_dec]
    lea rsi, [flag_enc]
    call decode_flag
    
    mov rax, 1
    mov rdi, 1
    lea rsi, [flag_dec]
    mov rdx, 16
    syscall
    jmp exit_label

bad_label:
    mov rax, 1
    mov rdi, 1
    mov rsi, msg_bad
    mov rdx, 13
    syscall

exit_label:
    mov rax, 60
    xor rdi, rdi
    syscall

check_login:
    mov al, [buffer+0]
    cmp al, 'd'
    jne .fail
    mov al, [buffer+1]
    cmp al, 'a'
    jne .fail
    mov al, [buffer+2]
    cmp al, 'x'
    jne .fail
    mov al, [buffer+3]
    cmp al, 'i'
    mov rax, 1
    ret
.fail:
    xor rax, rax
    ret

check_pass:
    mov al, [buffer+0]
    cmp al, 'o'
    jne .failp
    mov al, [buffer+1]
    cmp al, 'r'
    jne .failp
    mov al, [buffer+2]
    cmp al, 'h'
    jne .failp
    mov al, [buffer+3]
    cmp al, 'q'
    mov rax, 1
    ret
.failp:
    xor rax, rax
    ret

decode_flag:
    xor rcx, rcx
.loop:
    mov al, [rsi + rcx]
    sub al, cl
    mov [rdi + rcx], al
    inc rcx
    cmp rcx, 16
    jb .loop
    mov byte [rdi + rcx], 10
    ret
