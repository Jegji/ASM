public sum

.code
	sum PROC 
		push RBP
		mov rbp,rsp
		push RBX
		PUSH RDI
		push RSI

		mov RAX,0
		;rcx counter liczba 

		cmp RCX,0
		jz koniec
		add RAX,RDX
		dec RCX
		jz koniec
		add RAX,R8
		dec RCX
		jz koniec
		add RAX,R9
		dec RCX
		jz koniec
		lea RSI, [RBP+32+16]
		ptl:
			add RAX,[RSI]	
			add RSI,8
		loop ptl;



		koniec:
			pop RSI
			pop RDI
			pop RBX
			pop RBP
			ret


	sum ENDP
END