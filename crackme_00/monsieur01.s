
section .data
    msg_prompt  db "Enter key: ", 0
    msg_good    db "Good Job !", 10, 0
    msg_bad     db "Bad Password!", 10, 0
    msg_newline db 10, 0
    secret_key  db 0x6b,0x68,0x69,0x6e,0x6f,0x6c,0x6d,0x62,0x63,0x12,0x1b,0x19,0x11,0x12,0x1b,0x19

section .bss
    buffer      resb 18
    flag_buf    resb 17

section .text
    global _start

_start:
    mov rax, 1
    mov rdi, 1
    mov rsi, msg_prompt
    mov rdx, 11
    syscall

    mov rax, 0
    mov rdi, 0
    mov rsi, buffer
    mov rdx, 17
    syscall

    mov rcx, rax
    dec rcx
    mov byte [buffer + rcx], 0


    mov rdi, buffer
    mov rsi, flag_buf
    mov rcx, 16
.xor_loop:
    mov al, [rdi]
    xor al, 0x5a
    mov [rsi], al
    inc rdi
    inc rsi
    loop .xor_loop

    mov rdi, flag_buf
    mov rsi, secret_key
    call memcmp
    test rax, rax
    jz bad_label

good_label:
    mov rax, 1
    mov rdi, 1
    mov rsi, msg_good
    mov rdx, 11
    syscall

    mov rax, 60
    xor rdi, rdi
    syscall

bad_label:
    mov rax, 1
    mov rdi, 1
    mov rsi, msg_bad
    mov rdx, 13
    syscall

    mov rax, 60
    mov rdi, 1
    syscall

memcmp:
    mov rcx, 16
.loop:
    mov al, [rdi]
    cmp al, [rsi]
    jne .fail
    inc rdi
    inc rsi
    loop .loop
    mov rax, 1
    ret
.fail:
    xor rax, rax
    ret