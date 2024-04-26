bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit,printf,scanf
import printf msvcrt.dll
import scanf msvcrt.dll
import exit msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
                          ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions

; our data is declared here (the variables needed by our program)
segment data use32 class=data
    ; ...
    a dd 536                ;variabila a, definita in segmentul de date
    b dw 0                  ;variabila b, citita de la tastatura
    result dd 0             ;variabila care va contine rezultatul final
    
    mesajcitire db 'Se da numarul a=%d. Introduceti numarul: b=',0        ;declararea unui mesaj pentru citire
    format db '%d',0                                                      ;declararea formatului de citire
    afisare db 'Pentru relatia a + a/b, avem: %d + %d/%d = %d',0          ;declararea mesajului+formatului pentru afisare
    eroare db 'Numarul b trebuie sa fie un numar natural diferit de 0!',0 ;declararea mesajului de eroare (b==0)
    
;Se da un numar natural a (a: dword, definit in segmentul de date). Sa se citeasca un numar natural b si sa se ;calculeze: a + a/b. Sa se afiseze rezultatul operatiei. Valorile vor fi afisate in format decimal (baza 10) cu semn.
; our code starts here
segment code use32 class=code
    start:
        ; ...
        ;printarea numarului a, definit in program si a unui mesaj de citire
        push dword [a]
        push dword mesajcitire
        call [printf]
        add esp, 4*2
        
        ;citirea numarului b din consola
        push dword b
        push dword format
        call [scanf]
        add esp, 4*2
        
        ;prelucrarea numerelor pentru a ajunge la rezultatul relatiei a+a/b
        mov dx, word [a+2]   ;pregatirea deimpartitului impartirii a/b
        mov ax, word [a]     ;-||-
        mov cx, [b]          ;cx = [b]
        movsx ecx, cx        ;ecx = cx
        jecxz impartire_la_0 
        idiv cx              ;ax=(ax:dx)/cx=a/b,  dx=(ax:dx)%cx=a%b
        cwde                 ;ax->eax
        add eax, [a]         ;eax=a/b+a
        
        ;pregatiri pentru afisare
        mov [result], eax    ;rezultatul final e trecut in variabila result
        movsx eax, cx        ;in eax se pune cx, adica valoarea lui b
        
        ;printarea rezultatului
        push dword [result]
        push dword eax
        push dword [a]
        push dword [a]
        push dword afisare
        call [printf]
        add esp, 4*5
        jmp final
        
        impartire_la_0:
        ;daca numarul b (citit de la tastatura) este 0 atunci de printeaza mesaj de eroare
        push eroare
        call [printf]
        add esp, 4*1
        
        final:
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
