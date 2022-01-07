#!/bin/bash

function html_table_rows(){
  
    echo "
        <tr>
            <td align=\"center\">$CPT_URL</td>
            <td align=\"center\"><a href=\"$URL\">lien n°$CPT_URL</a></td>
            <td align=\"center\">$codeHTTP</td>"
            
    if [[ $NOM_FIC_PA != "" ]]
    then 
        echo "
            <td align=\"center\"><a href=\"$NOM_FIC_PA\">$CPT_TABLE"_"$CPT_URL</a></td>";
    else
        echo "
            <td align=\"center\">---</td>";
    fi
    
    if [[ $ENCODAGE != "" ]]
    then 
        echo "
            <td align=\"center\">$ENCODAGE</td>";
    else
        echo "
            <td align=\"center\">---</td>";
    fi

    if [[ $NOM_FIC_DT_UTF8 != "" ]]
    then 
        echo "
            <td align=\"center\"><a href=\"$NOM_FIC_DT_UTF8\">$CPT_TABLE"_"$CPT_URL</a></td>";
    else
        echo "
            <td align=\"center\">---</td>";
    fi

    if [[ $NOM_FIC_CT != "" ]]
    then 
        echo "
            <td align=\"center\"><a href=\"$NOM_FIC_CT\">$CPT_TABLE"_"$CPT_URL</a></td>";
    else
        echo "
            <td align=\"center\">---</td>";
    fi

   if [[ $COMPTEUR_MOTIFS != "" ]]
    then 
        echo "
            <td align=\"center\">$COMPTEUR_MOTIFS</td>";
    else
        echo "
            <td align=\"center\">---</td>";
    fi

   if [[ $NOM_FIC_FW != "" ]]
    then 
        echo "
            <td align=\"center\"><a href=\"$NOM_FIC_FW\">$CPT_TABLE"_"$CPT_URL</a></td>";
    else
        echo "
            <td align=\"center\">---</td>";
    fi

   if [[ $NOM_FIC_BG != "" ]]
    then 
        echo "
            <td align=\"center\"><a href=\"$NOM_FIC_BG\">$CPT_TABLE"_"$CPT_URL</a></td>";
    else
        echo "
            <td align=\"center\">---</td>";
    fi
    echo "    
         </tr> ";
}


function html_head(){
    echo "
    <!DOCTYPE HTML PUBLIC \"-//W3C//DTD HTML 4.01 Transitional//EN\" \"http://www.w3.org/TR/html4/loose.dtd\">
    <html>
   <head>
    <meta charset=\"utf-8\"/>
      <title>tableaux de liens</title>
      <style>
        body {
        font-family:Arial, Helvetica, sans-serif;;
        }
        h1 {
        font-size:26;
        color:#6495ed;
        }
        h2 {
        font-size:24;
        color:#6495ed;
        }
        h3 {
        font-size:22;
        color:#6495ed;
        }
        table {
        border:3px solid #0717ec;
        border-collapse:collapse;
        width:90%;
        margin:auto;
        }


        th {
        
        border:1px dotted #6495ed;
        padding:5px;
        background-color:#d4d4db;
        text-align: center;
        }
        td {
        
        font-size:90%;
        border:1px solid #6495ed;
        padding:5px;
        text-align:left;
        text-align: center;
        }
        caption {
        font-family:sans-serif;
        }
        </style>
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
    <table align=\"center\" border=\"5px\" bordercolor=blue>
    
        <tr>
            <th colspan=\"11\" align=\"center\" bgcolor=\"blue\">
                <b>Tableau n° $CPT_TABLE</b> <span>(Fichier: $FICHIER )</span>
            </th>
        </tr>
        <tr><th>N°</th><th>URL</th><th>CODE HTTP</th><th>PAGE ASPIREE</th><th>Encodage</th><th>DUMP-TEXT<br><span>(UTF-8)</span></th>
        <th>Contexte</th><th>Nombre<br>Motif</th><th>Index</th><th>Bigramme</th></tr>
        "
}

function html_table_close(){
    echo "
    </table>
    <p align=\"center\"><hr color=\"blue\" width=\"50%\"/></p>"
}
