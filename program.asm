section .data
    msg_fib db 'Fibonacci numbers: ', 0
    msg_fib_len equ $ - msg_fib
    msg_fact db 0xd, 0xa, 'Factorials: ', 0
    msg_fact_len equ $ - msg_fact
    hex_chars db '0123456789ABCDEF'
    newline db 0xd, 0xa
    space db ' '

section .bss
    written resq 1
    number_buffer resb 32
    fib_results resq 10
    fact_results resq 10

section .text
    global main
    extern ExitProcess
    extern GetStdHandle
    extern WriteConsoleA

default rel   ; 추가된 라인 - 상대 주소 지정 사용

main:
    ; 스택을 16바이트로 정렬
    push rbp
    mov rbp, rsp
    sub rsp, 48  ; 40 -> 48로 변경하여 16바이트 정렬 보장

    ; 피보나치 수열 계산
    mov rdi, fib_results    ; 결과를 저장할 배열
    mov rcx, 10             ; 계산할 숫자 개수
    xor rax, rax            ; 첫 번째 숫자 (0)
    mov rbx, 1              ; 두 번째 숫자 (1)

calc_fib:
    mov [rdi], rax          ; 현재 숫자 저장
    mov rdx, rax            ; 임시 저장
    mov rax, rbx            ; 다음 숫자 준비
    add rbx, rdx            ; 새로운 피보나치 숫자 계산
    add rdi, 8              ; 다음 저장 위치로
    loop calc_fib

    ; 팩토리얼 계산
    mov rdi, fact_results   ; 결과를 저장할 배열
    mov rcx, 10             ; 1부터 10까지

calc_fact:
    push rcx                ; 현재 숫자 저장
    mov rax, 1              ; 결과 초기화
    mov rbx, rcx            ; 카운터

fact_loop:
    mul rbx                 ; rax *= rbx
    dec rbx
    jnz fact_loop
    
    mov [rdi], rax          ; 결과 저장
    add rdi, 8              ; 다음 저장 위치로
    pop rcx
    loop calc_fact

    ; 출력 준비
    mov rcx, -11
    call GetStdHandle
    mov rbx, rax            ; 핸들 저장

    ; "Fibonacci numbers:" 출력
    mov rcx, rbx
    mov rdx, msg_fib
    mov r8, msg_fib_len
    mov r9, written
    sub rsp, 32         ; 섀도우 스페이스 확보
    push qword 0        ; 5번째 매개변수
    sub rsp, 8          ; 스택 16바이트 정렬
    call WriteConsoleA
    add rsp, 48         ; 스택 복구

    ; 피보나치 수열 출력
    mov rsi, fib_results
    mov rcx, 10
print_fib:
    push rcx
    mov rax, [rsi]
    call print_hex
    add rsi, 8
    pop rcx
    loop print_fib

    ; "Factorials:" 출력
    mov rcx, rbx
    mov rdx, msg_fact
    mov r8, msg_fact_len
    mov r9, written
    sub rsp, 32         ; 섀도우 스페이스 확보
    push qword 0        ; 5번째 매개변수
    sub rsp, 8          ; 스택 16바이트 정렬
    call WriteConsoleA
    add rsp, 48         ; 스택 복구

    ; 팩토리얼 결과 출력
    mov rsi, fact_results
    mov rcx, 10
print_fact:
    push rcx
    mov rax, [rsi]
    call print_hex
    add rsi, 8
    pop rcx
    loop print_fact

    ; 종료
    xor rcx, rcx
    call ExitProcess

    add rsp, 48
    leave              ; 스택 프레임 정리
    ret

; 16진수 출력 함수
print_hex:
    push rbp
    mov rbp, rsp
    push rbx
    push rdi
    mov rdi, number_buffer
    mov rcx, 16             ; 16자리 16진수
convert_hex:
    mov rdx, rax
    and rdx, 0Fh           ; 마지막 4비트
    lea r10, [rel hex_chars]
    mov bl, [r10 + rdx]
    mov [rdi + rcx - 1], bl
    shr rax, 4
    dec rcx
    jnz convert_hex

    ; 숫자 출력
    mov rcx, rbx            ; console handle
    mov rdx, number_buffer  ; buffer
    mov r8, 16             ; length (16진수 길이)
    mov r9, written        ; written
    sub rsp, 32            ; 섀도우 스페이스 확보
    push qword 0           ; 5번째 매개변수
    sub rsp, 8             ; 스택 16바이트 정렬
    call WriteConsoleA
    add rsp, 48            ; 스택 복구

    ; 공백 출력
    mov rcx, rbx           ; console handle
    mov rdx, space         ; space character
    mov r8, 1              ; length (1 character)
    mov r9, written        ; written
    sub rsp, 32            ; 섀도우 스페이스 확보
    push qword 0           ; 5번째 매개변수
    sub rsp, 8             ; 스택 16바이트 정렬
    call WriteConsoleA
    add rsp, 48            ; 스택 복구

    pop rdi
    pop rbx
    leave
    ret