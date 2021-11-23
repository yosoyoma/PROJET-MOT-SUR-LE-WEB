#!/bin/bash

#répertoire des fichiers contenant des urls 
REP_URLS=$1

#chemin relatif du répertoire du tableau html
TABLEAU_HTML=../TABLEAUX/$2

#chemin relatif des pages aspirées
REP_PAGES_ASPIREES=../PAGES-ASPIREES

echo "<!DOCTYPE html>
<html>
   <head>
      <title>tableaux de liens</title>
   </head>
   <body>
      <p align=\"center\"><hr color=\"blue\" width=\"50%\"/></p>

" >$TABLEAU_HTML

#compteur des fichiers des urls
count_fichier_urls=1

for fichier_urls in `ls $REP_URLS`;
do 
   echo "<table align=\"center\" border=\"1\">
            <tr>
            <td colspan=\"2\" align=\"center\" bgcolor=\"black\">
               <font color=\"white\"><b>Tableau n° $count_fichier_urls ( $fichier_urls )</b></font>
            </td>
         </tr>" >>$TABLEAU_HTML

   #compteur des urls
   count_url=1
   while read url
   do
      
      #le nom complet du fichier de l'url aspirée
      NOM_PAGES_ASPIREE=$REP_PAGES_ASPIREES/$count_fichier_urls"_"$count_url.html

      #téléchargement (aspiration) de l'url en cours
      wget -O $NOM_PAGES_ASPIREE $url

      echo "<tr>
            <td align=\"center\" width=\"50\">$count_url</td>
            <td align=\"center\" width=\"100\"><a href=\"$url\">$url</a></td>
            <td><a href=\"$NOM_PAGES_ASPIREE\">PAGE ASPIREE</a></td>
         </tr> " >>$TABLEAU_HTML


      count_url=$(($count_url+1))

   done < $REP_URLS/$fichier_urls

   echo "</table>
      <p align=\"center\"><hr color=\"blue\" width=\"50%\"/></p>" >>$TABLEAU_HTML

   count_fichier_urls=$(($count_fichier_urls+1))
done
      

echo "</body>
</html> " >>$TABLEAU_HTML

exit 0