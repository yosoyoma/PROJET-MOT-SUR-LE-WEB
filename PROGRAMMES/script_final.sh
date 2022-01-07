#!/bin/bash
#-------------------------------------------------------
# pour lancer ce script:
# bash premierscript.sh <dossier URL> <dossier TABLEAUX>
#-------------------------------------------------------


source ./bin/fonctions.sh
source ./bin/cree_tableau.sh

#répertoire des fichiers contenant des urls 
REP_URLS=$1

#chemin relatif du répertoire du tableau html
TABLEAU_HTML=$2"index.html"


MOTIFS="منع|حمل|피임|حبوب|anticoncepción"




# todo: valider les arguments (ou arrêter le programme)
# il ne faut pas que les 2 variables suivantes soient "vides"
# ET il faut qu'elles contiennent des chaines de caractères correspondant
# à des noms de dossiers (i.e tester l'existence de ces dossier)



logInfo ""
logInfo "Motifs: $MOTIFS"
logInfo ""

logSeparateur "="
#chemin relatif des pages aspirées
REP_PA=../PAGES-ASPIREES
#chemin relatif des fichiers dump
REP_DT=../DUMP-TEXT

#chemin relatif des fichiers dump
REP_CT=../CONTEXTES

#Vidange des répertoires
[ "$(ls -A $REP_PA)" ] && rm $REP_PA/*.html >$REP_LOG/command.log 2>&1 && log_success "Purge: $REP_PA" || log_failure "Error:"`cat $REP_LOG/command.log`
[ "$(ls -A $REP_DT)" ] && rm $REP_DT/*.txt >$REP_LOG/command.log 2>&1 && log_success "Purge: $REP_DT" || log_failure "Error:"`cat $REP_LOG/command.log`
[ "$(ls -A $REP_CT)" ] && rm $REP_CT/*.txt >$REP_LOG/command.log 2>&1 && log_success "Purge: $REP_CT" || log_failure "Error:"`cat $REP_LOG/command.log`
#exit 0
#-------------------------------------------------------
# en-tête du fichier html
html_head >$TABLEAU_HTML

html_body >>$TABLEAU_HTML
#-------------------------------------------------------

# pour chaque élément contenu dans DOSSIER_URL
#compteur des fichiers des urls
# on compte les tableaux
CPT_TABLE=0
for FICHIER in `ls $REP_URLS`;
do 
   logSeparateur "="
   # on compte les tableaux
	CPT_TABLE=$(($CPT_TABLE + 1)) ;

   # Début de tableau
   html_table >>$TABLEAU_HTML
   
   CPT_URL=0

   logInfo "Traitement du fichier n°$CPT_TABLE : "$FICHIER
   logInfo "        "
   while read URL
   do
      logSeparateur "-"

      #compteur des urls
      CPT_URL=$(($CPT_URL+1))
      
      logInfo "URL n°$CPT_URL :${URL:0:100}"
      
      #le nom complet du fichier de l'url aspirée
      NOM_FIC_PA=""
      NOM_FIC_DT_UTF8=""
      NOM_FIC_DT=""
      NOM_FIC_CT=""
      NOM_FIC_FW=""
      NOM_FIC_BG=""
      COMPTEUR_MOTIFS=""
      ENCODAGE=""
      CHECK_ENCODAGE=-1

      #vérification du code status http 
      codeHTTP=$(curl -sIL -m 15 -w '%{http_code}\n' -o http_head $URL | tr -d '\r\n');

      [ $codeHTTP -eq 200 ] && log_success "Contrôle URL (HTTP CODE $codeHTTP)" || log_failure "Contrôle URL (HTTP CODE $codeHTTP)"
      
      if [[ $codeHTTP == 200 ]]
			then 

            #téléchargement (aspiration) de l'url en cours
            telechargement_page;

            #détection de l'ENCODAGE    
            detection_encodage;

            #
            dump_text;

            # si encodage = UTF8 alors on fait certains traitements
				# sinon il faudra aussi les faire et probablement d'autres
            gestion_encodage;

            #
            comptage_motifs;

            #
            extraire_contextes;

            #
            calcul_index;

            #
            calcul_bigramme

      fi

      # construire les lignes du tableau
      html_table_rows >>$TABLEAU_HTML

   logInfo "     "

   done < $REP_URLS/$FICHIER
   
   # Fin du tableau (et de la lecture du fichier)
   html_table_close >>$TABLEAU_HTML
   
done

html_body_close >>$TABLEAU_HTML
html_close>>$TABLEAU_HTML
logSeparateur "="
exit 0
