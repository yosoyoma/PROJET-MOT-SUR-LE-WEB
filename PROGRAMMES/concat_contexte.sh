#!/bin/bash

REP_CT=../CONTEXTES

for FICHIER in `ls $REP_CT/utf8*.txt `;
do 
    FILE_NUM=$(echo $FICHIER | cut -d"_" -f2)
    
    cat $REP_CT"/"$FICHIER >>$REP_CT"/CONTEXTES_"$FILE_NUM".txt"
done
    
#/home/amina/Workspace/PROJET-MOT-SUR-LE-WEB/PROGRAMMES/old_scripts/concat_file.sh