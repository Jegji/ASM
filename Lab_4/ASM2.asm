.686
.model flat
public fibonacci

.code
fibonacci PROC c,  char:byte
    
    push esi
    push ebx
    push edi

    cmp char,47
    ja over
    movzx esi,char
    cmp esi,0
    je zero
    cmp esi,2
    jbe jeden

    dec esi
    push esi
    call fibonacci
    add esp,4
    mov ebx, eax
    dec esi
    push esi
    call fibonacci
    add esp,4
    add eax,ebx
    jmp koniec



    jeden:
        mov eax,1
        jmp koniec

    zero:
        mov eax,0
        jmp koniec

    over:
        mov eax,-1

    koniec:
        pop edi
        pop ebx
        pop esi
        ret
fibonacci ENDP


END