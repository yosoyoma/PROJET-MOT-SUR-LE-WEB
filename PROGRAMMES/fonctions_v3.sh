
function gestion_encodage(){



            #echo $encodage | hex

            echo "****************************************************"

            echo "DD"$encodage"FF";

            if [[ $encodage == "UTF-8" ]]
               then
                  echo "OK";

               else
      
                  echo "KO: $NOM_PAGES_ASPIREE";

               fi

            echo "****************************************************"
}


function html_table_rows(){

    
    rows="
        <tr>
            <td align=\"center\">$count_url</td>
            <td><a href=\"$url\">lien n°$count_url</a></td>
            <td align=\"center\">$codeHTTP</td>"
            

    if [[ $NOM_PAGES_ASPIREE != "" ]]
    then 
        rows=$rows"
            <td><a href=\"$NOM_PAGES_ASPIREE\">PA°$count_fichier_urls"_"$count_url</a></td>";
    else
        rows=$rows"
            <td>---</td>";
    fi
    
    
    if [[ $encodage != "" ]]
    then 
        rows=$rows"
            <td>$encodage</td>";
    else
        rows=$rows"
            <td>---</td>";
    fi
    rows=$rows"    
         </tr> ";


    echo $rows
}


function html_head(){
    echo "
<!DOCTYPE html>
<html>
   <head>
    <meta charset="utf-8"/>
      <title>tableaux de liens</title>
   </head>
" 
}

function html_close(){
    echo "
</html>
" 
}



function html_body(){
    echo "
   <body>
    <p align=\"center\"><hr color=\"blue\" width=\"50%\"/></p>" 
}

function html_body_close(){
    echo "
   </body>
   "

}

function html_table(){
    
    echo "
    <table align=\"center\" border=\"1px\" bordercolor=blue>
    
        <tr>
            <th colspan=\"2\" align=\"center\" bgcolor=\"black\">
                <font color=\"white\"><b>Tableau n° $count_fichier_urls ( $fichier_urls )</b></font>
            </th>
        </tr>
        <tr><th>N°</th><th>URL</th><th>CODE HTTP</th><th>PAGE ASPIREE</th><th>Encodage</th></tr>
        "
}

function html_table_close(){
    echo "
    </table>
    <p align=\"center\"><hr color=\"blue\" width=\"50%\"/></p>"
}