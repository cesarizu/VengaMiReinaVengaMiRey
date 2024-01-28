#!/bin/bash

mkdir -p tmp

git archive --format=zip --output tmp/src.zip main

rm -rf upload
mkdir -p upload/{src,release,press,other}

pushd upload

pushd src
unzip ../../tmp/src.zip
popd

pushd release
cp -r ../../release/* .
popd

cp ../license.txt .

popd

rm -f upload.zip
zip upload.zip -r upload

