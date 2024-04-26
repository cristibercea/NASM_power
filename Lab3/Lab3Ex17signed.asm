bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit               ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
                          ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions

; our data is declared here (the variables needed by our program)
segment data use32 class=data
    ; ...
    a db -6
    b dw 7
    c dd -2
    d dq 3
    aux dq 0
; our code starts here

;(c+d-a)-(d-c)-b=(-2+3+6)-(3+2)-7=7-5-7=-5

segment code use32 class=code
    start:
        ; ...
        mov eax, [c]
        cdq
        add eax, dword[d+0]
        adc edx, dword[d+4]
        mov ecx,edx
        mov ebx,eax
        movsx eax, byte[a]
        cdq
        sub ebx, eax
        sbb ecx, edx
        mov dword[aux+0], ebx
        mov dword[aux+4], ecx    ;aux=c+d-a
        mov ebx, dword[d+0]
        mov ecx, dword[d+4]
        mov eax, [c]
        cdq
        sub ebx, eax
        sbb ecx, edx             ;d-c
        mov eax, dword[aux+0]
        mov edx, dword[aux+4]
        sub eax, ebx
        sbb edx, ecx             ;(c+d-a)-(d-c)
        mov ebx, eax
        mov ecx, edx
        movsx eax, word[b]
        cdq
        sub ebx, eax
        sbb ecx, edx             ;(c+d-a)-(d-c)-b
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
