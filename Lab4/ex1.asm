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
    b db 12
    c dd 7
    d dw 9
    e db 5
    f dq 41
; our code starts here
;unsigned
;(21-b)/(c+3)+d*e-f= 9/10+45-41=0+4=4
segment code use32 class=code
    start:
        ; ...
        ;(21-b)
        mov cl, 21
        sub cl, [b]
        
        ;(c+3)
        mov ebx, [c]
        add ebx, 3
        
        ;(21-b)/(c+3)
        movzx eax, cl
        mov edx, 0
        div ebx
        mov ecx, eax
        
        ;d*e
        mov ax, [d]
        movzx bx, byte[e]
        mul bx
        push dx
        push ax
        pop ebx
        
        ;(21-b)/(c+3)+d*e
        add ecx, ebx
        
        ;(21-b)/(c+3)+d*e-f
        mov eax, ecx
        cdq
        mov ecx, dword[f+0] 
        mov ebx, dword[f+4]
        sub eax, ecx
        sbb edx, ebx
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
