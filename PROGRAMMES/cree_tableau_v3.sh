#!/bin/bash


REP=$1

FICHIER_HTML=$2


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
   count_ligne=1
   while read ligne
   do

      echo "<tr>
            <td align=\"center\" width=\"50\">$count_ligne</td>
            <td align=\"center\" width=\"100\"><a href=\"$ligne\">$ligne</a></td>
         </tr> " >>$FICHIER_HTML


      count_ligne=$(($count_ligne+1))
   done < $REP/$fichier


   echo "</table>
      <p align=\"center\"><hr color=\"blue\" width=\"50%\"/></p>" >>$FICHIER_HTML

   count_fichier=$(($count_fichier+1))
done

      

echo "</body>
</html> " >>$FICHIER_HTML

exit 0


         















echo "<!DOCTYPE html>
<html>
<meta charset=\"utf-8\"/>
     <head>
        <table border=\"2\" bordercolor=\"blue\">
        "> $CHEMIN_FICHIER_HTML



  
while read ligne  
do  
   echo "<tr><td>$ligne</td></tr>  ">> $CHEMIN_FICHIER_HTML
done < $CHEMIN_FICHIER_SOURCE



echo "
        </table>
     </head>
</html>" >> $CHEMIN_FICHIER_HTML