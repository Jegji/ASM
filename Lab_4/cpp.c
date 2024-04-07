#include <stdio.h>

extern __int64 sum(unsigned int n, ...);

int main() {
	printf("%lld \n",sum(8, 1LL, 2LL,3LL,4LL,5LL,6LL,7LL,8LL));
	printf("%lld \n", sum(0));
	printf("%lld \n", sum(5, 1000000000000LL, 2LL, 3LL, 4LL, 5LL));
	printf("%lld \n", sum(3, -3LL, -2LL, -1LL));

}