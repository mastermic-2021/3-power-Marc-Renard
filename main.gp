encodegln(s,n)={    \\fonctionne correctement
  my(v);
  v=[if(x==32,0,x-96)|x<-Vec(Vecsmall(s))];
  if(#v>n^2,warning("string truncated to length ",n^2));
  v = Vec(v,n^2);
  matrix(n,n,i,j,v[(i-1)*n+j]);
}

decodegln(m,n)={  \\Fonctionne correctement
	my(r);
        \\ contruction d'un vecteur de taille n^2 pour y stocker la matrice du chiffré
	r=vector(n^2);
	\\ on remplit le vecteur avec les coefficients de la matrice
	for(i=1,n,for(j=1,n,r[(i-1)*n+j]=m[i,j]));
	\\ on repasse en écriture entière et non en écriture modulaire
	r=lift(r);
	\\ On traduit en ASCII
	for(i=1,n^2,if(r[i]==0,r[i]=32,r[i]=r[i]+96));
	r=Vec(r,143); \\ on retire le dernier caractère car il semble que la checksum ait été calculée sur le texte sans l'espace à la fin
	\\ on renvoie la chaine de caractère correspondant à la suite d'ASCII
	return(Strchr(r));
}



expoRapideMat(Matrice,n) = {
	if(n==0,return (mathid(matsize(Matrice)[1])));
	if(n==1,return (Matrice));
	if(n%2==0,return (expoRapideMat(Matrice^2,n/2)),return(Matrice*expoRapideMat(Matrice^2,(n-1)/2)));	
}

\\ indiceIdempotence permet de trouver le plus petit d tel que M^d=ID
indiceIdempotence(M)={
	idMod=Mod(matid(12),27);
	k=1;
	P=M;
	while(P!=idMod,P=P*M;k++);
	return(k);
}


text=readstr("input.txt")[1]; \\Récupération du fichier input
\\text contient le texte avec les espaces
C=encodegln(text,12);

Cmod=Mod(C,27);
idem=indiceIdempotence(Cmod);
\\ on sait ici que M^idem=Id


\\Calcul de l'inverse de 65537 mod idem en passant par le pgcd et les coefficients de Bezout
bez=bezout(65537,idem);

Mprime=expoRapideMat(Cmod,bez[1]);
\\ Mprime=(M^65537)bez[1]=M^(65537*bez[1]) or 65537*bez[1] mod (idem) =1
\\ Donc Mprime=M^1=M
m=decodegln(Mprime,12);
print(m); 
