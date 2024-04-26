bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit               ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
                          ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions

; our data is declared here (the variables needed by our program)
segment data use32 class=data
    ; e=a/(b-7) +c*d + e
    a db 10
    b dw 8
    c dw 12
    d dw 1
    e dq -1
    ; cu semn
    aux dw 0 ; aux pentru a salva rez intermediar din ax

; our code starts here
segment code use32 class=code
    start:
        ; b-7
        mov bx, [b]
        sub bx, 7 ; bx = b-7
        
        ;a/(b-7)
        ;byte / bx
        ; a de la byte la doublewordul dx:ax
        movsx ax, byte[a]
        CWD ; ax-> dx:ax ; adica in dx val bitului de semn
        idiv bx ; dx:ax/bx = ax cat si dx rest, ignoram restul
        ; ax = a/(b-7)
        mov word[aux], ax ; aux = a/(b-7)
        
        ;c*d
        mov ax, [c]
        imul word[d] ; c*d = dx:ax
        
        ;; e=a/(b-7) +c*d + e
        ;      aux   + dx:ax  + e
        ;       word  + dd     +quad
        
        ; dx:ax -> reg compact ebx
        push dx
        push ax
        pop ebx
        
         ;; e=a/(b-7) +c*d + e
        ;      aux   + ebx  + e
        ;       word  + dd     +quad
        ; word aux sa devina doublwword compact
        
        movsx ecx, word[aux] ; ecx = a/(b-7)
        add ecx, ebx ; ecx = a/(b-7) +c*d
        
        ;; e=a/(b-7) +c*d + e
                      ; ecx  + q
                      ; ecx -> edx:eax 
                      ; cdq
        mov eax, ecx
        cdq ; edx:eax = a/(b-7) +c*d
        
        ; adunam la edx:eax  cele 2 jumatati ale quadwordului 
        add eax, dword[e+0]
        adc edx, dword[e+4]
        ; rez final in edx:eax 
        
        
        
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
