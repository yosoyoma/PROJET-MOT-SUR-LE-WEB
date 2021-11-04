#!/bin/bash


CHEMIN_FICHIER_SOURCE=$1

CHEMIN_FICHIER_HTML=$2

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