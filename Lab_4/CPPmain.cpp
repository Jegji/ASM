#include <stdio.h>
#include<iostream>

extern "C" {
	unsigned int fibonacci(unsigned char directory);
}

int main()
{
	std::cout << fibonacci((char)1)<<std::endl;
	std::cout << fibonacci((char)2) << std::endl;
	std::cout << fibonacci((char)3) << std::endl;
	std::cout << fibonacci((char)4) << std::endl;
	std::cout << fibonacci((char)5) << std::endl;
	std::cout << fibonacci((char)6) << std::endl;
	std::cout << fibonacci((char)7) << std::endl;
	std::cout << fibonacci((char)48) << std::endl;
	std::cout << fibonacci((char)0) << std::endl;
	return 0;
}