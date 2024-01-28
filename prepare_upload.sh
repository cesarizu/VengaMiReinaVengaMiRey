#!/bin/bash

mkdir -p tmp

rm -rf upload
mkdir -p upload/
touch upload/.gdignore

git archive --format=zip --output upload/src.zip main

zip upload/game.zip -r release/*.exe

cp license.txt upload/

