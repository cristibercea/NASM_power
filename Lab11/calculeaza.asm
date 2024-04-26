bits 32 ; assembling for the 32 bits architecture


global calculeaza      




; our code starts here
segment code use32 class=code
    calculeaza:
        ; eax = a
        mov eax, [esp+4]
        ;eax = a + b
        add eax, [esp+8]
        ;eax = a + b - c
        sub eax, [esp+12]
        
        ret 4*3
        
        
