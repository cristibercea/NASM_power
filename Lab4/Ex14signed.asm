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
    a db -7
    b dw 3
    c dd -10
    x dq -5
; our code starts here
;x+(2-a*b)/(a*3)-a+c=-5+(2+21)/-21+7-10=-9
segment code use32 class=code
    start:
        ; ...
        movsx ax, byte[a]
        imul word[b]
        push dx
        push ax
        pop eax
        mov ebx, 2
        sub ebx, eax
        mov al, [a]
        mov cl, 3
        imul cl
        mov cx,ax
        push ebx
        pop ax
        pop dx
        idiv cx     ;ax=(2-a*b)/(a*3)
        cwd
        cdq
        mov ebx, dword[x+0]
        mov ecx, dword[x+4]
        add ebx, eax
        adc ecx, edx  ;x+(2-a*b)/(a*3)
        movsx eax, byte[a]
        cdq
        sub ebx, eax
        sbb ecx, edx  ;x+(2-a*b)/(a*3)-a
        mov eax, [c]
        cdq
        add eax, ebx
        adc ecx, edx
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
