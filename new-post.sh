set -e

echo Titre:
read title

echo Sous-titre:
read subtitle

now=`date +%Y-%m-%d`


echo ---
echo title: $title
echo subtitle: $subtitle
echo date: $now
echo tags: []
echo ---
echo
echo Begenning and preview
echo
echo "<!--more-->"
echo
echo The rest of the text
