#include <stdlib.h>
#include <stdio.h>

int main(){

FILE * f = fopen("STOCK.txt","a");
int lim1 = 35;
int lim2 = 43;
int lim3 = 39;
int lim4 = 47;
int pointure;
int id = 18;
// char marque[] = "Nike";
// char modele[] = "Air Max 1";
// char genre = 'M';
// int prix = 130;
// for(int i=;i<5;i++)
//     fprintf(f,"%s/%s/%d/M/%d \n",marque,modele,pointure,prix);
// }
// char categorie[] = "Derbies";
// for(int j=lim3;j<lim4;j++){
//   pointure=j;
//   fprintf(f, "%d/%d/5/t\n", id,pointure);
// }
for(int j=lim3;j<lim4;j++){
  pointure=j;
  fprintf(f, "%d/%d/5/t\n", id,pointure);
}
return 0;
}
// Nike/AF1/M/130
// 1/43/5/TRUE
//large object
