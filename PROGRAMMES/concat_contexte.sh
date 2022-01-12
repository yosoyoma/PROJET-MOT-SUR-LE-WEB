#!/bin/bash

REP_CT=../CONTEXTES

for FICHIER in `ls $REP_CT/utf8*.txt `;
do 

    FILE_NUM=$(echo $FICHIER | cut -d"_" -f2)

    echo "FICHIER=$FICHIER"

    echo "FILE_NUM=$FILE_NUM"
    echo "CONTEXTE=$REP_CT/CONTEXTES_$FILE_NUM.txt"
    
    cat $REP_CT"/"$FICHIER >>$REP_CT"/CONTEXTES_"$FILE_NUM".txt"
done



exit 0
#/home/amina/Workspace/PROJET-MOT-SUR-LE-WEB/PROGRAMMES/old_scripts/concat_file.sh

REP_DT=../DUMP-TEXT

for FICHIER in `ls $REP_DT/utf8*.txt `;
do 
    FILE_NUM=$(echo $FICHIER | cut -d"_" -f2)
    
    cat $REP_CT"/"$FICHIER >>$REP_CT"/CONTEXTES_"$FILE_NUM".txt"
done
    
#/home/amina/Workspace/PROJET-MOT-SUR-LE-WEB/PROGRAMMES/old_scripts/concat_file.sh