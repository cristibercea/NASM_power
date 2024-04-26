bits 32 

global _add

; our code starts here
segment code use32 class=code
    _add:
        push ebp
        mov ebp, esp
        
        mov eax, [ebp+8]
        add eax, [ebp+12]
        add eax, [ebp+16]
        
        mov esp, ebp
        pop ebp
        
        ret