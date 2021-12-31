#!/bin/bash
#-------------------------------------------------------
# pour lancer ce script:
# bash premierscript.sh <dossier URL> <dossier TABLEAUX>
#-------------------------------------------------------

source fonctions_v4.sh


encodage="EUC-zz"

gestion_encodage

exit 0


REP_PAGES_ASPIREES=../PAGES-ASPIREES

cptTableau=1
cptUrl=1

NOM_PAGES_ASPIREE=$REP_PAGES_ASPIREES/$cptTableau"_"$cptUrl.html


NOM_FICHIER_DUMP=../DUMP-TEXT/"utf8_"$cptTableau"_"$cptUrl".txt"


echo $NOM_PAGES_ASPIREE
LANG="ar_SA.UTF-8"

echo $LANG

lynx -dump -nolist -assume_charset="UTF-8" -display_charset="UTF-8" $NOM_PAGES_ASPIREE > $NOM_FICHIER_DUMP;


exit 0


motif="منع الحمل"


motif="منع|حمل"





egrep -C 2 -i "$motif" $NOM_FICHIER_DUMP

echo "fin"

exit 0


#---------------------------------------------------------
							# 2eme traitement : compter les occurrences du motif
							compteurMotif=$(egrep -o -i $motif ./DUMP-TEXT/"$compteur_tableau-$compteur".txt | wc -l);