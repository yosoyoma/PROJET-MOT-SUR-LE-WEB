#!/bin/bash


REP=$1

FICHIER_HTML=$2


REP_PAGES_ASPIREES=../PAGES-ASPIREES


echo "<!DOCTYPE html>
<html>
   <head>
      <title>tableaux de liens</title>
   </head>
   <body>
      <p align=\"center\"><hr color=\"blue\" width=\"50%\"/></p>

" >$FICHIER_HTML

count_fichier=1

for fichier in `ls $REP`;
do 
   echo "<table align=\"center\" border=\"1\">
            <tr>
            <td colspan=\"2\" align=\"center\" bgcolor=\"black\"><font color=\"white\"><b>Tableau n° $count_fichier ( $fichier )</b></font></td>
         </tr>" >>$FICHIER_HTML

      #les lignes
   count_url=1
   while read url
   do
      
      NOM_PAGES_ASPIREE=$REP_PAGES_ASPIREES/$count_fichier"_"$count_url.html

      wget -O $NOM_PAGES_ASPIREE $url





      echo "<tr>
            <td align=\"center\" width=\"50\">$count_url</td>
            <td align=\"center\" width=\"100\"><a href=\"$url\">$url</a></td>
            <td><a href=\"$NOM_PAGES_ASPIREE\">PAGE ASPIREE</a></td>
         </tr> " >>$FICHIER_HTML


      count_url=$(($count_url+1))
   done < $REP/$fichier


   echo "</table>
      <p align=\"center\"><hr color=\"blue\" width=\"50%\"/></p>" >>$FICHIER_HTML

   count_fichier=$(($count_fichier+1))
done

      

echo "</body>
</html> " >>$FICHIER_HTML

exit 0