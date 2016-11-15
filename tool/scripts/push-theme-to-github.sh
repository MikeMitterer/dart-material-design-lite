#!/usr/bin/env bash

LASTEST_TAG=`git tags | tail -1`

cd ../MaterialDesignLiteTheme/
git add .
git commit -am "Merged latest master"

git tag ${LASTEST_TAG}
echo "TAG in MaterialDesignLiteTheme is set to ${LASTEST_TAG}!"

git push --tags




