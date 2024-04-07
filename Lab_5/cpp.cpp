#include <iostream>

using namespace std;

extern "C" {
	float dylatacja_czasu(unsigned int delta_t_zero, float predkosc);
	void szybki_max(short int t_1[], short int t_2[], short int t_wynik[], int n);
}

int main() {
	std::cout << dylatacja_czasu(10,10000.0f)<<std::endl;
	std::cout << dylatacja_czasu(10, 200000000.0f) << std::endl;
	std::cout << dylatacja_czasu(60, 270000000.0f) << std::endl;
	short int val1[16] = { 1, -1, 2, -2, 3, -3, 4, -4, 5, -5, 6, -6, 7, -7, -8, 8 };
	short int val2[16] = { -3, -2, -1, 0, 1, 2, 3, 4, 256, -256, 257, -257, 258, -258, 0, 0 };
	short int wynik[16];
	szybki_max(val1, val2, wynik, 16);
	for (int i = 0; i < 16; i++) {
		std::cout << wynik[i] << " ";
	}
}