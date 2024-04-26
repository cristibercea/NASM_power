bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit
extern printf
extern scanf
extern calculeaza               ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll
import printf msvcrt.dll
import scanf msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
import calculeaza calculeaza.asm                          ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions

; our data is declared here (the variables needed by our program)
segment data use32 class=data
    a dd 0
    b dd 0
    c dd 0
    mesaj db "Introduceti a, b, c", 0
    format db "%d %d %d", 0
    format_afisare db "a + b - c = %d", 0
    
; our code starts here
segment code use32 class=code
    start:
        ;Se cere se se citeasca numerele a, b si c ; sa se calculeze si sa se afiseze a+b-c.
        ; citire a, b, c
        push dword mesaj
        call [printf]
        add esp, 4
        
        push dword c
        push dword b
        push dword a
        push dword format
        call [scanf]
        add esp, 4*4
        
        ;calculeaza a + b - c
        push dword [c]
        push dword [b]
        push dword [a]
        call calculeaza
        
        
        push eax
        push format_afisare
        call [printf]
        add esp, 4*2
    
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
