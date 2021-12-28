function detection_encodage(){
    encodage=$(curl -sIL $url | egrep charset | cut -d"=" -f2 | tr -d '\r' | tr '[a-z]' '[A-Z]');

    if [[ $encodage == "" ]]
    then
        encodage=$(cat $NOM_PAGES_ASPIREE | tr '/>' '\n'| egrep -m 1 'charset=' | cut -d"=" -f2 | tr -d '\r"' | tr '[a-z]' '[A-Z]')
    fi
    
    echo "encodage="$encodage



} 
            


function gestion_encodage(){

            #echo $encodage | hex

            
            

            if [[ $encodage == "UTF-8" ]]
               then
                    is_utf8=1;
                    echo "HTTP OK UTF8----------------------------------"
                  
                else
                    is_utf8=0;
                    echo "HTTP OK mais pas UTF8----------------------------------"



               fi

            
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