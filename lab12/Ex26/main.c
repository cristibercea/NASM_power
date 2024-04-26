#include <stdio.h>

// Dacă utilizăm compilatorul C din Microsoft Visual Studio 2015, 2017, 2019
// este necesar să includem librăria legacy_stdio_definitions.lib la linkeditare
#pragma comment(lib, "legacy_stdio_definitions.lib")

// Această librărie este necesară doar pentru Microsoft Visual Studio 2019
#pragma comment(lib, "legacy_stdio_wide_specifiers.lib")

int minim(int ,int v[]);

int main(){
    int n,v[100];
    printf("Dati numarul de elemente din vector: ");
    scanf("%d", &n);
    for(int i=0;i<n;i++) {printf("v[%d] = ",i+1); scanf("%d", &v[i]);}
    FILE * f = fopen("min.txt","w");
    fprintf(f,"%x",minim(n,v));
    fclose(f);
    return 0;
}