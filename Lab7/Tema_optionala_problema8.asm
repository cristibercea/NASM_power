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
    
        ;Se da un sir de dublucuvinte. Sa se obtina sirul format din octetii inferiori ai
    ;cuvintelor superioare din elementele sirului de dublucuvinte care sunt palindrom in scrierea in baza 10.
            ;Exemplu:
            
        ;Se da sirul de dublucuvinte:
        ;s DD 12345678h, 1A2C3C4Dh, 98FCDC76h
        
        ;Sa se obtina sirul
        ;d DB 2Ch, FCh
        
    s dd 12345678h, 1A2C3C4Dh, 98FCDC76h
    ls equ ($-s)/4
    d resb ls
    aux resb 1
    
; Nota: Rezolvare pentru numere unsigned
; our code starts here
segment code use32 class=code
    start:
        ; ...
        mov esi, s+2
        mov edi, d
        mov ecx, ls
        repeta:
            cld ;pregateste load-ul din sir (DF=0, directie st->dr) 
            lodsb ;incarca in al octetii inferiori ai cuvintelor superioare din elementele sirului, esi+=1
            mov byte[aux], al ;salveaza intr-un auxiliar valoarea octetului 
            movzx ax, al ;ax= 00_al
            
            cmp ax, 10
                jb numarSub10 ;daca numarul are doar o cifra, este palindrom 
                
            cmp ax, 100
                jb numarSub100 ;daca numarul are doua cifre, se sare la eticheta
            
            ;daca numarul are 3 cifre se executa codul de aici
            mov bl, 100 
            div bl ;al= a 3-a cifra a numarului din octetul selectat = cifra sutelor 
            mov dl, al ;dl= cifra sutelor
            movzx ax, ah ;ax=ultimele doua cifre ale numarului
            mov bl, 10
            div bl ;ah= ultima cifra a numarului din octetul initial (adica cifra unitatilor)
            
            cmp dl, ah
                jne final_loop ;daca dl!=ah, numarul nu e palindrom
            mov al, byte[aux] ;numarul e palindrom, se preia din aux si se pune in ax
            cld ;DF=0
            stosb ;se salveaza ax la adresa stocata in edi (sirul d); edi+=1
            jmp final_loop
            
            numarSub100:
                mov bl, 10
                div bl
                cmp al, ah ;in al este cifra zecilor, iar in ah e cifra unitatilor, ale numarului din octetul selectat 
                    jne final_loop ;nr nu este un palindrom 
                mov al, byte[aux] ;numarul e palindrom, se preia din aux si se pune in ax
                cld ;DF=0
                stosb ;se salveaza ax la adresa stocata in edi (sirul d); edi+=1
                jmp final_loop
            
            numarSub10:
                mov al, byte[aux] ;numarul e palindrom, se preia din aux si se pune in ax
                cld ;DF=0
                stosb ;se salveaza ax la adresa stocata in edi (sirul d); edi+=1
                
            final_loop:
                add esi,3 ;se trece la urmatorul dublucuvant din sirul s
                mov byte[aux], 0 ;aux=0
        loop repeta
        
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
