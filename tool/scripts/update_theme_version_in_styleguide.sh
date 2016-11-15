#!/usr/bin/env bash

LASTEST_TAG=`git tags | tail -1`

MDLSITE="/Volumes/Daten/DevLocal/DevDart/MaterialDesignLiteSite"
THEME_FILE="samples/styleguide/.sitegen/html/_content/views/theming.html"

sed -i -e "s/^theme_version: v[^\n]*/theme_version: ${LASTEST_TAG}/g" "${MDLSITE}/${THEME_FILE}"