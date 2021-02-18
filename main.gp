encodegln(s,n)={    \\fonctionne correctement
  my(v);
  v=[if(x==32,0,x-96)|x<-Vec(Vecsmall(s))];
  if(#v>n^2,warning("string truncated to length ",n^2));
  v = Vec(v,n^2);
  A=matrix(n,n,i,j,v[(i-1)*n+j]);
  return(A);
}

decodegln(m,n)={  \\Fonctionne correctement
	r=vector(144);
	for(i=1,n,for(j=1,n,r[(i-1)*n+j]=m[i,j]));
	r=lift(r);
	for(i=1,144,if(r[i]==0,r[i]=32,r[i]=r[i]+96));
	return(Strchr(r));
}

expoRapideMat(Matrice,n) = {
	if(n==0,return (mathid(matsize(Matrice)[1])));
	if(n==1,return (Matrice));
	if(n%2==0,return (expoRapideMat(Matrice^2,n/2)),return(Matrice*expoRapideMat(Matrice^2,(n-1)/2)));	
}

indiceIdempotence(M)={
	idMod=Mod(matid(12),27);
	k=1;
	P=M;
	while(P!=idMod,P=P*M;k++);
	return(k);
}


text=readvec("input.txt")[1]; \\Récupération du fichier input
\\text[1] t contient le texte avec les espaces
C=encodegln(text[1],12);

Cmod=Mod(C,27);
idem=indiceIdempotence(Cmod);


\\Calcul de l'inverse de 65537 mod idem en passant par le pgcd
bez=bezout(65537,idem);

M=expoRapideMat(Cmod,bez[1]);
m=decodegln(M,12);
print(m); 
