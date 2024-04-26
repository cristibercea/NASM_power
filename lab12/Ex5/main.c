#include <stdio.h>

// Dacă utilizăm compilatorul C din Microsoft Visual Studio 2015, 2017, 2019
// este necesar să includem librăria legacy_stdio_definitions.lib la linkeditare
#pragma comment(lib, "legacy_stdio_definitions.lib")

// Această librărie este necesară doar pentru Microsoft Visual Studio 2019
#pragma comment(lib, "legacy_stdio_wide_specifiers.lib")

int add(int, int, int);

int main(){
    int a,b,c;
    printf("Dati a,b si c: ");
    scanf("%d%d%d", &a, &b, &c);
    printf("\n sum = %d",add(a,b,c));
    return 0;
}