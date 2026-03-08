Ce crackme va :

- Stocker le flag XORé etc au format hexadecimal
- Stocker la clé qui est une chaine de 32 carac 
- Prendre l'input, vérifier sa taille, si pas 16 carac -> jmp error
- Ensuite il va prendre chaque octet de l'input, le XORé avec un caractère choisi "aléatoirement" dans la clé (car la clé sera une chaine de caractère et pas juste un carac sinon trop facile).
- Attention, la fonction qui va choisir avec quel carac de la clé sera XORé mon carac devra être pensée pr que le resultat soit le même que mon flag obfusqué !!
- Après avoir XORé le tout je compare le resultat à mon flag jne ERROR sinon good job !!
- FLAG : "Stq1R_V66REu{N2R" (16 chars)


NOtre fonction pour rendre pseudo-aléatoire le choix du prochain carac de la clé avec lequel on va XORé notre offset est telle que :
On prend le compteur i , on le multiplie par 7 puis on ajoute 3 et enfin on fait modulo 31 pour que notre résultat reste entre 0 et 31 
Pour le modulo, on utilise le AND car il est plus rapide que DIV (fonctionne car 32 est multiple de 2)


- On va aussi ajouter : - du junk code 
                        - un flux de contrôle opaque
                        - une mutation des registres
