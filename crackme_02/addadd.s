; crackme_shift.asm
; Transformation : key_enc[i] = (input[i] + i*3) % 256
; Pour obtenir le flag : flag[i] = (flag_enc[i] - i*3) % 256
; Clé  : N3VER_GR4D_1S_NN
; Flag : S4CA3R_K5Y_2026!

section .data
    msg_prompt   db "Enter key: ", 0
    msg_good     db "Good Job!", 10, 0
    msg_flag     db "Flag: ", 0
    msg_bad      db "Bad Password!", 10, 0
    msg_newline  db 10, 0
    ; key_enc[i]  = (key[i]  + i*3) % 256
    key_enc      db 0x4e,0x36,0x5c,0x4e,0x5e,0x6e,0x59,0x67,0x4c,0x5f,0x7d,0x52,0x77,0x86,0x78,0x7b
    ; flag_enc[i] = (flag[i] + i*3) % 256
    flag_enc     db 0x53,0x37,0x49,0x4a,0x3f,0x61,0x71,0x60,0x4d,0x74,0x7d,0x53,0x54,0x59,0x60,0x4e

section .bss
    buffer       resb 18
    trans_buf    resb 17
    flag_buf     resb 17

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

    ; Transformer input : trans_buf[i] = (input[i] + i*3) % 256
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
    ; Comparer trans_buf avec key_enc
    mov rdi, trans_buf
    mov rsi, key_enc
    call memcmp
    test rax, rax
    jz bad_label

good_label:
    ; Afficher "Good Job!" + return 0
    mov rax, 1
    mov rdi, 1
    mov rsi, msg_good
    mov rdx, 10
    syscall

    ; Déchiffrer flag : flag_buf[i] = (flag_enc[i] - i*3) % 256
    xor rcx, rcx
.flag_loop:
    cmp rcx, 16
    jge .show_flag
    mov al, [flag_enc + rcx]
    mov bl, cl
    add bl, cl
    add bl, cl
    sub al, bl
    mov [flag_buf + rcx], al
    inc rcx
    jmp .flag_loop

.show_flag:
    ; Afficher "Flag: "
    mov rax, 1
    mov rdi, 1
    mov rsi, msg_flag
    mov rdx, 6
    syscall

    ; Afficher le flag déchiffré
    mov rax, 1
    mov rdi, 1
    mov rsi, flag_buf
    mov rdx, 16
    syscall

    ; Newline
    mov rax, 1
    mov rdi, 1
    mov rsi, msg_newline
    mov rdx, 1
    syscall

    ; exit(0)
    mov rax, 60
    xor rdi, rdi
    syscall

bad_label:
    ; Afficher "Bad Password!"
    mov rax, 1
    mov rdi, 1
    mov rsi, msg_bad
    mov rdx, 14
    syscall

    ; exit(1)
    mov rax, 60
    mov rdi, 1
    syscall

; memcmp(rdi, rsi, 16) → rax=1 si égal, 0 sinon
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