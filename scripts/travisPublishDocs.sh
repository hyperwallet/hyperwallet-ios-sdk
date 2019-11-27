#!/bin/sh

# Set identity
git config --global user.email "travis-ci-hyperwallet@paypal.com"
git config --global user.name "travis-ci-hyperwallet"

# Publish docs
mkdir ../gh-pages
cp -r docs/* ../gh-pages/
cd ../gh-pages

# Add branch
git init
git remote add origin https://${CI_USER_TOKEN}@github.com/hyperwallet/hyperwallet-ios-ui-sdk.git > /dev/null
git checkout -B gh-pages

# Push generated files
git add .
git commit -m "Documentation updated"
git push origin gh-pages -fq > /dev/null
