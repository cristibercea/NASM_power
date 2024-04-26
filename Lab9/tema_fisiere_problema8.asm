bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit,printf,fread,fopen,fclose
import printf msvcrt.dll
import fread msvcrt.dll
import fopen msvcrt.dll
import fclose msvcrt.dll
import exit msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
                          ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions

; our data is declared here (the variables needed by our program)
segment data use32 class=data
    ; ...
    len equ 250                         ;se vor citi 250 de caractere din fisier
    text times (len+1) db 0             ;se defineste in memorie string-ul care va retine continutul fisierului
    letter_frequency times 26 db 0      ;26 litere in alfabetul englez care "apar de zero ori" pana la executia codului
    max db 0                            ;nr max de aparitii
    aux resd 1                          ;aici se salveaza ecx in ultimul loop (printf modifica ecx, deci  valoarea sa initiala trebuie salvata pentru a nu fi afectat loop-ul)
    
    fin dd 'data.txt',0                         ;numele fisierului
    descriptor dd -1                            ;descriptorul fisierului data.txt
    open_format dd 'r',0                        ;deschidem fisierul pentru read
    
    format db 'Litera "%c" apare de %d ori in fisier!',13,10,0        ;formatul pentru afisare

;Se da un fisier text. Sa se citeasca continutul fisierului, sa se determine litera mare (uppercase) cu cea mai mare ;frecventa si sa se afiseze acea litera, impreuna cu frecventa acesteia. Numele fisierului text este definit in ;segmentul de date.
; our code starts here
segment code use32 class=code
    start:
        ; ...
        ;deschidere fisier pentru read
        push dword open_format
        push dword fin
        call [fopen]
        add esp, 4*2
        cmp eax, 0             ;eax==0: daca accesarea fisierului a esuat
            je final           ;se sare la finalul programului
        mov [descriptor], eax  ;altfel se salveaza descriptorul fisierului deschis pt read
        
        ;citire continut fisier
        push dword [descriptor]
        push dword len
        push dword 1
        push dword text
        call [fread]
        add esp, 4*4
        
        ;daca nu s-a citit niciun caracter din fisier, se sare la final
        mov eax, [text]
        cmp eax, 0
        je final
        
        ;pregatire parcurgere sir text
        mov ecx, len
        mov esi, text ;directie: s->d
        cld           ;directie: s->d
        do:      ;parcurgere sir text si crearea sirului letter_frequency
            lodsb     ;se incarca in al un caracter din sirul "text"
            cmp al,'A'
                jb continue
            cmp al,'Z'
                ja continue
            
            ;daca caracterul din al este intre A si Z, atunci ii va creste frecventa
            sub al, 'A'                    ;al = "litera_mare-'A'" (numarul "litera_mare-'A'" e in multimea {0,1,...,25})
            movzx edx, al                  ;edx = al
            mov bl, byte [letter_frequency+edx] ;bl = letter_frequency[edx]
            inc bl                              ;bl++
            mov [letter_frequency+edx], bl      ;letter_frequency[edx] = bl
            continue:
        loop do
        
        ;pregatire parcurgere letter_frequency
        mov ecx, 26
        mov esi, letter_frequency ;directie: s->d
        cld                       ;directie: s->d
        do2:      ;parcurgere letter_frequency pentru a afla maximul de aparitii
            lodsb ;se incarca in al un numar din sirul "letter_frequency"
            cmp al, [max]
                jbe continue2
            ;al>max
            mov [max],al     ;max=al
            continue2: 
        loop do2
        
        ;pregatire parcurgere letter_frequency
        mov ecx, 26 
        mov edi, 0
        mov esi, letter_frequency ;directie: s->d
        cld                       ;directie: s->d
        do3:      ;parcurgere letter_frequency pentru a printa litera cu nr max de aparitii
            lodsb
            cmp al, [max]
                jne continue3
            
            ;pregatirea termenilor de afisat
            mov al, 'A'
            movzx eax, al
            add eax, edi
            mov dl, [max]
            movzx edx, dl
            mov [aux], ecx
            
            ;printarea literei si a numarului de aparitii
            push dword edx
            push dword eax
            push dword format
            call [printf]
            add esi, 4*3
            
            mov ecx, 1 ;am gasit litera cu nr max de aparitii, deci vom iesi din loop
            continue3: 
            inc edi
        loop do3
        
        final:
        ;se inchide fisierul
        push dword [descriptor]
        call [fclose]
        add esp, 4
        
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
