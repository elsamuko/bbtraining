#!/usr/bin/env bash

GIT_TAG=$(git describe --abbrev=0)

function doPrepare {
  echo "Clean"
  flutter clean
}

function createJSON {
  scripts/gen_json.py res/exercises.ods > res/exercises.json
}

function createBundle {
  echo "Create bundle"
  flutter build appbundle --no-shrink
  cp "build/app/outputs/bundle/release/app-release.aab" "tmp/bbtraining-$GIT_TAG.aab"
}

function createAPKs {
  echo "Create apks"
  flutter build apk --no-shrink --split-per-abi
  cp "build/app/outputs/apk/release/app-arm64-v8a-release.apk" "tmp/bbtraining-arm64-v8a-$GIT_TAG.apk"
  cp "build/app/outputs/apk/release/app-armeabi-v7a-release.apk" "tmp/bbtraining-armeabi-v7a-$GIT_TAG.apk"
}

function createWeb {
  echo "Create web"

  convert res/launcher/icon.png -resize 16x16 web/favicon.png
  convert res/launcher/icon.png -resize 192x192 web/icons/Icon-192.png
  convert res/launcher/icon.png -resize 192x192 web/icons/Icon-maskable-192.png
  convert res/launcher/icon.png -resize 512x512 web/icons/Icon-512.png
  convert res/launcher/icon.png -resize 512x512 web/icons/Icon-maskable-512.png

  flutter build web --base-href "/bbtraining-web/web/"
  tar -czvf "tmp/bbtraining-web-$GIT_TAG.tar.gz" "build/web"
  cp -r "build/web/" "../bbtraining-web/"
}

doPrepare
createJSON
createBundle
createAPKs
