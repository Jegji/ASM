.686
.model flat
.XMM
.data
	const dq 300000000.0
.code

dylatacja_czasu PROC c, delta:dword,speed:dword
	push ebx
	push edi
	push esi

	finit
	fld const
	fmul st(0), st(0)
	fld speed
	fmul st(0),st(0)
	fdiv st(0),st(1)
	fld1
	fsub st(0),st(1)
	fsqrt
	fild delta
	fdivr
	pop esi
	pop edi
	pop ebx
	ret
dylatacja_czasu ENDP

szybki_max PROC c, tab_a:dword, tab_b:dword, tab_w:dword, count:dword
	push ebx
	push edi
	push esi
	push ecx
	
	mov eax,count
	mov edx,0
	mov edi ,8
	div edi
	mov ecx,eax
	
	mov esi, tab_a ; adres pierwszej tablicy
	mov edi, tab_b ; adres drugiej tablicy
	mov ebx, tab_w ; adres tablicy wynikowej
	ptl:
		movups xmm0, [esi]
		movups xmm1, [edi]
		pmaxsw xmm0 ,xmm1
		movups [ebx], xmm0
		
		add esi,16
		add edi,16
		add ebx,16
	loop ptl
	
	pop ecx
	pop esi
	pop edi
	pop ebx
	ret
szybki_max ENDP

END