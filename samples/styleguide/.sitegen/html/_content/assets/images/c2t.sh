#!/usr/bin/env bash

#-----------------------------------------
# Convert image to thumbnaila

filename=$(basename "$1")
extension="${filename##*.}"
filename="${filename%.*}"

target="template-${filename}.jpg"

convert "$1" -resize 140x115 -quality 90 ${target}

echo ${target} created!