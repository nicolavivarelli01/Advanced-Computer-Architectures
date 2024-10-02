int main(){
    int v1[10], v2[10], v3[10];
    int i = 0, j = 0, k = 0, f1 = 0, f2 = 0, f3 = 0;

    for (i = 0; i < 10; i++){

        for(j = 0; j < 10; j++){

            if(v1[i] == v2[j]){
                
                v3[k] = v1[i];
                k++;
            }
        }
    }
}
