bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

;Se citeste de la tastatura un sir de numere in baza 10, cu semn. 
;Sa se determine valoarea minima din sir si sa se afiseze in fisierul min.txt
;(fisierul va fi creat) valoarea minima, in baza 16.



; declare external functions needed by our program
extern exit, fopen, fscanf, fprintf, scanf, printf, fclose 
extern determinare_minim
            ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll
import fopen msvcrt.dll
import fscanf msvcrt.dll
import fprintf msvcrt.dll
import fclose msvcrt.dll
import scanf msvcrt.dll
import printf msvcrt.dll
    
    
    
    
    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
                          ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions

; our data is declared here (the variables needed by our program)
segment data use32 class=data
    ; ...
    n resd 1
    sir resd 100
    val resd 1
    aux dd 0
    minim resd 1
    format db '%d', 0
    mesaj_n db 'Citeste n: ', 0
    mesaj_val db 'Citeste valoare: ', 0
    mesaj_afisare db 'Valoarea minima in baza 16 este: %x', 0
    nume_fisier db 'min.txt', 0
    mod_acces db 'w', 0
    descriptor dd -1

; our code starts here
segment code use32 class=code
    start:
        ; ...
         
        push dword mesaj_n 
        call [printf]
        add esp, 4 
        
        
        push dword n 
        push dword format 
        call [scanf]
        add esp, 4 * 2
        
        mov ecx, [n]
        cmp eax, 0
        jle final
        
        mov esi, 0
        citeste:
            
            pushad
            
            push dword val 
            push dword format 
            call [scanf]  
            add esp, 4 * 2
            
            popad
            
            mov ebx, [val]
            mov [sir + esi], ebx
            add esi, 4
            
            loop citeste
            
        push dword sir 
        push dword [n]
        call determinare_minim
        mov [minim], eax
        
            
            push dword mod_acces
            push dword nume_fisier
            call [fopen]
            add esp, 4 * 2
            
            mov [descriptor], eax
            cmp eax, 0
            je final
            
            
            push dword [minim]
            push dword mesaj_afisare
            push dword [descriptor]
            call [fprintf]
            add esp, 4 * 3
            
            push dword [descriptor]
            call [fclose]
            add esp, 4 * 1
            
        
        final:
    
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
