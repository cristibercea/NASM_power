bits 32 ; assembling for the 32 bits architecture

global _minim

; our code starts here
segment code use32 class=code
    _minim:
        push ebp
        mov ebp, esp
        
        mov edx, 0x0FFFFFFF ;in edx vom pune minimul
        mov ecx, [ebp+8] ;ecx=n
        jecxz final
        mov esi, [ebp+12] ;esi=pointer-ul v
        repeta:
            lodsd
            cmp eax, edx
            jge continua
            mov edx, eax 
            continua:
        loop repeta
        mov eax, edx 
        
        final:
        mov esp, ebp
        pop ebp
        ret