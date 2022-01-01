#!/bin/bash

python3 -m pip install --upgrade pip

python3 -m pip install -r requirements.txt

echo "creation des répertoires du projet ..."

mkdir -p ./CONTEXTES;
mkdir -p ./CONTEXTES;
mkdir -p ./DUMP-TEXT;
mkdir -p ./IMAGES;
mkdir -p ./PAGES-ASPIREES;
mkdir -p ./PROGRAMMES;
mkdir -p ./TABLEAUX;
mkdir -p ./URLS;

echo "fin ..."

echo "------------"
tree .

