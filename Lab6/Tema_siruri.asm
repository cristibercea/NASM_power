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
        ;Se dau doua siruri de octeti S1 si S2. Sa se construiasca sirul D prin concatenarea elementelor din sirul S1 ;1uate de la stanga spre dreapta si a elementelor din sirul S2 luate de la dreapta spre stanga.
    ;Exemplu:
            ;S1: 1, 2, 3, 4
            ;S2: 5, 6, 7
            ;D: 1, 2, 3, 4, 7, 6, 5
    s1 db 1, 2, 3, 4
    ls1 equ $-s1
    s2 db 5, 6, 7
    ls2 equ $-s2
    rezultat resb 7

; our code starts here
segment code use32 class=code
    start:
        ; ...
        mov ecx, ls1 ;ecx=ls1
        mov edi, 0 ;pregatire parcurgere directa sir s1
        mov esi, 0 ; pregatire parcurgere directa sir rezultat
        
        repeta: ;parcurgerea sirului s1 (st->dr)  
            mov al, [s1+edi] ;al=s1[edi]
            mov [rezultat+esi], al ;rezultat[esi]=al
            add esi, 1
            add edi, 1
        loop repeta
        
        mov ecx, ls2 ;ecx=ls2
        mov edi, ls2-1 ;pregatire parcurgere inversa sir s2
        
        repeta1: ;parcurgerea sirului s2 (dr->st)
            mov al, [s2+edi] ;al=s2[edi]
            mov [rezultat+esi], al ;rezultat[esi]=al
            add esi, 1
            sub edi, 1
        loop repeta1
        
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
