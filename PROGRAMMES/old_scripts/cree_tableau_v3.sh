#!/bin/bash

source fonctions_v3.sh

#répertoire des fichiers contenant des urls 
REP_URLS=$1

#chemin relatif du répertoire du tableau html
TABLEAU_HTML=../TABLEAUX/$2

#chemin relatif des pages aspirées
REP_PAGES_ASPIREES=../PAGES-ASPIREES

rm $REP_PAGES_ASPIREES/*.html

html_head >$TABLEAU_HTML

html_body >>$TABLEAU_HTML

#compteur des fichiers des urls
count_fichier_urls=1

for fichier_urls in `ls $REP_URLS`;
do 
   html_table >>$TABLEAU_HTML

   #compteur des urls
   count_url=1
   while read url
   do
      
      #le nom complet du fichier de l'url aspirée
      NOM_PAGES_ASPIREE=""
      encodage=""

      #téléchargement (aspiration) de l'url en cours
      codeHTTP=$(curl -sIL -w '%{http_code}\n' -o http_head $url);

      echo "codeHTTP:"$codeHTTP
      if [[ $codeHTTP == 200 ]]
			then 
            NOM_PAGES_ASPIREE=$REP_PAGES_ASPIREES/$count_fichier_urls"_"$count_url.html
            curl -L -o $NOM_PAGES_ASPIREE $url;   

            #détection de l'encodage    
            encodage=$(curl -sIL $url | egrep charset | cut -d"=" -f2 | tr -d '\r' | tr '[a-z]' '[A-Z]');
            gestion_encodage;

         


      fi

      html_table_rows >>$TABLEAU_HTML


      count_url=$(($count_url+1))

   done < $REP_URLS/$fichier_urls

   html_table_close >>$TABLEAU_HTML

   count_fichier_urls=$(($count_fichier_urls+1))
done
      

html_body_close >>$TABLEAU_HTML
html_close>>$TABLEAU_HTML

exit 0