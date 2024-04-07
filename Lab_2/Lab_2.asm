; wczytywanie i wyúwietlanie tekstu wielkimi literami
; (inne znaki siÍ nie zmieniajπ)
.686
.model flat
extern _ExitProcess@4 : PROC
extern _MessageBoxA@16 : PROC
extern _MessageBoxW@16 : PROC
extern __write : PROC ; (dwa znaki podkreúlenia)
extern __read : PROC ; (dwa znaki podkreúlenia)
public _main
.data
	magazyn db "dziala ",'G',' ','G',234,' ','G',234,182,'G',234,182,' ',177,230,234,179,241,243,182,188,191," dziala",10
	koniec_t db ?
	magazyn_out dw 80 dup (?)
	nowa_linia db 10
	liczba_znakow dd ?
	tytul dw 'W','y','n','i','k',10
	polskie_znaki_Latin db 165,134,169,136,228,162,152,171,190,0 ;lista zawierajaca male polskie znaki {π,Ê,Í,≥,Ò,Û,ú,ü,ø}
	polskie_duze_znaki_Latin db 164,143,168,157,227,224,151,141,189,0 ;lista zawierajaca duze polskie znaki {•,∆, ,£,—,”,å,è,Ø}
	polskie_znaki_win db 185,230,234,179,241,243,156,159,191,0 
	polskie_znaki_iso db 177,230,234,179,241,243,182,188,191,0
	polskie_duze_znaki_win db 165,198,202,163,209,211,140,143,175,0
	polskieznakiutf dw 0105H,0107H,0119H,0142H,0144H,00F3H,015BH,017AH,017CH,0
.code
_main PROC
	 mov ecx,(OFFSET koniec_t) - (OFFSET magazyn)

	 mov liczba_znakow, ecx

	 mov eax, 0 ; slowo utf
	 mov ebx, 0 ; polska pentla przez tablice
	 mov esi, 0 ; index tablicy
	 mov edx, 0 ;slowo przed konwersja
	 mov edi,0;



	ptl: 
		mov ebx,0
		mov dl,magazyn[esi]
		cmp dl,'z'
		ja polski
		cmp dl,'G'
		je ges
		powrot:
		mov ax,0000h
		mov al,dl
		jmp koniec
	polski:
		cmp polskie_znaki_iso[ebx], 0 ;sprawdzenie czy koniec listy
		je koniec
		cmp dl, polskie_znaki_iso[ebx]
		je zmiana_polskie
		inc ebx
		jmp polski
	ges:
		mov ah,magazyn[esi+1]
		cmp ah,234
		jne powrot
		mov ah,magazyn[esi+2]
		cmp ah,182
		jne powrot
		mov ax,0D83Eh
		mov magazyn_out[edi*2],ax
		inc edi
		mov ax,0DD86h
		inc esi
		inc esi
		dec ecx
		dec ecx
		jmp koniec

	zmiana_polskie:
		mov ax,polskieznakiutf[ebx*2]
	koniec:
		mov magazyn_out[edi*2],ax
		inc esi
		inc edi
	loop ptl

	; wyúwietlenie przekszta≥conego tekstu
	push 0 ; sta≥a MB_OK
	; adres obszaru zawierajπcego tytu≥
	push OFFSET tytul
	; adres obszaru zawierajπcego tekst
	push OFFSET magazyn_out
	push 0 ; NULL
 call _MessageBoxW@16

	 call _ExitProcess@4 ; zakoÒczenie programu
_main ENDP
END