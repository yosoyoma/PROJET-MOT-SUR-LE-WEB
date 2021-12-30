#!/bin/bash

COLUMNS=90



function logInfo(){
	DATE_LOG=$(date "+%Y-%m-%d %H:%M:%S")
	MSG="[ $DATE_LOG ] $@"
    echo "$MSG" 
}

function logSeparateur(){
        SEPARATEUR=$@
        for((idx=0;idx<120;idx++))
        do
                echo -ne "$SEPARATEUR"
        done
        echo "$SEPARATEUR" 
}

function startInfo(){
        logSeparateur
        logInfo "Demarrage $(basename $0)"
        usage
        logSeparateur
}

function endInfo(){
        logSeparateur
		exit 0
}

function toLog(){
        DATE_LOG=$(date "+%Y-%m-%d %H:%M:%S")
        MSG="[ $DATE_LOG ] $@ ..."
        echo -e "$MSG" 
        MSG_LENGTH=${#MSG}
}



function log_success(){
		
        DATE_LOG=$(date "+%Y-%m-%d %H:%M:%S")
        MSG="[ $DATE_LOG ] $@ ..."
		MSG_LENGTH=${#MSG}
		echo -ne $MSG 
        for((idx=$MSG_LENGTH;idx<90;idx++))
        do
                echo -ne " " 
        done

        echo -ne "\e[92m[ OK ]\e[0m" 
	echo
}

# function restore(){
	# TMP=$ETAPE
	# unset ETAPE
	# if [ "$TMP" != "" ]; then
		# echo "!!ERREUR!!"|tee -a $FILE_LOG
		# echo "!!BACKUP!!"|tee -a $FILE_LOG 
	        # if [ ${TMP} -eq 1 ]; then
                        # #command xxxxxx todo
                # fi
	# fi
# }

function log_failure(){
        DATE_LOG=$(date "+%Y-%m-%d %H:%M:%S")
        MSG="[ $DATE_LOG ] $@ ..."
		MSG_LENGTH=${#MSG}
		echo -ne $MSG 
        for((idx=$MSG_LENGTH;idx<90;idx++))
        do
                echo -ne " "
        done

        echo -ne "\e[91m[ KO ]\e[0m" 
	echo

	#logSeparateur
    #exit 3
}

function detection_encodage(){
    encodage=$(curl -sIL $url | egrep charset | cut -d"=" -f2 | tr -d '\r' | tr '[a-z]' '[A-Z]' | tail -n1);

    if [[ $encodage == "" ]]
    then
        encodage=$(egrep -oi -m 1 "<meta[^>]*charset ?= ?\"?[^\" ,]+\"?" $NOM_PAGES_ASPIREE | egrep -oi -m 1 "charset.+" | cut -f2 -d= | tr -d '\r"' | tr '[a-z]' '[A-Z]')
        #encodage=$(cat $NOM_PAGES_ASPIREE | tr '/>' '\n'| egrep -m 1 'charset=' | cut -d"=" -f2 | tr -d '\r"' | tr '[a-z]' '[A-Z]')
    fi
    
    log_success "Détection de l'encodage : charset=$encodage"



} 
            


function gestion_encodage(){

            #echo $encodage | hex

            if [[ $encodage == "UTF-8" ]]
               then
                    is_utf8=1;
                    logInfo "HTTP OK UTF8----------------------------------"
                  
                else
                    is_utf8=0;
                    logInfo "HTTP OK mais pas UTF8----------------------------------"



               fi

            
}


function html_table_rows(){

    
    echo "
        <tr>
            <td align=\"center\">$cptUrl</td>
            <td align=\"center\"><a href=\"$url\">lien n°$cptUrl</a></td>
            <td align=\"center\">$codeHTTP</td>"
            

    if [[ $NOM_PAGES_ASPIREE != "" ]]
    then 
        echo "
            <td align=\"center\"><a href=\"$NOM_PAGES_ASPIREE\">$cptTableau"_"$cptUrl</a></td>";
    else
        echo "
            <td align=\"center\">---</td>";
    fi
    
    
    if [[ $encodage != "" ]]
    then 
        echo "
            <td align=\"center\">$encodage</td>";
    else
        echo "
            <td align=\"center\">---</td>";
    fi
    echo "    
         </tr> ";


    
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
    <table align=\"center\" border=\"5px\" bordercolor=blue>
    
        <tr>
            <th colspan=\"11\" align=\"center\" bgcolor=\"blue\">
                <font color=\"white\"><b>Tableau n° $cptTableau</b> <span>(Fichier: $fichier )</span></font>
            </th>
        </tr>
        <tr><th>N°</th><th>URL</th><th>CODE HTTP</th><th>PAGE ASPIREE</th><th>Encodage</th><th>DUMP</th><th>DUMP-TEXT</th>
        <th>Contexte</th><th>Nombre Motif</th><th>Bigramme</th></tr>
        "
}

function html_table_close(){
    echo "
    </table>
    <p align=\"center\"><hr color=\"blue\" width=\"50%\"/></p>"
}
