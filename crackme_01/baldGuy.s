

section .bss
    input       resb 32

section .text
    global _start

_start:
    lea rdi, [prompt]
    call puts
    lea rdi, [entrez le mdp]
    call puts
    lea rdi, [bbiiKey]
    call gets
    call validate_key


validate_key:
    
    
    mov rax, 0
    mov rdi, 0
    mov rsi, input
    mov rdx, 32
    syscall

    ; ENLEVER le 
    mov rdi, input
    call trim_newline



section .data
    prompt      db "Combien y-a-t-il de chauve en Amerique du Nord", 0
    good_msg    db "Good Job! Flag: YjpLB9nn3nZ9kzk7", 0
    bad_msg     db "Tu deviendra chauve", 0
    password    db "MonsieurIbucziapbcuazixpbaz", 0
    bbiiKey     db "", 0