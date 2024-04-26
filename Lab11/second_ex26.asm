bits 32 ; assembling for the 32 bits architecture

global determinare_minim        

segment code use32 class=code

    determinare_minim:
        mov esi, [esp + 8]
        mov ecx, [esp + 4]
        mov eax, [esi]; eax - minimul
        sub ecx, 1
        cmp ecx, 0
        je iesire
        
        add esi, 4
        cauta:
            mov ebx, [esi]; ebx: valoare curenta din sir
            cmp ebx, eax 
            jge continua
            
            mov eax, ebx 
            
            continua:
                add esi, 4
        loop cauta
        
        iesire:
            ret 4*2