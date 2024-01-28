#!/bin/bash

mkdir -p tmp

rm -rf upload
mkdir -p upload/
touch upload/.gdignore

git archive --format=zip --output upload/src.zip main

cp -r release/*.exe upload/

cp license.txt upload/

