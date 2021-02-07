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
  flutter build appbundle --no-shrink --no-tree-shake-icons
  cp "build/app/outputs/bundle/release/app-release.aab" "tmp/bbtraining-$GIT_TAG.aab"
}

function createAPKs {
  echo "Create apks"
  flutter build apk --no-shrink --split-per-abi --no-tree-shake-icons
  cp "build/app/outputs/apk/release/app-arm64-v8a-release.apk" "tmp/bbtraining-arm64-v8a-$GIT_TAG.apk"
  cp "build/app/outputs/apk/release/app-armeabi-v7a-release.apk" "tmp/bbtraining-armeabi-v7a-$GIT_TAG.apk"
}

doPrepare
createJSON
createBundle
createAPKs
