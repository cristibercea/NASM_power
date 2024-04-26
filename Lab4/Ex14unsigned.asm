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
    a db 2
    b dw 1
    c dd 6
    x dq 10
; our code starts here
;x+(2-a*b)/(a*3)-a+c=10+(2-2)/6-2+6=14
segment code use32 class=code
    start:
        ; ...
        movzx ax, byte[a]
        mul word[b]
        push dx
        push ax
        pop eax
        mov dx,0
        mov ebx, 2
        sub ebx, eax ; 2-a*b=0
        mov eax, 0
        mov al, [a]
        mov dl, 3
        mul dl
        mov cx,ax   ;a*3=6
        mov eax, ebx ;2-a*b=0
        push eax
        pop dx
        pop ax
        div cx
        movzx ecx, ax ;catul lui (2-a*b)/(a*3)=0/6=0
        mov ebx, 0
        mov eax, dword[x+0]
        mov edx, dword[x+4]
        add eax, ecx
        adc edx, ebx ;x+(2-a*b)/(a*3)=10
        movzx ecx, byte[a]
        mov ebx, 0
        sub eax, ecx
        sbb edx, ebx ;x+(2-a*b)/(a*3)-a=8
        mov ecx, [c]
        mov ebx, 0
        add eax, ecx
        adc edx, ebx ;x+(2-a*b)/(a*3)-a+c=14
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
