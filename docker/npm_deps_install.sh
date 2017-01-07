#!/bin/bash

npm install

mkdir priv/static
mkdir priv/static/css
mkdir priv/static/js
mkdir priv/static/images

node node_modules/brunch/bin/brunch build
