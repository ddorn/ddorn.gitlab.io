#!/usr/bin/env sh

file=$(ls -1 content/post/ | sort | tail -n ${1:-1} | head -n 1)
vim content/post/$file
