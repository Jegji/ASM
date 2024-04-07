.686 
.model flat 
extern __write : PROC 
extern __read : PROC
extern _ExitProcess@4 : PROC 
public _main 

.data 
znaki   db 12 dup (?)  
obszar  db 12 dup (?) 
dekoder db '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ'
liczba1 dd 0h
podstawa dd 12 ; podstawa wejsciiowa
podstawa2 dd 16 ; podstawa wyjsciowa
dana EQU 1 ; podstawa wejscia minus 11

.code
wczytaj_do_EAX PROC
	; max iloœæ znaków wczytywanej liczby  
	push  dword PTR 12    
	push  dword PTR OFFSET obszar ; adres obszaru pamiêci  
	push  dword PTR 0; numer urz¹dzenia (0 dla klawiatury)  
	call  __read ; odczytywanie znaków z klawiatury     ; (dwa znaki podkreœlenia przed read)  
	add  esp, 12 ; usuniêcie parametrów ze stosu 
	
	; bie¿¹ca wartoœæ przekszta³canej liczby przechowywana jest 
	; w rejestrze EAX; przyjmujemy 0 jako wartoœæ pocz¹tkow¹  
	mov   eax, 0    
	mov  ebx, OFFSET obszar ; adres obszaru ze znakami 

	pobieraj_znaki:  mov  cl, [ebx] ; pobranie kolejnej cyfry w kodzie ; ASCII  
		inc  ebx  ; zwiêkszenie indeksu  
		cmp  cl,10 ; sprawdzenie czy naciœniêto Enter  
		je  byl_enter ; skok, gdy naciœniêto Enter 
		cmp cl, '0'
		jb inny_znak
		cmp cl, '9'
		ja litera
		sub  cl, 30H ; zamiana kodu ASCII na wartoœæ cyfry 
		jmp dodanie

	litera:
		cmp cl, 'A'
		jb inny_znak ; inny znak jest ignorowany
		cmp cl, 'A'+dana
		ja sprawdzaj_dalej2
		sub cl, 'A' - 10 ; wyznaczenie kodu binarnego
		jmp dodanie

	sprawdzaj_dalej2:
		cmp cl, 'a'
		jb inny_znak ; inny znak jest ignorowany
		cmp cl, 'a'+dana
		ja inny_znak ; inny znak jest ignorowany
		sub cl, 'a' - 10
		
	dodanie:
		movzx ecx, cl ; przechowanie wartoœci cyfry w ; rejestrze ECX   ; mno¿enie wczeœniej obliczonej wartoœci razy 10  
		mul  dword PTR podstawa          
		add  eax, ecx ; dodanie ostatnio odczytanej cyfry
		
	inny_znak:
		jmp  pobieraj_znaki ; skok na pocz¹tek pêtli  
	byl_enter: 
		ret
wczytaj_do_EAX ENDP

wyswietl_eax_precision_cl PROC
	pusha 
	mov  esi, 10  ; indeks w tablicy 'znaki'  
	mov  ebx, 10  ; dzielnik równy 10  
	mov edx,esi
	sub edx,ecx
	mov ecx,edx
	konwersja:  
		mov  edx, 0 ; zerowanie starszej czêœci dzielnej  
		div  ebx  ; dzielenie przez 10, reszta w EDX, ; iloraz w EAX  
		add  dl, 30H ; zamiana reszty z dzielenia na kod ; ASCII  
		cmp esi,ecx
		je kropka
		mov  znaki [esi], dl; zapisanie cyfry w kodzie ASCII  
		dec  esi   ; zmniejszenie indeksu  
		cmp  eax, 0  ; sprawdzenie czy iloraz = 0  
		jne  konwersja  ; skok, gdy iloraz niezerowy  ; wype³nienie pozosta³ych bajtów spacjami i wpisanie ; znaków nowego wiersza 
		jmp wypeln
	kropka:
		mov znaki[esi],'.'
		dec esi
		mov znaki[esi],dl
		dec esi
		cmp  eax, 0  ; sprawdzenie czy iloraz = 0  
		jne  konwersja  ; skok, gdy iloraz niezerowy  ; wype³nienie pozosta³ych bajtów spacjami i wpisanie ; znaków nowego wiersza 
		jmp wypeln

	wypeln:
		or  esi, esi  
		jz  wyswietl  ; skok, gdy ESI = 0
		cmp esi,ecx
		je kropkav2
		cmp esi,ecx
		jb spacja
		mov  byte PTR znaki [esi], '0' ; kod spacji  
		dec  esi   ; zmniejszenie indeksu  
		jmp  wypeln 
		spacja:
		mov  byte PTR znaki [esi], ' ' ; kod spacji  
		dec  esi   ; zmniejszenie indeksu 
		jmp  wypeln   
	
	kropkav2:
		mov  byte PTR znaki [esi], '.'
		dec esi
		mov  byte PTR znaki [esi], '0'
		dec esi
		jmp wypeln

	wyswietl:  
		mov  byte PTR znaki [0], 0AH ; kod nowego wiersza  
		mov  byte PTR znaki [11], 0AH ; kod nowego wiersza  
	
	; wyœwietlenie cyfr na ekranie  
	push  dword PTR 12 ; liczba wyœwietlanych znaków  
	push  dword PTR OFFSET znaki ; adres wyœw. obszaru  
	push  dword PTR 1; numer urz¹dzenia (ekran ma numer 1)  
	call  __write  ; wyœwietlenie liczby na ekranie  
	add  esp, 12  ; usuniêcie parametrów ze stosu 
	popa
	ret
wyswietl_eax_precision_cl ENDP


_main PROC

	call wczytaj_do_EAX
	mov liczba1,eax
	call wczytaj_do_EAX
	mov edx,0
	mov ecx,1000
	mul ecx
	div liczba1
	mov ecx,3
	call wyswietl_eax_precision_cl
	push 0
	call _ExitProcess@4
_main ENDP
END