#include <stdio.h>

int main(){
    int v1[10] = {2, 6, -3, 11, 9, 18, -13, 16, 5, 1};
    int v2[10] = {4, 2, -13, 3, 9, 9, 7, 16, 4, 7};
    int v3[10];
    int i = 0, j = 0, k = 0;

    for (i = 0; i < 10; i++){

        for(j = 0; j < 10; j++){

            if(v1[i] == v2[j]){
                
                v3[k] = v1[i];
                k++;
                break;
            }
        }
    }

    printf("\nVettore V3: ");
    for (i = 0; i < k; i++){
        printf("%d ", v3[i]);
    }
    printf("\n");
    return 0;
}
