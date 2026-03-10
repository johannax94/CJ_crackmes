
section .data
    msg_prompt  db "Enter key: ", 0
    msg_good    db "Good Job!", 10, 0
    msg_bad     db "Bad Password!", 10, 0
    key_enc     db 0x53,0x37,0x49,0x4a,0x3f,0x61,0x71,0x60,0x4d,0x74,0x7d,0x53,0x54,0x59,0x60,0x4e

section .bss
    buffer      resb 18
    trans_buf   resb 17

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
    mov al, [buffer + rcx]
    cmp al, 10
    jne .no_strip
    mov byte [buffer + rcx], 0
.no_strip:
    xor rcx, rcx
.transform_loop:
    cmp rcx, 16
    jge .compare
    mov al, [buffer + rcx]
    mov bl, cl
    add bl, cl
    add bl, cl
    add al, bl
    mov [trans_buf + rcx], al
    inc rcx
    jmp .transform_loop

.compare:
    mov rdi, trans_buf
    mov rsi, key_enc
    call memcmp
    test rax, rax
    jz bad_label

good_label:
    mov rax, 1
    mov rdi, 1
    mov rsi, msg_good
    mov rdx, 10
    syscall
    mov rax, 60
    xor rdi, rdi
    syscall

bad_label:
    mov rax, 1
    mov rdi, 1
    mov rsi, msg_bad
    mov rdx, 14
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