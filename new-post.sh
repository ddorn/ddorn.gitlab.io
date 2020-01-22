set -e

echo Titre:
read title

echo Sous-titre:
read subtitle

now=`date +%Y-%m-%d`


echo "---
title: $title
subtitle: $subtitle
date: $now
tags: []
---

Begenning and preview

<!--more-->

The rest of the text" >> ./content/post/$now-$title.md
