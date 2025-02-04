# 어셈블리 언어 가이드

## 목차
1. [기본 구조](#1-기본-구조)
2. [주요 섹션](#2-주요-섹션)
3. [데이터 선언](#3-데이터-선언)
4. [레지스터](#4-레지스터)
5. [기본 명령어](#5-기본-명령어)
6. [제어 흐름](#6-제어-흐름)
7. [함수 처리](#7-함수-처리)
8. [시스템 호출](#8-시스템-호출)
9. [메모리 주소 지정](#9-메모리-주소-지정)
10. [비트 연산](#10-비트-연산)

## 1. 기본 구조

어셈블리 프로그램은 다음과 같은 기본 구조를 가집니다:

```assembly
section .data    ; 초기화된 데이터 섹션
section .bss     ; 초기화되지 않은 데이터 섹션
section .text    ; 코드 섹션
    global main  ; 프로그램 시작점
```

## 2. 주요 섹션

### .data 섹션
- 초기값이 있는 변수들을 저장
- 프로그램 실행 중 변경 가능
- 컴파일 시점에 메모리 할당

### .bss 섹션
- 초기값이 없는 변수들을 저장
- 프로그램 시작 시 0으로 초기화
- 메모리 효율적 사용

### .text 섹션
- 실제 프로그램 코드 포함
- 읽기 전용 영역
- CPU가 실행할 명령어들이 위치

## 3. 데이터 선언

### .data 섹션 선언
```assembly
; 초기화된 데이터
message db 'Hello', 0    ; 문자열 (null 종료)
number  dw 12345        ; 2바이트 정수
array   dd 100, 200, 300 ; 4바이트 배열
qword   dq 123456789    ; 8바이트 정수
```

### .bss 섹션 선언
```assembly
; 초기화되지 않은 데이터
buffer    resb 64    ; 64바이트 버퍼
array     resw 100   ; 100개의 워드(2바이트)
integers  resd 50    ; 50개의 더블워드(4바이트)
large     resq 10    ; 10개의 쿼드워드(8바이트)
```

## 4. 레지스터

### 범용 레지스터
```assembly
rax - 누산기 (연산 결과 저장)
rbx - 베이스 레지스터 (메모리 주소)
rcx - 카운터 (반복문)
rdx - 데이터 (I/O 작업)
rsi - 소스 인덱스 (문자열 작업)
rdi - 목적지 인덱스 (문자열 작업)
```

### 특수 레지스터
```assembly
rsp - 스택 포인터 (스택 최상단)
rbp - 베이스 포인터 (스택 프레임)
rip - 명령어 포인터 (다음 실행 명령어)
```

## 5. 기본 명령어

### 데이터 이동
```assembly
mov dest, src    ; 데이터 복사
xchg a, b       ; 데이터 교환
push value      ; 스택에 저장
pop dest        ; 스택에서 로드
```

### 산술 연산
```assembly
add dest, src   ; 덧셈
sub dest, src   ; 뺄셈
mul src         ; 곱셈 (rax와 곱함)
div src         ; 나눗셈 (rax를 나눔)
inc dest        ; 증가
dec dest        ; 감소
```

## 6. 제어 흐름

### 비교와 점프
```assembly
cmp a, b        ; 값 비교
je  label       ; 같으면 점프
jne label       ; 다르면 점프
jg  label       ; 크면 점프
jl  label       ; 작으면 점프
jge label       ; 크거나 같으면
jle label       ; 작거나 같으면
```

### 반복문
```assembly
loop label      ; rcx 감소, 0이 아니면 반복
loopz label     ; ZF=1이고 rcx≠0이면 반복
loopnz label    ; ZF=0이고 rcx≠0이면 반복
```

## 7. 함수 처리

### 함수 정의와 호출
```assembly
; 함수 정의
function_name:
    push rbp           ; 스택 프레임 설정
    mov rbp, rsp
    ; 함수 코드
    leave             ; 스택 프레임 복원
    ret

; 함수 호출
call function_name    ; 함수 호출
```

### 매개변수 전달
- Windows: rcx, rdx, r8, r9
- Linux: rdi, rsi, rdx, rcx, r8, r9

## 8. 시스템 호출

### Linux 시스템 호출
```assembly
mov rax, syscall_number  ; 시스템 콜 번호
mov rdi, arg1           ; 첫 번째 인자
mov rsi, arg2           ; 두 번째 인자
mov rdx, arg3           ; 세 번째 인자
syscall                 ; 시스템 콜 실행
```

### Windows 시스템 호출
```assembly
extern ExitProcess      ; 외부 함수 선언
call ExitProcess       ; Windows API 호출
```

## 9. 메모리 주소 지정

### 주소 지정 방식
```assembly
mov rax, [var]        ; 직접 주소
mov rax, [rbx]        ; 간접 주소
mov rax, [rbx + 8]    ; 변위 주소
mov rax, [rbx + 4*rcx] ; 인덱스 주소
```

## 10. 비트 연산

### 논리 연산
```assembly
and dest, src    ; 비트 AND
or  dest, src    ; 비트 OR
xor dest, src    ; 비트 XOR
not dest         ; 비트 NOT
```

### 시프트 연산
```assembly
shl dest, count  ; 왼쪽 시프트
shr dest, count  ; 오른쪽 시프트
rol dest, count  ; 왼쪽 회전
ror dest, count  ; 오른쪽 회전
```

## 프로그래밍 팁

1. 코드 구조화
   - 함수 단위로 코드 분리
   - 주석 적극 활용
   - 의미 있는 레이블 사용

2. 레지스터 관리
   - 용도에 맞는 레지스터 사용
   - 중요 값은 스택에 백업
   - 함수 호출 규약 준수

3. 최적화 고려
   - 불필요한 메모리 접근 최소화
   - 효율적인 명령어 선택
   - 분기 예측 고려

4. 디버깅
   - 단계별 실행 활용
   - 레지스터 값 모니터링
   - 메모리 덤프 확인

## 결론

어셈블리 언어는 하드웨어를 직접 제어할 수 있는 강력한 도구입니다. 이 가이드를 통해 기본적인 어셈블리 프로그래밍을 시작할 수 있습니다. 실제 프로그래밍에서는 많은 연습과 경험이 필요하며, 시스템의 동작 원리를 이해하는 것이 중요합니다.# nasm-tutorial
