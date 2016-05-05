#!/bin/sh

cd vendor

rm -rf music-encoding
git clone -b develop git@github.com:music-encoding/music-encoding.git --depth 1
rm -rf music-encoding/.git

rm -rf stylesheets
git clone -b master git@github.com:TEIC/Stylesheets.git stylesheets --depth 1
rm -rf stylesheets/.git
