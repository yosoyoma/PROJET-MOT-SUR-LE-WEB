#!/bin/bash

COLUMNS=90

REP_LOG=.
error=0

function check_error(){
    echo $(cat $REP_LOG/command.log | wc -l)

    touch $REP_LOG/command.log

    #echo $error
}

function logInfo(){
	DATE_LOG=$(date "+%Y-%m-%d %H:%M:%S")
	MSG="[ $DATE_LOG ] $@"
    echo "$MSG" 
}

function logSeparateur(){
        SEPARATEUR=$@
        for((idx=0;idx<150;idx++))
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

    if [[ $NOM_FIC_PA != "" ]]
    then
        ENCODAGE=$(curl -sIL $URL | egrep charset | cut -d"=" -f2 | tr -d '\r' | tr '[a-z]' '[A-Z]' | tail -n1);
        
        CHECK_ENCODAGE=0

        if [[ $ENCODAGE == "" ]]
        then
            ENCODAGE=$(egrep -oi -m 1 "<meta[^>]*charset ?= ?\"?[^\" ,]+\"?" $NOM_FIC_PA | egrep -oi -m 1 "charset.+" \
            | cut -f2 -d= | tr -d '\r"' | tr '[a-z]' '[A-Z]')
            #encodage=$(cat $NOM_FIC_PA | tr '/>' '\n'| egrep -m 1 'charset=' | cut -d"=" -f2 | tr -d '\r"' | tr '[a-z]' '[A-Z]')
        fi

        #encodage=""

        if [[ $ENCODAGE == "UTF-8" ]]
        then
            CHECK_ENCODAGE=1;
            NOM_FIC_PA_UTF8=$NOM_FIC_PA;
        fi

        if [[ $ENCODAGE != "" ]] 
        then
            log_success "Détection de l'encodage : charset=$ENCODAGE" 
        else
            log_failure "Détection de l'encodage"
            CHECK_ENCODAGE=-1
        fi
    fi
} 
            
function gestion_encodage(){
    #echo $encodage | hex
    #logInfo "check_encodage:$CHECK_ENCODAGE"

    if [[ $CHECK_ENCODAGE == 0 ]]
    then
        #logInfo "-----Gestion d'encodage-----"
        
        if [[ $(iconv -l | grep $ENCODAGE) == "" ]]
        then
            log_failure "L'encodage '$ENCODAGE' non supporté";
        else
            NOM_FIC_PA_UTF8=$(echo $NOM_FIC_PA | sed "s/.html/_UTF8.html/g") 
            CHECK_ENCODAGE=1

            #echo "NOM_FIC_PA=$NOM_FIC_PA"
            #echo "NOM_FIC_PA_UTF8=$NOM_FIC_PA_UTF8"

            iconv --from $ENCODAGE --to UTF-8 $NOM_FIC_PA >$NOM_FIC_PA_UTF8 2>$REP_LOG/command.log\
                                && log_success "conversion UTF-8" || log_failure "conversion UTF-8"`cat $REP_LOG/command.log`;

            [[ $(check_error) == 0 ]] || CHECK_ENCODAGE=-1
            #touche $REP_LOG/command.log
        fi

        #logInfo "----------------------------"
    fi

    #logInfo $NOM_FIC_PA_UTF8
    #logInfo $NOM_FIC_PA
            
}


function dump_text(){

    if [[ $CHECK_ENCODAGE == 1 ]] && [[ $NOM_FIC_PA_UTF8 != "" ]]
    then
        #logInfo "--------Dump to Text--------"

        NOM_FIC_DT=$REP_DT"/utf8_"$CPT_TABLE"_"$CPT_URL.txt

        #echo "NOM_FIC_PA_UTF8=$NOM_FIC_PA_UTF8"


        #dumper le contenu de la page aspirée
        lynx -dump -nolist -assume_charset="$ENCODAGE" -display_charset="UTF-8" $NOM_FIC_PA > $NOM_FIC_DT 2>$REP_LOG/command.log \
        && log_success "dumper le contenu de la page" || log_failure "lynx Error:"`cat $REP_LOG/command.log`;

        [[ $(check_error) == 0 ]] || NOM_FIC_DT=""

        #touche $REP_LOG/command.log
        
        #logInfo "----------------------------"
    fi
}


function extraire_contextes(){

    if [[ $NOM_FIC_DT != "" ]]
    then
        #logInfo "--------Dump to Text--------"

        NOM_FIC_CT=$REP_CT"/utf8_"$CPT_TABLE"_"$CPT_URL.txt

        #dumper le contenu de la page aspirée
                    # 3ème traitement : extraire des contextes réduits au motif (1 ligne avant et 1 ligne après)
				# 2 méthodes : egrep + mingrep
				# 1. construire des morceaux de corpus
		egrep -C 2 -i "$MOTIFS" $NOM_FIC_DT > $NOM_FIC_CT 2>$REP_LOG/command.log \
        && log_success "Extraction contextes" || log_failure "Extraction contextes Error:"`cat $REP_LOG/command.log`;

        [[ $(check_error) == 0 ]] || NOM_FIC_CT=""
        #touche $REP_LOG/command.log
        #logInfo "----------------------------"
    fi
}

function comptage_motifs(){

    if [[ $NOM_FIC_DT != "" ]]
    then
		COMPTEUR_MOTIFS=$(egrep -o -i $MOTIFS $NOM_FIC_DT 2>$REP_LOG/command.log | wc -l);


        [[ $(check_error) == 0 ]] && log_success "Compteur motifs" || log_failure "Compteur motifs Error:"`cat $REP_LOG/command.log` ;


        #touche $REP_LOG/command.log
    fi
}



function calcul_index(){

    if [[ $NOM_FIC_DT != "" ]]
    then
		
        NOM_FIC_FW=$REP_DT"/index_"$CPT_TABLE"_"$CPT_URL.txt
        # 4ème traitement : index hiérarchique de chaque DUMP (commande déjà vue en cours)
		
        #egrep -i -o "\w+" $NOM_FIC_DT | sort | uniq -c  | sort -r -n -s -k 1,1 > $NOM_FIC_FW 2>$REP_LOG/command.log \
         #       && log_success "Calcul index" || log_failure "Calcul index Error:"`cat $REP_LOG/command.log`

        python3 micro_nlp_utils.py 	-i $NOM_FIC_DT --get=index >$NOM_FIC_FW 2>$REP_LOG/command.log \
                    && log_success "Calcul index" || log_failure "Calcul index:"`cat $REP_LOG/command.log` ;

        [[ $(check_error) == 0 ]] || NOM_FIC_FW=""
        
    fi
}


function calcul_bigramme(){



    if [[ $NOM_FIC_DT != "" ]]
    then
		
        NOM_FIC_BG=$REP_DT"/bigramme_"$CPT_TABLE"_"$CPT_URL.txt
        # 4ème traitement : index hiérarchique de chaque DUMP (commande déjà vue en cours)
		
        #egrep -i -o "\w+" $NOM_FIC_DT | sort | uniq -c  | sort -r -n -s -k 1,1 > $NOM_FIC_FW 2>$REP_LOG/command.log \
         #       && log_success "Calcul index" || log_failure "Calcul index Error:"`cat $REP_LOG/command.log`

        python3 micro_nlp_utils.py 	-i $NOM_FIC_DT --get=bigrams >$NOM_FIC_BG 2>$REP_LOG/command.log \
                    && log_success "Calcul bigramme" || log_failure "Calcul bigramme:"`cat $REP_LOG/command.log` ;

        [[ $(check_error) == 0 ]] || NOM_FIC_BG=""
        
    fi
}



function telechargement_page(){

    NOM_FIC_PA=$REP_PA/$CPT_TABLE"_"$CPT_URL.html

    curl -sL -m 10 -o $NOM_FIC_PA $URL 2>$REP_LOG/command.log \
            && log_success "Téléchargement de l'URL" || log_failure "Error:"`cat $REP_LOG/command.log` ;

    [[ $(check_error) == 0 ]] || NOM_FIC_PA=""
}

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

    if [[ $NOM_FIC_DT != "" ]]
    then 
        echo "
            <td align=\"center\"><a href=\"$NOM_FIC_DT\">$CPT_TABLE"_"$CPT_URL</a></td>";
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
                <font color=\"white\"><b>Tableau n° $CPT_TABLE</b> <span>(Fichier: $FICHIER )</span></font>
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
