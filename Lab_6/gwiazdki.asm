; Program gwiazdki.asm
; Wy�wietlanie znak�w * w takt przerwa� zegarowych
; Uruchomienie w trybie rzeczywistym procesora x86
; lub na maszynie wirtualnej
; zako�czenie programu po naci�ni�ciu klawisza 'x'
; asemblacja (MASM 4.0): masm gwiazdki.asm,,,;
; konsolidacja (LINK 3.60): link gwiazdki.obj;
.386
rozkazy SEGMENT use16
ASSUME CS:rozkazy


read PROC
	push ax
	in al,60H
	cmp al,4bh
	je lewo1
	cmp al,4dh
	je prawo2
	cmp al,48h
	je gora3
	cmp al,50h
	je dol4
	jmp stop

	lewo1:
		mov cs:kierunek, 1
		jmp stop
	prawo2:
		mov cs:kierunek, 3
		jmp stop

	gora3:
		mov cs:kierunek, 0
		jmp stop

	dol4:
		mov cs:kierunek,2
		jmp stop

	stop:
	;mov cs:kierunek,al
	pop ax
    jmp dword ptr cs:vec9
	vec9 dd ?

read ENDP

;============================================================
; procedura obs�ugi przerwania zegarowego
obsluga_zegara PROC
; przechowanie u�ywanych rejestr�w
push ax
push bx
push es
; wpisanie adresu pami�ci ekranu do rejestru ES - pami��
; ekranu dla trybu tekstowego zaczyna si� od adresu B8000H,
; jednak do rejestru ES wpisujemy warto�� B800H,
; bo w trakcie obliczenia adresu procesor ka�dorazowo mno�y
; zawarto�� rejestru ES przez 16
mov ax, 0B800h ;adres pami�ci ekranu
mov es, ax
; zmienna 'licznik' zawiera adres bie��cy w pami�ci ekranu
mov bx, cs:licznik
; przes�anie do pami�ci ekranu kodu ASCII wy�wietlanego znaku
; i kodu koloru: bia�y na czarnym tle (do nast�pnego bajtu)

; zwi�kszenie o 2 adresu bie��cego w pami�ci ekranu

cmp cs:kierunek,0
je gora
cmp cs:kierunek,1
je lewo
cmp cs:kierunek,2
je dol
cmp cs:kierunek,3
je prawo

gora:
mov byte PTR es:[bx], '^' ; kod ASCII
mov byte PTR es:[bx+1], 00101000B ; kolor
	sub bx,160	
	jmp dalej
lewo:
mov byte PTR es:[bx], '<' ; kod ASCII
mov byte PTR es:[bx+1], 00101000B ; kolor
	sub bx,2	
	jmp dalej
dol:
mov byte PTR es:[bx], 'v' ; kod ASCII
mov byte PTR es:[bx+1], 00101000B ; kolor
	add bx,160	
	jmp dalej
prawo:
mov byte PTR es:[bx], '>' ; kod ASCII
mov byte PTR es:[bx+1], 00101000B ; kolor
	add bx,2
dalej:
; sprawdzenie czy adres bie��cy osi�gn�� koniec pami�ci ekranu
cmp bx,4000
jb wysw_dalej ; skok gdy nie koniec ekranu
; wyzerowanie adresu bie��cego, gdy ca�y ekran zapisany
mov bx, 0
;zapisanie adresu bie��cego do zmiennej 'licznik'
wysw_dalej:
mov cs:licznik,bx
; odtworzenie rejestr�w
pop es
pop bx
pop ax
; skok do oryginalnej procedury obs�ugi przerwania zegarowego
jmp dword PTR cs:wektor8
; dane programu ze wzgl�du na specyfik� obs�ugi przerwa�
; umieszczone s� w segmencie kodu
licznik dw 320 ; wy�wietlanie pocz�wszy od 2. wiersza
wektor8 dd ?
kierunek db 3
obsluga_zegara ENDP
;============================================================
; program g��wny - instalacja i deinstalacja procedury
; obs�ugi przerwa�
; ustalenie strony nr 0 dla trybu tekstowego
zacznij:
mov al, 0
mov ah, 5
int 10
mov ax, 0
mov ds,ax ; zerowanie rejestru DS
; odczytanie zawarto�ci wektora nr 8 i zapisanie go
; w zmiennej 'wektor8' (wektor nr 8 zajmuje w pami�ci 4 bajty
; pocz�wszy od adresu fizycznego 8 * 4 = 32)
mov eax,ds:[32] ; adres fizyczny 0*16 + 32 = 32
mov cs:wektor8, eax
    mov eax,ds:[36] ; adres fizyczny 0*16 + 32 = 32
    mov cs:vec9, eax

; wpisanie do wektora nr 8 adresu procedury 'obsluga_zegara'
mov ax, SEG obsluga_zegara ; cz�� segmentowa adresu
mov bx, OFFSET obsluga_zegara ; offset adresu
mov dx, SEG read
mov cx, OFFSET read
cli ; zablokowanie przerwa�
; zapisanie adresu procedury do wektora nr 8
mov ds:[32], bx ; OFFSET
mov ds:[34], ax ; cz. segmentowa

    mov ds:[36], cx
    mov ds:[38], dx
sti ;odblokowanie przerwa�
; oczekiwanie na naci�ni�cie klawisza 'x'
aktywne_oczekiwanie:
mov ah,1
int 16H
; funkcja INT 16H (AH=1) BIOSu ustawia ZF=1 je�li
; naci�ni�to jaki� klawisz
jz aktywne_oczekiwanie
; odczytanie kodu ASCII naci�ni�tego klawisza (INT 16H, AH=0)
; do rejestru AL
mov ah, 0
int 16H
cmp al, 'x' ; por�wnanie z kodem litery 'x'
jne aktywne_oczekiwanie ; skok, gdy inny znak
; deinstalacja procedury obs�ugi przerwania zegarowego
; odtworzenie oryginalnej zawarto�ci wektora nr 8
mov eax, cs:wektor8
cli
mov ds:[32], eax ; przes�anie warto�ci oryginalnej
; do wektora 8 w tablicy wektor�w
; przerwa�
sti
mov eax, cs:vec9
    cli
    mov ds:[36], eax
    sti
; zako�czenie programu
mov al, 0
mov ah, 4CH
int 21H
rozkazy ENDS
nasz_stos SEGMENT stack
db 128 dup (?)
nasz_stos ENDS
END zacznij