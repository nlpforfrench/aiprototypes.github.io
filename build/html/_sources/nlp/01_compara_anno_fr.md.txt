# Comparer Spacy, StanfordNLP et TreeTagger sur un corpus oral et un corpus de presse 🇫🇷

[Xiaoou WANG](https://xiaoouwang.github.io), [Xingyu LIU](https://www.linkedin.com/in/xingyu-liu-aba896a1/)

## Motivation

L’annotation morphosyntaxique est une tâche consistant à assigner des informations grammaticales à chaque mot d’un
texte. Un tagger (ou étiqueteur) est typiquement couplé à un outil de segmentation en phrases et en mots et/ou à un
lemmatiseur.

Cette tâche est effectuée en amont des analyses textuelles plus poussées telles que l’analyse sentimentale et l’analyse
stylométrique et la qualité de ces dernières dépend considérablement du choix d’un bon étiqueteur morphosyntaxique.

Le but de ce rapport est d’évaluer la performance de 3 étiqueteurs morphosyntaxiques sur deux corpus issus du même
domaine (santé) mais de registres linguistiques bien distincts : l’un de nature journalistique et l’autre d’un niveau
plus familier.

Cette évaluation à deux facteurs (étiqueteur et corpus) est justifiée par les constats suivants :

1. Des difficultés ont été rapportées pour l’annotation des corpus de français non écrit (dans le sens du fond mais pas
   de la forme, un texte écrit peut très bien retranscrire une conversation orale). Pour le français oral par exemple
   des témoignages ont été nombreux (voir entre autres (Benzitoun et al., 2012; Eshkol-Taravella et al., 2011)) parce
   que le langage oral possède de nombreuses caractéristiques propres à son genre (hésitations, répétitions, reprises,
   incises, amorces de mot, etc…).

2. Quant à la comparaison d’étiqueteurs, il est souvent question de comparer les résultats au niveau de la précision (
   mesures de précision, rappel et F-mesure). Mais une vue plus globale sur les particularités de différents
   étiqueteurs : temps d’exécution, méthodes d’entraînement, possibilités de customisation est plus utile pour apprécier
   tant de facteurs contribuant à la décision finale d’un tel ou tel étiqueteur.

## Étiqueteurs/parseurs choisis

Les 3 étiqueteurs sont Treetagger (Schmid, 1994), Spacy (Explosion, 2017) et StanfordNLP, rebaptisé aujourd'hui en
Stanza (Qi et al., 2020).

## Constitution du corpus

Nous avons construit deux corpus en aspirant des textes de la rubrique santé
de `le monde`(https://www.lemonde.fr/sante/) et `doctissimo`(https://forum.doctissimo.fr/sante/). La documentation de ce
processus se trouve [ici](../web/01_lemonde).

100 articles journalistiques et 100 posts de forum ont été utilisés comme corpus de base.

## Analyses textuelles exploratoires

Pour confirmer le thème de notre corpus nous avons scrapé deux autres corpus ayant comme thème `sport` et `économie`。

Après avoir normalisé les textes voici les 10 mots les plus courants du corpus santé.

```{figure} 01_compara_annoimages/sante.png
:align: center
Graphe des 10 mots les plus fréquents du corpus de santé
```

Par contraintes d’espace nous n’allons pas afficher le même type de graphes pour le corpus de forum. Notez simplement
que les 3 mots les plus courants sont « médecin », « dos » et « lombago », ce qui tend à confirmer la validité de ce
corpus aussi.

Comme cette méthode ne permet pas d'avoir une vue plus globale de la spécificité du corpus, nous avons construit des
graphes de corrélation basés sur l'occurrence de mots dans les textes de chaque thème. Le graphe est assez facile à
interpréter : 1) plus un token s’approche de la ligne, plus la fréquence de ce premier est proche dans deux tableaux 2)
plus il y a de mots à proximité de la ligne, plus les deux tableaux contiennent les mêmes mots à fréquence semblable.

Le nombre considérable de mots de fréquence similaire entre le corpus santé séparé en deux montre encore une fois la
validité de l’hypothèse selon laquelle les articles de différents thèmes sont caractérisés par les mots non-vides les
plus fréquents.

```{figure} 01_compara_annoimages/correlation.png
:align: center
Graphe de corrélation pour 3 corpus de différents genres
```

## Échantillonnage des corpus et standardisation des étiquettes d'annotation

### Stratégie d’échantillonnage des deux corpus

Vu la quantité de textes et le manque de personnel il nous a paru impossible d’annoter tous les deux corpus. Il n’est
pas pour autant préférable d’annoter uniquement quelques articles ou quelques posts pour faire l’évaluation car
l’intérêt de l’aspiration se trouvera fortement diminué.

Nous avons décidé d’extraire un échantillon de chacun des deux corpus avec une méthode qui permettrait à cet échantillon
de représenter plus ou moins l’ensemble du corpus.

Par souci de concision, nous ne prenons uniquement le corpus de presse comme exemple pour démontrer la méthodologie.
L’échantillonnage a été effectué avec le même principe pour le corpus de forum.

Nous avons d’abord calculé la distribution des longueurs de mots de l’ensemble des phrases du corpus de presse. Les 4
quartiles de la distribution sont 16, 25, 36 et 115, à savoir que ¼ de phrases ont une longueur <= 16 et ainsi de suite.
La figure suivante illustre cette distribution :

```{figure} 01_compara_annoimages/distribution.png
:align: center
Distribution de longueurs de phrases du corpus de presse
```

Pour que ces quatre catégories de phrases soient également représentées, nous avons généré 60 nombres aléatoires par
catégorie pour extraire aléatoirement 60 phrases par catégorie.

À la fin de cette phase nous avons pu recenser 6798 mots pour le corpus de presse et 6094 pour le corpus de forum. Ces
deux échantillons constituent une bonne base pour garantir la comparabilité concernant l’annotation de ces deux types de
corpus.

### Standardisation des étiquettes

Si les deux taggers Spacy et StanfordNLP ont recours aux étiquettes de Universal Dependencies (
UD, [Nivre et al., 2016](https://universaldependencies.org/u/pos/all.html#al-u-pos/NUM)), Treetagger utilise des
étiquettes basées sur le jeu d’étiquettes de Penn
Treebank ([Marcus et al., 1993](https://www.cis.unimuenchen.de/~schmid/tools/TreeTagger/data/french-tagset.html)). Ces
deux systèmes ne sont pas entièrement convertibles. Par exemple l’étiquette « aux » n’existe pas dans Treetagger
français et de l’autre côté, l’étiquette « SYM » en UD n’a pas d’équivalent dans Treetagger.

Le cas le plus délicat est l’étiquette de « SCONJ » en UD qui recense des conjonctions de subordination telles que « que
», « si » et « quand », etc. alors que ces mots sont tous étiquetés en « PRO:REL » (pronoms relatifs) dans Treetagger.

Treetagger aussi propose une étiquette « ABR » (abréviation) qui est difficilement définissable, nous l’avons assimilé à
la catégorie « PROPN » (nom propre) en UD.

Le tableau suivant détaille notre choix pour convertir au maximum les étiquettes de Treetagger en UD.

```{figure} 01_compara_annoimages/e606f6f0.png
:align: center
```

```{figure} 01_compara_annoimages/8dba10bb.png
:align: center
Conversion des tags de TreeTagger en tags d'UD  
```

Une dernière question porte sur la lemmatisation. Treetagger parfois attribue une sous-étiquette @card@ à des chiffres.
Nous avons transformé systématiquement ce lemme en token original pour garantir la fiabilité des mesures ultérieures.

### Quelques problèmes mineurs

Il nous a paru utile de préciser ici quelques problèmes rencontrés durant la standardisation d’étiquettes pour permettre
une meilleure reproductibilité de codes :

1. Les trois points « … » s’étiquettent tantôt comme trois symboles tantôt comme un seul symbole. Nous avons standardisé
   la transcription en trois symboles pour à la fois rendre l’annotation plus comparable et éviter des problèmes
   d’encodage.

2. Spacy n’arrive pas à tokéniser ‘«’ et ‘»’. En plus de ne pas reconnaître cette ponctuation, il insère
   systématiquement une ligne vide après ces deux tokens. Cela rend les mesures de précision très difficiles et nous
   avons dû remplacer tous les guillemets français par les guillemets anglais dans les deux échantillons de corpus avant
   de les faire annoter automatiquement.

3. Les espaces insécables peuvent aussi causer des problèmes d’annotation. Nous les avons remplacés tous par des espaces
   normaux.

## Évaluation des taggers

### Présentation générale des taggers

Les taggers morphosyntaxiques sont nombreux sur le marché, ci-dessous une liste de quelques taggers pour le français
utilisés dans la littérature :

```{figure} 01_compara_annoimages/266bcab0.png
:align: center
Liste non exhaustive de différents taggers disponibles pour le français (https://github.com/clement-plancq/outils-corpus)
```

Le principe des taggers peut être fort simple. Un algorithme simpliste qui catégorise les mots connus dans le tag le
plus courant et les mots inconnus dans les noms propres peut atteindre une précision globale de 90% sur des données en
anglais (Charniak, 1997).

Cependant des difficultés considérables existent pour atteindre une précision plus élevée. Entre les principales
difficultés nous pouvons citer le fait curieux que la plupart des types formant le vocabulaire sont non ambigus qui ne
peuvent porter qu’une catégorie morphosyntaxique. Or, ces derniers sont les plus fréquents dans les textes.

```{figure} 01_compara_annoimages/e90103e4.png 
:align: center
Répartition des mots ambigus et non-ambigus dans deux corpus d’anglais (Jurafsky, 2000)
```

Différents types d’étiqueteurs existent.

Des étiqueteurs à bases de règles qui utilisent lexique (forme fléchie, POS, morpho, lemme) et de grammaires locales (
ex : Unitex). Ce type d’étiqueteurs ont notamment l’avantage d’avoir des règles explicites et modifiables aisément et
d’être facilement implémentables (automates finis). Mais l’écriture manuelle des règles est difficile et coûteux et
l’adaptation à de nouvelles données difficile, ce qui fait qu’ils ne sont plus très utilisés aujourd'hui.

Une autre famille d’étiqueteurs est basée sur des méthodes probabilistes, ce qui les rend très performants. Le comble,
c’est que ce genre de méthodes nécessite moins d’expertise par rapport aux étiqueteurs à bases de règles. Les chaînes de
Markov sont au cœur de la plupart des algorithmes utilisés et de nombreuses variantes sont possibles (entropie maximale,
SVM, CRF, etc.)

Cependant les taggers basés sur l’apprentissage statistique nécessitent un corpus de référence annoté. Ce type de
protocoles nécessitent un grand investissement de temps. De plus, il n’est pas toujours aisé d’analyser les erreurs.

### Spacy, TreeTagger et StanfordNLP

Les taggers morphosyntaxiques utilisés ici sont Spacy, TreeTagger et StanfordNLP (désormais appelé Stanza). Il est à
noter que le nom du dernier tagger peut prêter à confusion car il existe aussi un framework appelé Stanford CoreNLP (
Manning et al., 2014) qui est surtout connu pour sa performance sur des données en anglais et ses fonctions avancées
telles que résolution de coréférence. Nous verrons dans la suite de cette section que ce framework n’est pas adapté
notre projet et que le StanfordNLP utilisé dans ce rapport est bien le StanfordNLP en Python appelé aujourd'hui Stanza.

Tous ces trois taggers sont des taggers basés sur des méthodes probabilistes. Le cœur des algorithmes de ces taggers
repose sur des ngram utilisés pour modéliser la probabilité d’une séquence de mots taggués.

* TreeTagger repose également sur des ngram mais il utilise des arbres de décision binaires pour estimer les
  probabilités de transition entre les mots de la séquence (Schmid, 1994). C’est un modèle écrit en C et très utilisé
  pour le français car il est gratuit (mais propriétaire), rapide et propose de nombreux modèles. Cependant, on ne sait
  presque rien sur les données utilisées pour entraîner le modèle français. Les étiquettes de TreeTagger sont basées sur
  le tagset de Penn Treebank. Pour le modèle français, les fonctions tokénisation, lemmatisation, annotation
  morphosyntaxique et chunking sont proposées.

* Spacy est une librairie relativement jeune (2015). C’est une librairie polyvalente de Python qui dans le cas du
  français est équipée de tokéniseur, POS tagger, tagger de dépendance syntaxique, chunkeur, identifieur de NER etc…
  Spacy est entraîné sur UD French-Sequoia et WikiNER, ce qui fait qu’il serait moins performant sur les textes d’autres
  genres comme les posts de forum. Il est à noter que deux modèles existent pour le français, le modèle utilisé dans
  notre projet est le plus grand fr_core_news_md (84 Mb). L’un de ses grands atouts est sa « industry level speed ». •
  Stanford CoreNLP est un framework écrit en Java applicable à 6 langues. C’est un framework puissant qui propose des
  fonctions poussées comme l’analyse sentimentale. Cependant le modèle actuel pour le français n’a pas de lemmatisateur.

* Stanford CoreNLP est un framework écrit en Java applicable à 6 langues. C’est un framework puissant qui propose des
  fonctions poussées comme l’analyse sentimentale. Cependant le modèle actuel pour le français n’a pas de lemmatisateur.

```{figure} 01_compara_annoimages/597aa052.png
:align: center
Fonctionnalités disponibles de Stanford CoreNLP pour 6 langues
```

Enfin StanfordNLP est un framework de Python basé sur PyTorch et applicable à 66 langues à l’heure actuelle. C’est un
framework puissant et également un grand consommateur de capacités de calcul car il est basé sur des réseaux de
neurones.

```{figure} 01_compara_annoimages/f9aca8e1.png
:align: center
Caractéristiques techniques de StanfordNLP par rapport à d’autres frameworks en TAL (Qi et al., 2020)
```

### Évaluation sur le plan de la vitesse de traitement

Pour cette tâche nous avons construit un gros corpus de 568 000 mots en dupliquant simplement un corpus de base. Les
commandes utilisées pour évaluer les 4 taggers sont :

* Stanford CoreNLP

```bash
command time java-Xmx6g -cp "*" edu.stanford.nlp.pipeline.StanfordCoreNLP -props french.properties
```

* TreeTagger

```bash
command time tree-tagger-french testAnnotator.txt
```

* Spacy

```python
t0 = time()
nlp = spacy.load("fr_core_news_md", disable=["ner", "parser"])
nlp.max_length = 343000  # as long as > 1000000 and you don't run out of RAM
doc = nlp(text)
t1 = time()
```

* StanfordNLP (Stanza)

```python
t0 = time()
nlp = stanza.Pipeline(lang='fr', processors='tokenize,mwt,pos,lemma,depparse')
doc = nlp(text)
t1 = time()
```

Nous avons montré le code car la comparaison de vitesse est une tâche bien délicate. Sans spécifier la configuration on
peut parfois être littéralement ahuri par des évaluations fournies sur Internet. StanfordNLP fournit par exemple un
record de 4.51 millions de mots par seconde sur [leur page](https://nlp.stanford.edu/software/tokenizer.shtml) alors
qu’il s’agit simplement d’une tâche de tokénisation effectuée en plus par un tokéniseur par règles. Spacy paraîtrait
bien plus lent par rapport à cet exploit car il n’affiche que 13 963 mots par seconde
sur [sa page officielle](https://spacy.io/usage/facts-figures). Or il n’en est rien car Spacy tient compte aussi du
processus d’annotation de dépendance syntaxique. C’est pour dire combien il est important de préciser les paramètres
lorsqu'on parle de vitesse de traitement.

Dans notre cas, tous les 4 taggers (sauf Stanford CoreNLP) ont effectué une tâche de tokénisation + lemmatisation +
annotation morphosyntaxique. Le tableau suivant résume les résultats du test.

|       Framework      | Temps de traitement pour 568000 mots | Vitesses de traitement (mots par seconde) |
|:--------------------:|--------------------------------------|-------------------------------------------|
|      TreeTagger      | 71.97 secondes                       | 8000 m/s                                  |
|    StanfordCoreNLP   | 609.5 secondes                       | 568 m/s                                   |
|         Spacy        | 60 secondes                          | 9467 m/s                                  |
| StanfordNLP (Stanza) | 20 minutes                           | 473 m/s                                   |

Vitesse d'annotation de 4 taggers sur un corpus de 568000 mots

Pour mieux apprécier la validité de notre test, voici les caractéristiques techniques de notre ordinateur :

```{figure} 01_compara_annoimages/d18df612.png
:align: center
Configuration de l’ordinateur utilisé pour évaluer la vitesse d’annotation de 4 taggers
```

Nous voyons bien que Stanford NLP est le plus lent et Spacy le plus rapide. Cependant quelques remarques préliminaires
méritent d’être avancées ici. Tout d’abord Spacy est un modèle mettant l’accent sur la vitesse, comme fait remarquer
avec pertinence l’auteur de Stanford NLP dans son article (Qi et al., 2020). Nous verrons par la suite qu’au niveau de
la précision C’est Stanford NLP qui l’emporte. Ensuite Stanford NLP permet une accélération considérable si une carte
GPU est disponible. Nous n’avons pas pu faire un essai faute d’équipement. Cependant des entreprises peuvent très bien
avoir les moyens de s’en fournir, ce qui réduire l’écart de vitesse entre les deux frameworks.

TreeTagger s’est classé le deuxième. Cependant la vitesse de TreeTagger, comme nous le verrons plus tard, est obtenue au
prix d’une perte considérable de précision.

Enfin un dernier mot sur Stanford CoreNLP. La vitesse de traitement est lente. Elle sera d’autant plus lente si l’on
considère que la tâche de lemmatisation n’a pas été effectuée car indisponible pour le français (voir plus haut). De
plus il faut rappeler qu’ici nous avons utilisé le préfixe java -Xmx6g, à savoir que nous avons alloué 6g de mémoires au
programme pour la tâche en question. En effet nous avons fait plusieurs tests et il s’est avéré que 6g de mémoires est
un minimum pour que le programme puisse aboutir. Compte tenu de ces facteurs nous avons décidé d’examiner uniquement
StanfordNLP pour la suite de l’évaluation.

### Évaluation sur le plan de la précision

Dans les sous-sections qui suivent nous présentons notamment les mesures de précision, de rappel et le F-mesure tout en
sachant que dans des tâches d’annotation on met en avant la précision.

Les deux échantillons de corpus ont été annotés manuellement par nos soins, servant de « gold standard ».

Voici les premières lignes de notre gold standard du corpus de forum, notons l’annotation de « a » en adposition car il
s’agit ici d’une faute d’orthographe typique de ce genre de corpus :

Nous commençons par les tests sur le corpus de presse.

| Metric   |   col1 |   col2 |    f1 |
|:---------|-------:|-------:|------:|
| Tokens   |  99.87 |  99.82 | 99.84 |
| UPOS     |  97.15 |  97.1  | 97.12 |
| Lemmas   |  95.21 |  95.16 | 95.18 |

Tableau des mesures de précision de StanfordNLP sur le corpus de presse

Nous voyons que les résultats de StanfordNLP ont été plutôt satisfaisant sur le corpus de presse. Cela est plutôt
prédictible car il s’agit d’un corpus de français écrit relativement formel. Nous menons une discussion en détail dans
une sous-section dédiée spécialement à l’analyse des erreurs et nous nous contentons de donner des résultats en chiffres
dans cette sous-section.

Les résultats de Spacy sont moins bons que StanfordNLP mais assez satisfaisants :

| Metric   |   precision |   recall |    f1 |
|:---------|------------:|---------:|------:|
| Tokens   |       97.69 |    99.12 | 98.4  |
| UPOS     |       90.53 |    91.85 | 91.19 |
| Lemmas   |       87.77 |    89.05 | 88.41 |

Tableau des mesures de précision de Spacy sur le corpus de presse

Enfin, les résultats de TreeTagger sont les moins bons :

| Metric   |   precision |   recall |    f1 |
|:---------|------------:|---------:|------:|
| Tokens   |       93.71 |    89    | 91.29 |
| UPOS     |       83.72 |    79.52 | 81.57 |
| Lemmas   |       90.25 |    85.73 | 87.93 |

Tableau des mesures de précisions de TreeTagger sur le corpus de presse

Voici les résultats des tests sur le corpus de forum.

Nous commençons toujours par le tagger de StanfordNLP :

| Metric   |   precision |   recall |    f1 |
|:---------|------------:|---------:|------:|
| Tokens   |       92.5  |    91.34 | 91.92 |
| UPOS     |       90.75 |    91.59 | 91.17 |
| Lemmas   |       93.68 |    93.52 | 93.6  |

Tableau des mesures de précision de StanfordNLP sur le corpus de forum

Le tagger de Spacy :

| Metric   |   precision |   recall |    f1 |
|:---------|------------:|---------:|------:|
| Tokens   |       88.92 |    86.79 | 87.84 |
| UPOS     |       87.29 |    88.17 | 87.73 |
| Lemmas   |       86.56 |    87.43 | 86.99 |

Tableau des mesures de précison de Spacy sur le corpus de forum

Et enfin le tagger de TreeTagger, toujours le moins précis sur tous les plans :

| Metric   |   precision |   recall |    f1 |
|:---------|------------:|---------:|------:|
| Tokens   |       85.69 |    84.79 | 85.24 |
| UPOS     |       79.66 |    78.91 | 79.28 |
| Lemmas   |       79.83 |    79.08 | 79.45 |

Tableau des mesures de précision de TreeTagger sur le corpus de forum

## Discussions générales

Nous commençons par quelques remarques générales valables pour les deux types de corpus :

Sur les plans de la mesure de précision, de la mesure de rappel et de F-mesure :

* La performance des 3 taggers sur le corpus de presse a été systématiquement meilleur que sur le corpus de forum.
  L’écart en moyenne est 7.2% pour la mesure de précision, 5.6% pour la mesure de rappel et 6.3% pour F1-mesure.

* La performance de StanfordNLP a été systématiquement meilleure que les deux autres taggers sur les deux types de
  corpus, que ce soit pour la tokénisation, la lemmatisation et le POS tagging. Spacy se classe le deuxième et
  TreeTagger le dernier. L’écart moyen pour les trois tâches est 3.4% (versus Spacy) et 3.6% (versus TreeTagger) pour la
  mesure de précision sur le corpus de presse et 5.4% et 10.3% respectivement sur le corpus de forum.

Pour approfondir l’analyse, nous donnons ici une typologie des erreurs et le comportement des 3 taggers face à
différentes erreurs :

* Les 3 taggers ont été relativement précis sur le corpus de presse. Les principales sources d’erreurs viennent de
  l’annotation des noms propres. Lorsque ces derniers ne commencent pas par une lettre capitale, tous les 3 taggers ont
  pêché, et ce même pour des noms propres très courants tels que France.

* Pour le corpus de forum, les principales erreurs proviennent des « fautes d’orthographes ». Cette catégorie de formes
  comprend : o des mots réellement mal épelés (aprés, çà), mais des fautes comme « je regardes », « je vais lacher (qui
  aurait dû être lâcher) » sont bien tolérées au niveau du POS Tagging car il s’agit toujours d’un verbe. Mais la
  lemmatisation reste incorrecte. TreeTagger est le tagger supportant le moins d’erreurs d’orthographes car elles ont
  été systématiquement classées comme X (unknown), entraînant une chute de performance.

StanfordNLP gère le mieux au niveau les fautes. Il arrive même à restaurer la bonne forme pour des erreurs comme « ca »
pour « ça ». Il arrive aussi à classer « trés » comme adverbe en se basant sur la distribution des ngrammes.

Spacy se situe entre les deux. Mais il est décidément meilleur que TreeTagger.

* Les points où aucun tagger se démarque des autres

Des mots distincts soudés (ilya ; moi,cela ; Bonjourje ; 20euros). Aucun tagger n’est capable de restituer les formes et
faire une tokénisation correcte.

Des mots « propres » au langage du forum et dans une moindre mesure au langage familier (@+, + ou -, mm pour même,
ptite, merciiiiiiiiiiiiii, rha alala). Aucun tagger n’est capable de faire une annotation correcte.

Des Interjections propres au forum ( ;-) ). Aucun tagger n’est capable de traiter ce genre de tokens.

* TreeTagger ne gère pas les symboles. « g », « € » sont systématiquement annotés comme X. Stanford NLP gère le mieux.

* TreeTagger ne gère pas non plus les formes raccourcis (kiné). Encore une fois StanfordNLP est le meilleur concernant
  l’annotation de ce genre de tokens.

Enfin il nous a paru bon de préciser la belle performance de StanfordNLP et de Spacy sur les noms propres. La plupart
des noms propres ont été bien taggués quand ils commencent par une lettre en majuscule, que cela soit des noms de
médicament (Levothyrox, Kétoprofène) ; des noms de virus (VHC, Zika, Ebola) ; ou encore des noms de maladie (SGB, SCT).

StanfordNLP « reconnaît » même des parties de corps (prothèse discale en L4-L5) ou des types de voitures « 4x4 ».
Cependant la prudence est de mise car il peut simplement s’agit d’une différence de stratégie concernant les règles de
catégorisation de POS Tag et non pas d’une différence modèle d’apprentissage statistique.

Par contre sur ce point la performance de TreeTagger a été médiocre. Dès qu’un nom non courant commence une lettre
majuscule il est classé comme X.

Enfin, nous proposons deux tableaux récapitulant les caractéristiques principales de ces 3 taggers.

|    Tagger   | Vitesse d'annotation |
|:-----------:|----------------------|
|  TreeTagger | Très rapide          |
|    Spacy    | Rapide               |
| StanfordNLP | Moyen                |

Tableau récapitulant la vitesse d'annotation des Taggers

|    Tagger   | Problèmes                                                                         | Performance                                                    |
|:-----------:|-----------------------------------------------------------------------------------|----------------------------------------------------------------|
|  TreeTagger | Fautes d'orthographe<br><br>Mots liés<br><br>Noms propres<br><br>Langage du forum | Mauvais<br><br>Mauvais<br><br>Mauvais<br><br>Mauvais           |
|    Spacy    | Fautes d'orthographe<br><br>Mots liés<br><br>Noms propres<br><br>Langage du forum | Moyen<br><br>Mauvais<br><br>Bon<br><br>Mauvais                 |
| StanfordNLP | Fautes d'orthographe<br><br>Mots liés<br><br>Noms propres<br><br>Langage du forum | Bonne tolérance<br><br>Mauvais<br><br>Excellent<br><br>Mauvais |

Tableau récapitulant les différences de performance des Taggers face aux problèmes du corpus de forum

Pour conclure ce rapport, nous voudrions simuler un scénario où nous agissons en tant que conseiller informatique en
TAL :

1. Si le texte à annoter est du français formel, utilisez plutôt TreeTagger car il est ultrarapide. Cependant il peut
   être nécessaire d’ajouter quelques règles sur la catégorisation des noms non communs commençant par une lettre
   majuscule.

2. Si le texte à annoter est du français familier, utilisez plutôt Spacy car il est relativement rapide et gère
   relativement bien un français non standard relativement bien transcrit.

3. Si le texte est parsemé abondamment de fautes d’orthographes, optez pour StanfordNLP, c’est le framework qui supporte
   mieux ce type d’erreurs. Cela est vrai surtout lorsque votre backend est équipé de bons matériels (GPU de grandes
   capacités de calcul)

4. Si le texte contient beaucoup d’éléments propres à un niveau de langage (comme c’est le cas de notre étude sur le
   français du forum). Entraîner vos propres modèles car peu de modèles sur le marché est prêt à utiliser face à ce
   genre de tâches.

Quelques manques de ce rapport :

1. Faute de temps nous n’avons pu transcrire qu’une partie de notre corpus aspiré. Bien que nous ayons procédé à un
   échantillonnage basé sur les caractéristiques distributionnelles des corpus, la taille du corpus de référence n’est
   pas encore satisfaisante.

2. L’analyse des erreurs reste qualitative. Il est de plus préférable de pouvoir classer les erreurs par POS Tag.

3. La critique est aisée, l’art est difficile. Il serait intéressant d’essayer d’entraîner de nouveaux modèles pour
   pallier manque d’outils adéquats en vue de la transcription des corpus de forum. Comme nous avons vu dans le rapport,
   ce type de corpus recèle des particularités comparables ni au français formel, ni au français oral.

## Notes supplémentaires

Les difficultés des parseurs actuels proviennent principalement du fait que la plupart des étiqueteurs ont été entraînés
sur des données utilisant un français relativement soutenu. A titre d’exemples, French Treebank (Abeillé et al., 2003) a
été construit sur un corpus tiré de « le monde ». Sequoia Treebank quant à lui a été construit sur un mélange de textes
journalistiques et de textes de Wikipedia (Candito & Seddah, 2012).

## Références

Abeillé, A., Clément, L., & Toussenel, F. (2003). Building a treebank for French. In Treebanks (pp. 165–187). Springer.

Benzitoun, C., Fort, K., & Sagot, B. (2012). TCOF-POS: Un corpus libre de français parlé annoté en morphosyntaxe.

Candito, M., & Seddah, D. (2012). Le corpus Sequoia: Annotation syntaxique et exploitation pour l’adaptation d’analyseur
par pont lexical.

Charniak, E. (1997). Statistical techniques for natural language parsing. AI Magazine, 18(4), 33–33.

Eshkol-Taravella, I., Baude, O., Maurel, D., Hriba, L., Dugua, C., & Tellier, I. (2011).

Un grand corpus oral «disponible»: Le corpus d’Orléans 1 1968-2012.

Explosion, A. I. (2017). SpaCy-Industrial-strength Natural Language Processing in Python. URL: Https://Spacy. Io.

Jurafsky, D. (2000). Speech & language processing. Pearson Education India.

Kahane, S., Deulofeu, H.-J., Gerdes, K., Valli, A., & Nasr, A. (2018). Guide d’annotation syntaxique Orféo (version
Platinum).

Lebart, L., & Salem, A. (1988). Analyse statistique des données textuelles: Questions ouvertes et lexicométrie. Dunod
Paris. Manning, C. D., Surdeanu, M., Bauer, J., Finkel, J. R., Bethard, S., & McClosky, D. (2014). The Stanford CoreNLP
natural language processing toolkit. Proceedings of 52nd Annual Meeting of the Association for Computational
Linguistics: System Demonstrations, 55–60.

Marcus, M., Santorini, B., & Marcinkiewicz, M. A. (1993). Building a large annotated corpus of English: The Penn
Treebank.

Mitchell, R. (2018). Web scraping with Python: Collecting more data from the modern web. O’Reilly Media, Inc.

Nivre, J., De Marneffe, M.-C., Ginter, F., Goldberg, Y., Hajic, J., Manning, C. D., McDonald, R., Petrov, S., Pyysalo,
S., & Silveira, N. (2016). Universal dependencies v1: A multilingual treebank collection. Proceedings of the Tenth
International Conference on Language Resources and Evaluation (LREC’16), 1659–1666.

Qi, P., Zhang, Y., Zhang, Y., Bolton, J., & Manning, C. D. (2020). Stanza: A Python Natural Language Processing Toolkit
for Many Human Languages. ArXiv Preprint ArXiv:2003.07082.

Schmid, H. (1994). TreeTagger-a language independent part-of-speech tagger.