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
    a dw 1001010111001011b ;a=a(15)a(12)a(13)...a(1)a(0) (cifre binare)
    b dw 1010010010000110b ;b=b(15)b(12)b(13)...b(1)b(0) (cifre binare)
    c dd 0 ;c=c(31)c(30)c(29)...c(1)c(0) (cifre binare)
    ;c(16->31)==a
    ;c(9->15)==a(3->9)
    ;c(3->8)==b(0->5)
    ;c(0->2)==a(12->14)
; our code starts here
segment code use32 class=code
    start:
        ; ...
        mov ax, [a]
        movzx eax, ax
        or dword[c], eax  ;c(31->16)==ab
        
        shl dword[c], 7 ;c(31->9)==a0000000b
        
        mov ax, [a]
        shl ax, 6   ;ax=0111001011000000b
        shr ax, 9   ;ax=0000000000111001b
        movzx eax, ax
        or dword[c], eax ;c(31->9)==a0111001b
        
        shl dword[c], 6 ;c(31->3)==a0111001000000b
        
        mov ax, [b]
        shl ax, 10 ;ax=0001100000000000b
        shr ax, 10 ;ax=0000000000000110b
        movzx eax, ax
        or dword[c], eax ;c(31->3)==a0111001000110b
        
        shl dword[c], 3 ;c(31->0)==a0111001000110000b
        
        mov ax, [a]
        shl ax, 1    ;ax=0010101110010110b
        shr ax, 13   ;ax=0000000000000001b
        movzx eax, ax
        or dword[c], eax ;c==10010101 11001011 01110010 00110001b
        
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
