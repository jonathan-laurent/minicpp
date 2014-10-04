## Conventions d'appel pour MiniC++

Dans la mesure où $sp ne bouge pas en dehors des appels à alloc-frame
et delete-frame, l'utilisation de $fp devient superflue :
ce registre est recyclé en registre temporaire

/!\ La fonction appelante doit donc écrire légèrement en dessous
de $sp ($ra et les arguments à partir du cinquième)


# Cadre de pile

-------------
    $ra        stack(0)
------------- 
    arg5
    arg6   
-------------
   locals     
-------------

# Appelant à l'entrée :

$ra est placé en $sp - 4
Les arguments à partir du cinquième dans $sp - 8, ...  
les 4 premiers arguments sont placés dans $a0, ..., $a3
jal proc_id

# Appelé à l'entrée :

Allocation du cadre de pile (alloc-frame)
Sauvegarde des registres calle-saved ($si)
Transfert des registres $a0, ..., $a3
Déplacement des arguments passés par registres 
  [devant être stockés sur la pile

# Appelé à la sortie :

Restauration des calle-saved
Désallocation du cadre de pile (delete-frame)
jr $ra

# Appelant à la sortie

Restauration de $ra$
