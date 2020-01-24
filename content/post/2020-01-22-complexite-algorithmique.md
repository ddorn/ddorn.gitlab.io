---
title: La complexité algorithmique expliquée à mon petit frère
subtitle: C'est pas bien complexe et c'est sacrement pratique !
date: 2020-01-22
tags: ["complexité", "algo", "info"]
---

C'est le donc le tout premier post de... ma vie, et je vais essayer de
t'expliquer comment et pourquoi certains algorithmes sont meilleurs que d'autres
et pourquoi la notion de complexité et la notation de Landau sont si importantes.

<!--more-->

**Note à tous ceux qui liront ceci sans être mon petit frère** :
Ceci n'est pas une explication complète de ce qu'est la complexité
algorithmique, je me base principalement sur ses questions et je me dirige
seulement vers se qui l'intéresse (ou que je trouve fantastique). Ceci dit, si
quelque chose mérite une clarification je serais ravi de la rajouter afin
d'éclairer un plus grand nombre de personnes.


C'est parti !

Tout d'abord, tu sais déjà ce que c'est un algorithme. C'est une recette de cuisine
qui décrit comment, avec une certaine entrée (ingrédients) obtenir une certaine sortie
(gâteau). Pour les algorithmes comme les recettes, il y a deux choses qui sont importantes
a savoir :
 - si c'est effectif : ça fonctionne et produit une sortie correcte.
 - si c'est efficace : si ton algorithme est rapide ou pas.

Pour grader la métaphore de la recette de cuisine, si tu veux faire de la chantilly,
tu peux soit battre la crème avec un fouet électrique, soit avec un fouet tout court.
Dans les deux cas cette recette est effective (tu auras bien de la chantilly après) mais
la première est plus efficace que la deuxième.

### Mesurer l'efficacité

Savoir si un algorithme fonctionne est plutôt complexe et tout le domaine de la vérification
d'algorithmes existe pour cela, mais je ne m'y connais pas beaucoup. On va donc supposer que
tous nos algorithmes fonctionnent et on s'intéressera uniquement à leur efficacité.

#### Mais comment mesurer l'efficacité d'un algorithme ?

On pourrait juste l'implémenter et mesurer combien de temps il met, mais cela dépendrait de
beaucoup de facteurs, notamment l'ordinateur qui le fait tourner, le langage dans lequel il
est implémenté etc... Je reviendrai là dessus un peu plus tard pour montrer que ce n'est pas une
bonne option. Pour mesurer l'efficacité on va plutôt compter le nombre **d'opérations élémentaires**.
Une *opération élémentaire* est une lecture de variable, une écriture, une addition où une comparaison...
En fait on peut définir comme on veut ce que sont les opérations élémentaires, mais l'idée c'est
qu'elle doivent se faire rapidement, en un temps constant. Ce temps sera alors notre unité de mesure
de l'efficacité.

Voici un petit exemple pour se fixer les idées. C'est un code en python uniquement parce que c'est
proche du pseudo code et que tout le monde pourrait le comprendre (je pense). Cependant c'est
important de bien faire la différence entre un algorithme et son implémentation. Ici je donne
une implémentation en Python, qui sera différente de celle en C++ mais ce sera quand même le
même algorithme. Voici donc un algo pour calculer le maximum d'une liste non vide de nombres :

```python
def max(numbers):
    maximum = numbers[0]
    for number in numbers:
        if number > maximum:
            maximum = number
    return maximum
```

Si l'on essaye de compter le nombre d'opérations élémentaires, on remarque que sur chaque ligne
exactement une opération est faite : ce sont soit des affectations soit des comparaisons.
Cependant, si on dit que \\( n \\) est la taille de la liste `numbers`,
alors la ligne `for number in numbers` est exécutée \\( n + 1\\) fois,
une fois pour chaque nombre et une dernière fois quand on est arrivé au bout de la liste, afin
d'arrêter la boucle. De même, les lignes qui sont à l'intérieur de la boucle `for` sont
exécutées \\( n \\) fois.

Si on ajoute le nombre d'opérations en commentaire, cela donne:

```python
def max(numbers):
    maximum = numbers[0]        # 1 op
    for number in numbers:      # 1 op, n+1 fois
        if number > maximum:    # 1 op, n fois
            maximum = number    # 1 op, n fois
    return maximum              # 1 op
```

Ce qui nous fait un total de \\( 3n + 3 \\) opérations.
Pfiou, ça fait beaucoup pour pas grand chose, heureusement que notre algo était simple.

#### On a donc un moyen de mesurer l'efficacité d'un algo, mais comment les *comparer* ?

Supposons que mon algo pour trouver le maximum a \\( 3n+3 \\) opérations et que le tien
en a \\( 2n + 12 \\). Lequel est le plus rapide ? Avec un peu de maths, on peu voir
que quand \\( n < 9 \\) le mien est plus rapide, mais pour \\( n > 9 \\) c'est le tien.
C'est là qu'il faut remarquer quelque chose d'important :
trouver le maximum d'une liste avec moins de 9 éléments, c'est très rapide dans tous
les cas !

En fait, ce qui nous intéresse c'est savoir combien de temps va mettre l'algo
sur des **grosses** entrées, les *petites* sont instantanées de toute façon.
Ainsi si un algorithme fait \\( f(n) \\) étapes sur une entrée de taille \\( n \\)
ce qui nous intéresse c'est le **comportement asymptotique** de la fonction \\( f \\).

Le comportement asymptotique c'est un peu un gros mot, mais c'est juste la réponse
à la question « *Comment ma fonction se comporte-t-elle pour de grands nombres ?* ».
Ainsi on voit bien que lorsque \\( n \\) est grand, c'est pas le \\( +3 \\) ou le
\\( +12 \\) des fonctions d'avant qui va changer grand chose :
sur une liste de 10000 éléments, il y aurait 20013 vs. 30003 étapes.

De façon plus générale, quand ta complexité est un polynôme, seul le terme avec
la plus grande puissance est important, car il *grandit bien plus vite que les autres*.
Tu risques d'entendre assez souvent cette expression (grandir bien plus vite que)
et ça à l'air pas très rigoureux ni formel, et tu auras raison, mais on peut lui
donner un sens rigoureux.

On dit qu'une fonction \\( f \\) grandit bien plus vite qu'une fonction \\( g \\) si

$$
\lim_{n\to\infty} \frac{f(n)}{g(n)} = \infty
$$

C'est à dire que tu vas toujours pouvoir trouver un \\( n \\) assez grand pour que
la fonction \\( f \\) soit 2 fois, 1000 fois ou un milliard (...) de fois plus grande que
\\( g \\). On a donc que \\( n^2 \\) grandit bien plus vite que \\( 1000n \\) et que
\\( 2n \\) grandit bien plus vite que \\( 5 \\), qui lui ne grandit pas du tout.

Ainsi quand on a une fonction qui nous dit le nombre d'opérations élémentaires,
on ignorera tous les termes qui grandissent bien moins vite que les autres.

#### Quelques exemples

On garde ainsi juste le terme qui grandit le plus rapidement, c'est-à-dire le terme avec la
plus grande puissance lorsque c'est un polynôme où l'exponetielle avec la plus grande base
si il y en a. Ceci nous permet enfin de classer les fonctions asymptotiquement.
Voici quelques exemples dans un ordre croissant.

| Nombre d'opérations   | Ce qu'on retient  |
|----------------------:|:-----------------:|
| \\( 12 \\)            | \\( 12 \\)        |
| \\( 2\log(n)+9 \\)    | \\( 2\log(n) \\)  |
| \\( 3n+3 \\)          | \\( 3n \\)        |
| \\( 7n + \log(n) \\)  | \\( 7n \\)        |
| \\( n^2 + 6n - 4 \\)  | \\( n^2 \\)       |
| \\( 2^n +n^{12} +6 \\)| \\( 2^n \\)       |
| \\( n2^n +5^n + 6 \\) | \\( 5^n \\)       |


### La notation de Landau

Une dernière remarque nous permet de simplifier encore et nous permet d'arriver à
la notation de Landau pour la complexité temporelle d'un algorithme.

Si on reprend nos deux algorithmes `max` précédents, et que chacun fait tourner celui de
l'autre sur son ordi pour le tester, le mien finira bien plus tôt que le tien, car ton
ordinateur est bien plus puissant. Pourtant on avait dit avant que \\( 2n \\) était mieux
que \\( 3n \\). Ceci nous amène à une chose : oublier les facteurs constant, car il peuvent
facilement être compensés par d'autres facteurs comme le *hardware* où le langage d'implémentation.

Si on reprend la table d'avant,

| Nombre d'opérations   | Ce qu'on retient  |
|----------------------:|:-----------------:|
| \\( 12 \\)            | \\( \mathcal{O}(1) \\)   |
| \\( 2\log(n)+9 \\)    | \\( \mathcal{O}(\log(n)) \\)   |
| \\( 3n+3 \\)          | \\( \mathcal{O}(n) \\)        |
| \\( 7n + \log(n) \\)  | \\( \mathcal{O}(n) \\)        |
| \\( n^2 + 6n - 4 \\)  | \\( \mathcal{O}(n^2) \\)       |
| \\( 2^n +n^{12} +6 \\)| \\( \mathcal{O}(2^n) \\)       |
| \\( n2^n +5^n + 6 \\) | \\( \mathcal{O}(5^n) \\)       |

Et l'on note le *résultat* avec un \\( \mathcal{O}  \\) car c'est ce qu'on appelle
la **notation de Landau** ou **big-O notation** en anglais. Ce \\( \mathcal{O} \\)
dit justement que l'on a oublié tous les termes qui grandissent plus lentement
et les facteurs constants afin de garder seulement le comportement asymptotique.

Formellement soit deux fonctions \\( f \\) et \\( g \\), on dit que *« \\( f \\) est en
grand O de \\( g \\) »* et on note \\( f = \mathcal{O}(g)  \\) si

$$
\exists k>0, \exists n_0 \text{ tels que }  \forall n>n_0, \ f(n) \leq g(n)\cdot k
$$

C'est à dire que \\( f(n) \\) est, au bout d'un moment toujours plus petite que \\( k\cdot g(n) \\),
pour un certain \\( k > 0 \\).

Attention cependant, cette notation est un peu trompeuse car le \\( = \\) n'en est pas vraiment un
(c'est en réalité une [relation d'équivalence](https://fr.wikipedia.org/wiki/Relation_d%27%C3%A9quivalence).
On remarque que
$$ 3n + 3 = \mathcal{O}(n) \text{ et }  2n + 12 = \mathcal{O}(n)$$
mais
\\( 3n+3 \neq 2n+12 \\). Si c'était une égalité, comme deux choses sont égales à une même troisième,
elles devraient être égales entre elles, et ce n'est pas le cas.
Cependant, on a quand même que \\( 3n+3 = \mathcal{O}(2n+12)  \\).


#### Petite pause résumé

On a introduit la **notation de Landau** pour pouvoir parler de la **complexité temporelle** d'un
algorithme, c'est une mesure de son *efficacité*, le temps qu'il prend sur des **grandes entrées**.
On faisant cela on s'est rendu compte que l'on pouvait ignorer tous les petits termes et les
facteurs constants et donc *comparer* facilement la complexité des algorithmes.


### La complexité temporelle

Maintenant que l'on sait comment comparer des fonctions, on va s'intéresser
plus en détail à ce que l'on mesure exactement. Voici un algorithme qui dit
si un élément est présent dans une liste :

```python
def contient(liste, element):
    for el in liste:
        if el == element:
            return True
    return False
```

Comment compter le nombre d'opération élémentaires ici ? L'algorithme
s'arrête dès que l'élément est trouvé ou alors quand il a parcouru toute
la liste sans le trouver. Il ne fait donc pas toujours le même nombre
d'opérations. Quand on parle de complexité temporelle on parle en fait
de **complexité dans le pire des cas** car une des questions que l'on se pose
souvent c'est « *Quand va se finir mon algo ?* » avec une réponse :
« *au pire dans une heure* ».

Ainsi, dans le pire des cas, cet algo doit parcourir toute la liste de taille
\\( n \\) et est donc en \\( \mathcal{O}(n) \\). La complexité pire cas n'est
pas la seule notion intéressante, on peu aussi se poser la question de la
**complexité meilleur cas** ou la **complexité moyenne**.

Ici, le meilleur cas est si l'on trouve ce que l'on cherche à la première
comparaison, donc `contient` a une complexité meilleur cas en \\( \mathcal{O}(1) \\).

La complexité moyenne est plus difficile à calculer. Il faut en fait distinguer deux
cas :
 - L'élément n'est pas dans la liste, alors on doit toujours
    faire \\(\mathcal{O}( n )\\) opérations pour tout parcourir.
 - L'élément est dans la liste alors en moyenne il est au milieu et on doit
    faire \\(\mathcal{O}( n/2 )\\) opérations soit \\(\mathcal{O}( n )\\).

On a donc que la complexité moyenne est dans tous les cas \\(\mathcal{O}( n )\\).

#### Remarques sur les différentes complexités temporelles

En fait, la complexité meilleur cas n'est pas souvent utile, car on
peut souvent modifier un peu un algo pour améliorer la complexité
meilleur cas. Par exemple pour un algo de tri, on pourrait d'abord vérifier
si la liste est déjà triée et si oui ne rien faire. On aurait donc une complexité
meilleur cas en \\(\mathcal{O}( n )\\) mais cela ne nous dit pas grand chose
sur ce que notre algorithme fait quand on le fait trier une liste qui n'est
pas déjà triée, ce risque d'arriver souvent.

Une autre chose a remarquer est que la complexité moyenne est un outil très
approprié pour connaitre le temps d'exécution d'un algorithme, mais est souvent
bien plus difficile à trouver que la complexité pire cas.

De plus, si on fait seulement la moyenne du nombre d'opérations pour chaque entrée,
on considère que les entrées sont uniformément distribuées : elles ont toutes la
même probabilité d'exister. Cela marche très bien en théorie, mais en pratique
ce n'est pas forcement le cas. Si à un certain point on veut trier une liste
qui contient de la *real world data*, il y a une plus forte probabilité qu'elle
contienne des gros bouts déjà triés ou presque triés. Certains algorithmes prennent
cela en compte, comme le [TimSort](https://en.wikipedia.org/wiki/Timsort), qui est l'algorithme
de tri de Python.

Pour la complexité pire cas, une question importante à se poser est « *Quel est le
pire cas ?* », et bien que c'était évident dans l'exemple d'avant,
ça ne l'est pas toujours.

#### La complexité spatiale

De la même façon que l'on a défini la complexité temporelle on peut
définir la complexité spatiale, qui est une mesure de l'espace que
l'algorithme prend. Tu peux voir ça comme la quantité de RAM qu'il
utilise ou le nombre de variables. Les algorithmes que l'on a vu avant
avaient un nombre constant de variables, qui ne dépendent pas de
l'entrée, il étaient donc en \\(\mathcal{O}( 1 )\\). Cet algorithme
qui inverse une liste par exemple est en \\(\mathcal{O}( n )\\) car
il a besoin d'allouer une liste aussi grande que la liste d'entrée :

```python
def reverse(liste):
    # rev est une liste vide de taille n
    rev = [None] * len(liste)
    index = 0
    while index < len(liste):
        # On met l'element de l'autre coté de la liste
        rev[len(l) - index - 1] = liste[index]
        # puis on passe au suivant
        index += 1
    return rev
```

On a alors une complexité temporelle *et* spatiale en \\(\mathcal{O}( n )\\)
mais il pourrait en être différent, on peut par exemple faire un algorithme
qui inverse une liste *en place*, c'est-à-dire qu'il modifie la liste
elle-même au lieu d'en créer une autre :

```python
def reverse_in_place(liste);
    milieu = int((len(liste) + 1) / 2)
    for i in range(milieu):
        # On inverse le i-eme element en partant du début
        # et le i-eme en partant de la fin (d'indice -1 - i)
        liste[i], liste[-1-i] = liste[-1-i], liste[i]
        # Et on fait cela jusqu'a atteindre le milieu
```

La complexité spatiale nous permet ici voir une différence entre les deux
algorithmes, et si on veut inverser une très grosse liste et que c'est pas
grave qu'elle soit modifiée, il sera préférable de prendre le 2e algo, car
il n'a pas besoin de beaucoup de RAM supplémentaire : il a une complexité
spatiale de \\(\mathcal{O}( 1 )\\).

### La complexité algorithmique en pratique

Histoire de bien se fixer les idées voici quelques exemple qui t'aideront
probablement à mieux comprendre comment trouver la complexité en pratique
et ce quelle signifie.

Pour chacun je te conseille d'essayer de trouver par toi même la complexité
temporelle pire cas et la complexité spatiale avant de lire la
solution et mes commentaires.

#### Un petit piège pour commencer

Voici un programme qui affiche tous les nombres jusqu'à un million.
```python
def affiche1():
    for n in range(1000000):
        print(n)
```

Cet algorithme est en \\(\mathcal{O}( 1 )\\) car il prend toujours le même temps
pour s'exécuter. A chaque fois qu'il est appelé il fait un million de `print`
et la boucle `for` s'exécute 1000001 fois. Il est donc en \\(\mathcal{O}( 2000001 )\\)
mais ça n'est pas différent de \\(\mathcal{O}( 1 )\\), même si la constante est
très grande.


```python
def affiche2(n):
    for i in range(n*n):
        print(i)
```

Bien sûr, c'est différent ici et cet algo est en \\(\mathcal{O}( n^2 )\\).

#### Deux façons de calculer une factorielle
Voici un premier programme qui calcule \\( n \\) factoriel :

```python
def factoriel1(n):
    f = 1
    for i in range(1, n+1):
        f *= i
    return f
```

Ici on a une boucle simple qui s'exécute \\( n\\) fois, le reste étant en temps
constant, `factoriel1` est en \\(\mathcal{O}( n )\\).

Voici un autre algorithme pour calculer n factoriel, mais récursif cette fois.
Ici il est important de prendre en compte aussi le temps que met l'appel à
`factoriel2` dans la complexité.

```python
def factoriel2(n):
    if n <= 1:
        return 1
    return n * factoriel2(n - 1)
```

Cet algorithme fait un nombre constant d'opérations et en plus s'appelle lui-même.
Ainsi, a chaque appel récursif, il fait \\(\mathcal{O}( 1 )\\) opération et il
y a au total \\( n \\) appels a `factoriel2`. Cet algorithme est donc aussi en
\\(\mathcal{O}( n )\\). N'hésite pas à passer un peu de temps pour bien t'en convaincre.

La complexité spatiale pire cas est cependant plus complexe,
en effet, à chaque fois que `factoriel2` s'appelle lui même, cela ajoute un
appel de fonction sur le *stack* afin que lorsque `factoriel2(n-1)` à été calculé,
on puisse *remonter le stack* avec le `return`. Tu peux voir ça en te disant
que pendant qu'il calcule `factoriel2(n-1)` il faut qu'il se rappelle de multiplier
par \\( n \\) après, et il faut donc qu'il sauvegarde tous les \\( n \\).
On a donc une complexité spatiale en \\(\mathcal{O}( n )\\),
contrairement à avant où c'était \\(\mathcal{O}( 1 )\\)

Une bonne façon de trouver la complexité d'un algorithme récursif est de poser
\\( T(n) \\) le nombre d'opérations pour une entrée de taille \\( n \\) et de
poser la relation de récurrence pour \\( T(n) \\). Ici, ce serait

$$
T(n) = \begin{cases}
\mathcal{O}(1) & \text{si } n = 1 \\\\ T(n-1) + \mathcal{O}(1) & \text{si } n > 1
\end{cases}
$$

Et on peut enlever les grand O et résoudre cette relation de récurrence
comme on le ferait normalement. On obtient juste


$$
T(n) = \begin{cases}
1 & \text{si } n = 1 \\\\ T(n-1) + 1 & \text{si } n > 1
\end{cases}
$$

Ce qui se résout bien en \\( T(n) = n \\). Les deux méthodes donnent donc bien la même chose.
Il existe des méthodes générales qui permettent de résoudre une bonne partie de ces
relations de récurrence, notamment le *Master Theorem* mais je n'irai pas aussi loin donc
si tu veux en savoir plus, tu peux lire l'[article Wikipédia](https://fr.wikipedia.org/wiki/Master_theorem) dessus.

Une autre bonne façon des trouver la complexité est de faire un arbre des appels en notant
le nombre d'opérations sur chaque nœud et ensuite tout additionner pour trouver le nombre
d'opérations total. C'est une méthode fort sympatique mais je n'ai vraiment pas envie de
dessiner des arbres pour les inclure dans le post, désolé.

#### Les tris, meilleurs amis de la complexité

Voici un premier algorithme de tri : le *bubble sort*.
```python
def bubblesort(liste):
    n = len(liste)
    for i in range(n):
        for j in range(n - 1):
            # Si la paire en j, j+1 est dans le mauvais ordre
            if liste[j] > liste[j + 1]
                # On inverse liste[j] et liste[j + 1]
                liste[j], liste[j + 1] = liste[j + 1], liste[j]
    return liste
```

Tout d'abord on remarque qu'on utilise un nombre constant de variables (`i` et `j`),
on a donc une complexité spatiale en \\(\mathcal{O}( 1 )\\), en effet, cet algo
de tri est *en place* et modifie directement la liste.
Pour la complexité temporelle, on a du \\(\mathcal{O}( 1 )\\) à l'intérieur
des deux boucles, la boucle sur `j` est donc en \\(\mathcal{O}( n )\\) car elle
s'exécute \\( n - 1 \\) fois. Comme la boucle interne est répétée \\( n \\) fois,
le total est en \\(\mathcal{O}( n^2 )\\). On remarquera que la complexité pire cas,
meilleur cas ou moyenne est la même ici. En général, si il y a \\( k \\) boucles
les unes dans les autres qui s'exécutent toutes \\( \mathcal{O}(n) \\) fois, on aura
une complexité en \\(\mathcal{O}( n^k )\\).

Et voici un deuxième algorithme de tri : le *tri par insertion*. C'est celui que
la plupart des gens utilisent pour trier un jeu de cartes (on en prend une de plus
et on la met au bon endroit). Pour trouver la complexité temporelle, il va falloir
que tu te demandes quel est le pire cas ici, car car le nombre d'opérations n'est pas
toujours le même.

```python
def insertion_sort(liste):
    for i in range(1, len(liste) - 1):
        # On prend un nouvel element
        x = liste[i]

        # et on décale vers la droite tous les éléments plus grand que x
        j = i
        while j > 0 and liste[j - 1] > x:
            liste[j] = liste[j - 1]
            j -= 1

        # Finalement on insère x dans le trou
        liste[j] = x
```
Ce tri est aussi un tri *en place*, il modifie directement la liste.
Quel est le pire cas ? C'est quand la liste est triée dans le mauvais sens.
En effet, à chaque fois que l'on pioche une nouvelle carte, c'est la plus
petite de celles que l'on a dans la main, et on la compare alors avec toutes
les autres cartes avant de la mettre au début de la main/liste.

Pour trouver le nombre d'opérations, il faut trouver combien de fois la boucle
`while` s'exécute dans le pire cas, car le reste est juste en \\(\mathcal{O}( 1 )\\).
A chaque tour de boucle `for`, le `while` compare `x` avec la valeur en position
`i` puis `i-1` etc... Au final il compare donc `x` avec les `i` valeurs précédentes.
On a donc une comparaison puis deux, puis trois etc...
Avec un peu de maths (l'argument de Gauss) on peut trouver que

$$
1 + 2 + 3 + \cdots + (n - 1) = \sum_{i=1}^{n-1} i = \frac{n(n-1)}{2}
$$

La complexité temporelle pire cas et donc
$$ \mathcal{O}\left(\frac{n(n-1)}{2}\right) = \mathcal{O}(n(n-1)) = \mathcal{O}(n^2)  $$

Les deux algorithmes de tri ici ne sont pas très efficaces sur des grandes listes,
car les meilleurs tris sont en \\(\mathcal{O}( n\log n )\\), cependant le tri par insertion
est quand même très utilisé car il est très rapide sur des entrées de petites taille.
Une autre chose à remarquer est que sa complexité temporelle meilleure cas est \\(\mathcal{O}( n )\\).
Le meilleur cas est quand la liste est déjà triée, et alors chaque élément est ajouté directement
sans comparaison. L'intérieur de la boucle for est donc en \\(\mathcal{O}( 1 )\\)
et est exécutée \\( n \\) fois, ce qui nous donne le résultat.


#### Des algorithmes récursifs moins évidents

La recherche par dichotomie est un algorithme de recherche d'un élément dans une
liste déjà triée. C'est ce que tu utilises pour trouver un nombre quand je peux répondre
seulement « plus petit » ou « plus grand ».

Voici son code, qui prend en entrée une liste triée et un élément `x` à trouver

```python
def dicho(liste, x):
    if len(liste) == 1:
        # True si le seul élement est x
        return liste[0] == x

    milieu = len(liste) // 2
    if liste[milieu] > x:
        # x est dans la première moitié
        # liste[:milieu] est la la partie de la liste qui finit à milieu
        return dicho(liste[:milieu], x)
    else:
        # x est dans la deuxième moitié
        return dicho(liste[milieu:], x)
```

Il est pratique ici de poser la relation de récurrence comme pour les factorielles.
Ici on obtient :
$$
T(n) = \begin{cases}
\mathcal{O}(1) & \text{si } n = 1 \\\\ T(n / 2) + \mathcal{O}(1) & \text{si } n > 1
\end{cases}
$$

Car `dicho` s'appelle lui même avec une liste qui est deux fois plus petite à chaque fois
(que ce soit la première ou la deuxième moitié), jusqu'à ce qu'il y ait un seul élément
et alors il finit en \\(\mathcal{O}( 1 )\\). Un façon de résoudre cette relation est de
procéder par remplacement :

$$
\begin{aligned}
        T(n) &= T(n/2) + 1
\\\\        &= T(n/4) + 1 + 1
\\\\        &= T(n/8) + 1 + 1 + 1
\\\\        &= \cdots
\\\\        &= T(n/2^k) + k
\end{aligned}
$$

Au bout de \\( k \\) k appels récursifs on a donc \\( T(n/2^k) + k \\) opérations.
Il suffit donc de trouver quand est-ce que l'on arrive à une liste de taille 1,
c'est-à-dire pour quel \\( k \\) on a \\( n/2^k = 1 \\). Il y a donc
\\( k = \log_2(n) \\) appels récursifs ce qui nous donne

$$ T(n) = \mathcal{O}(\log n)  $$


Les nombres des Fibonacci sont définis par récurrence de façon très simple :

$$
F(n) =
\begin{cases}
    1 & \text{si } n \in \\{0, 1\\}
\\\\ F(n-1) + F(n-2) & \text{si } n \geq 2
\end{cases}
$$

Un algorithme pour les calculer est donc

```python
def fib(n):
    if n < 2:
        return 1
    return fib(n-1) + fib(n-2)
```

L'algorithme est simple mais pourtant très peu efficace. En effet, à chaque appel,
il y a deux appels à `fib`. Le nombre de d'appels double donc à chaque fois
que l'arbre d'appels augmente de profondeur. Ainsi `fib` est en \\(\mathcal{O}( 2^k )\\)
si \\( k \\) est la profondeur de l'arbre d'appels. L'arbre n'est pas équilibré car les branches
où il y a des appels à `fib(n-2)` se finissent plus tôt mais on peut quand même dire que :
 - Toutes les feuilles sont à une profondeur d'au moins \\( n/2 \\) donc `fib` est au moins en
     en \\(\mathcal{O}( 2^{n/2} )\\)
 - La profondeur maximale est \\( n \\) donc `fib` est au plus en \\(\mathcal{O}( 2^n )\\).

Dans les deux cas `fib` a une complexité temporelle et spatiale exponentielle ce que l'on cherche
généralement à éviter. On aurait bien sûr pu faire mieux mais c'est pas la question ;)

### Voir aussi

- Le problème [P = NP](https://fr.wikipedia.org/wiki/Probl%C3%A8me_P_%3D_NP)
    est un des sept problèmes du millénaire.
    C'est une question de classification
    des problèmes de décision (les questions qui se répondent par oui ou non)
    et notamment de savoir si les problèmes que l'on peut vérifier en temps
    polynomial sont résolubles en temps polynomial.
- Le [Master Theorem](https://fr.wikipedia.org/wiki/Master_theorem) qui permet de
    résoudre facilement des relations de récurrence qui apparaissent fréquemment
    dans les complexité algorithmiques.
- Les différents [tris](https://fr.wikipedia.org/wiki/Algorithme_de_tri)
    qui sont de très bon exemple pour comprendre les complexités temporelles
    et présentent de nombreuses facettes de l'algorithmique.


___
### Sources

- [Wikipédia - Time Complexity](https://en.wikipedia.org/wiki/Time_complexity) consulté le 23/01/2020.
- [Wikipédia - Comparaison asymptotique](https://fr.wikipedia.org/wiki/Comparaison_asymptotique) consulté le 23/01/2020.
- Mes cours d'ICC donnés par Jean-Cédric Chapelier en automne 2018 à l'EPFL
    ainsi que ceux d'*Algorithms* par Mikhail Kapralov en automne 2019.
