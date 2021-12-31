#!/bin/bash
#-------------------------------------------------------
# pour lancer ce script:
# bash premierscript.sh <dossier URL> <dossier TABLEAUX>
#-------------------------------------------------------


source fonctions_v4.sh

#répertoire des fichiers contenant des urls 
REP_URLS=$1

#chemin relatif du répertoire du tableau html
TABLEAU_HTML=$2"index.html"

# todo: valider les arguments (ou arrêter le programme)
# il ne faut pas que les 2 variables suivantes soient "vides"
# ET il faut qu'elles contiennent des chaines de caractères correspondant
# à des noms de dossiers (i.e tester l'existence de ces dossier)

#chemin relatif des pages aspirées
REP_PAGES_ASPIREES=../PAGES-ASPIREES

rm $REP_PAGES_ASPIREES/*.html

#-------------------------------------------------------
# en-tête du fichier html
html_head >$TABLEAU_HTML

html_body >>$TABLEAU_HTML
#-------------------------------------------------------

# pour chaque élément contenu dans DOSSIER_URL
#compteur des fichiers des urls
# on compte les tableaux
cptTableau=0
for fichier in `ls $REP_URLS`;
do 
   logSeparateur "="
   # on compte les tableaux
	cptTableau=$(($cptTableau + 1)) ;

   # Début de tableau
   html_table >>$TABLEAU_HTML

   
   cptUrl=0


   logInfo "Traitement du fichier n°$cptTableau : "$fichier
   logInfo "        "
   while read url
   do
      logSeparateur "-"

      #compteur des urls
      cptUrl=$(($cptUrl+1))
      
      logInfo "URL n°$cptUrl :${url:0:100}"
      
      #le nom complet du fichier de l'url aspirée
      NOM_PAGES_ASPIREE=""
      encodage=""

      #vérification du code status http 
      codeHTTP=$(curl -sIL -m 15 -w '%{http_code}\n' -o http_head $url | tr -d '\r\n');

      
      if [[ $codeHTTP == 200 ]]
			then 
            log_success "Contrôle URL (HTTP CODE $codeHTTP)"
            NOM_PAGES_ASPIREE=$REP_PAGES_ASPIREES/$cptTableau"_"$cptUrl.html


            #téléchargement (aspiration) de l'url en cours
            curl -sL -m 10 -o $NOM_PAGES_ASPIREE $url && log_success "Téléchargement de la page"

            #détection de l'encodage    
            detection_encodage;

            #gestion 

            # si encodage = UTF8 alors on fait certains traitements
				# sinon il faudra aussi les faire et probablement d'autres
            gestion_encodage;

            #

         else
            log_failure "Contrôle URL (HTTP CODE $codeHTTP)"

      fi

      # construire les lignes du tableau
      html_table_rows >>$TABLEAU_HTML

   logInfo "     "

   done < $REP_URLS/$fichier

   
   # Fin du tableau (et de la lecture du fichier)
   html_table_close >>$TABLEAU_HTML

   
done
      

html_body_close >>$TABLEAU_HTML
html_close>>$TABLEAU_HTML

exit 0