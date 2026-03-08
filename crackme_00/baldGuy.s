

section .data
    msg_prompt  db "Enter key: ", 0
    msg_good    db "Good Job! Flag: ", 0
    msg_bad     db "Wrong key!", 10, 0
    msg_newline db 10, 0
    key_enc     db 0x12,0x6e,0x19,0x11,0x69,0x08,0x05,0x11,0x69,0x03,0x05,0x68,0x6a,0x68,0x6e,0x7b
    flag_enc    db 0x63,0x68,0x13,0x05,0x69,0x6e,0x09,0x03,0x17,0x6a,0x1e,0x1e,0x69,0x18,0x0f,0x0e

section .bss
    buffer      resb 18     
    key_buf     resb 17    
    flag_buf    resb 17     

section .text
    global _start

_start:
    ; Afficher prompt
    mov rax, 1
    mov rdi, 1
    mov rsi, msg_prompt
    mov rdx, 11
    syscall

    ; Lire input (16 chars + \n)
    mov rax, 0
    mov rdi, 0
    mov rsi, buffer
    mov rdx, 17
    syscall

    ; Strip \n
    mov rcx, rax
    dec rcx
    mov byte [buffer + rcx], 0


    mov rdi, key_enc
    mov rsi, key_buf
    mov rcx, 16
.xor_key:
    mov al, [rdi]
    xor al, 0x5a
    mov [rsi], al
    inc rdi
    inc rsi
    loop .xor_key

    
    mov rdi, key_buf
    mov rsi, buffer
    call memcmp
    test rax, rax
    jz bad_label

good_label:
   
    mov rdi, flag_enc
    mov rsi, flag_buf
    mov rcx, 16
.xor_flag:
    mov al, [rdi]
    xor al, 0x5a
    mov [rsi], al
    inc rdi
    inc rsi
    loop .xor_flag

    mov rax, 1
    mov rdi, 1
    mov rsi, msg_good
    mov rdx, 16
    syscall

    mov rax, 1
    mov rdi, 1
    mov rsi, flag_buf
    mov rdx, 16
    syscall

    mov rax, 1
    mov rdi, 1
    mov rsi, msg_newline
    mov rdx, 1
    syscall

    jmp exit_label

bad_label:
    mov rax, 1
    mov rdi, 1
    mov rsi, msg_bad
    mov rdx, 11
    syscall

exit_label:
    mov rax, 60
    xor rdi, rdi
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