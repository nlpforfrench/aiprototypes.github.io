# Machine Learning : algorithmes et mathématiques 🇫🇷

[Xiaoou WANG](https://https://scholar.google.fr/citations?user=vKAMMpwAAAAJ&hl=en)

Sur la page Wikipédia de Gradient Descent vous pouvez lire : l'algorithme du gradient désigne un algorithme d'optimisation différentiable. En termes mathématiques cette phrase est magnifiquement formulée avec une telle concision qu'à chaque fois je la vois ça me donne la chair de poule.

Cependant pour les non-matheux, c'est du chinois, ou du grec, c'est selon.

Cette série de posts est destinée aux gens (souvent en sciences humaines) qui n'ont que quelques notions très basiques de maths (équation, triangle, etc.) mais qui, par les aléas de la vie, se trouvent fascinés par le monde du Machine Learning ou celui du Traitement Automatique des Langues.

Le monde des mathématiques est immense et par conséquent dangereux. Vous risquez bien de vous perdre sans bonne compagnie. J'espère que cette série vous servira de repères et de points de départ.

```{admonition} Disclaimer
Ces tutos sont largement inspirés du cours de Machine Learning d'Andrew Ng sur Coursera et son cours donné à Stanford nommé CS229. Parfois j'utilise aussi les contenus du cours de Imperial College London nommé Mathematics for Mathematics learning.
```

Je ne prétends nullement être le "créateur" de ces contenus. Il s'agit juste d'une tentative de vulgarisation scientifique au profit de la communauté de TAL en France dont je fais partie.

Si vous trouvez une typo ou des imprécisions, merci de faire un pull request sur [mon dépôt Git](https://github.com/nlpinfrench/nlpinfrench.github.io/tree/master/source/math).

##  Pour une algèbre linéaire

Considérez l'algèbre linéaire comme un ami qui vous facilite la vie. Ainsi au lieu d'écrire :

$$4x_1 − 5x_2 = −13$$

$$-2x_1 + 3x_2 = 9$$

Vous écrivez :

$$Ax= b$$

$$\text { avec } A=\left[\begin{array}{cc}{4} & {-5} \\ {-2} & {3}\end{array}\right], b=\left[\begin{array}{c}{-13} \\ {9}\end{array}\right]$$

Chouette, n'est-ce pas ? L'algèbre n'est rien plus qu'une façon de parler plus en parlant peu. :D

###  Matrices, vecteurs et autres symboles

Les symboles comme $A$ désignent des matrices. Dans le monde de l'algèbre linéaire les symboles sont légion :

- $A \in \mathbb{R}^{m \times n}$，signifiant que $A$ est une matrice de taille (m, n), autrement dit de $m$ lignes et de $n$ colonnes.

- $x \in \mathbb{R}^{ n}$ désigne un vecteur de $n$ éléments. En règle générale $x$ fait référence à un vecteur colonne avec n lignes et 1 colonne. Si vous voulez insister sur le fait qu'il s'agit d'un vecteur ligne, utilisez $x^T$ qui signifie la transposée de $x$.

- $x_i$ signifie le $i$ème élément.

$$x=\left[\begin{array}{c}{x_{1}} \\ {x_{2}} \\ {\vdots} \\ {x_{n}}\end{array}\right]$$

- $a_{ij}$（$A_{ij}$, $A_{i,j}$ etc.）désigne l'élément se trouve à la ligne i et à la colonne j.

$$A=\left[\begin{array}{cccc}{a_{11}} & {a_{12}} & {\cdots} & {a_{1 n}} \\ {a_{21}} & {a_{22}} & {\cdots} & {a_{2 n}} \\ {\vdots} & {\vdots} & {\ddots} & {\vdots} \\ {a_{m 1}} & {a_{m 2}} & {\cdots} & {a_{m n}}\end{array}\right]$$

- $a^j$ ou $A_{:,j}$ signifie la colonne $j$：

$$A=\left[\begin{array}{llll}{ |} & { |} & {} & { |} \\ {a^{1}} & {a^{2}} & {\cdots} & {a^{n}} \\ { |} & { |} & {} & { |}\end{array}\right]$$

- $a^T_i$ ou encore $A_{i,:}$ signifie la ligne $i$.

$$A=\left[\begin{array}{c}{-a_{1}^{T}-} \\ {-a_{2}^{T}-} \\ {\vdots} \\ {-a_{m}^{T}-}\end{array}\right]$$

###  Les opérations

