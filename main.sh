#!/usr/bin/env bash

set -o errexit
set -o pipefail
set -o nounset

APIKEY=ghp_ca3f65c5a8e74b3c853ceb99e03dc6f0

STARS_PAGE_COUNT=1
DELETE_SLEEP_TIME=.1

while true
do
  echo "[*] loading star list..."
  CONTENT_READ=$(
    curl -s -H "Authorization: token $APIKEY" https://api.github.com/user/starred | jq -r '.[] |.full_name'
  )
  if [ -z "$CONTENT_READ" ]; then
    break
  fi

  echo "[*] queuing items..."
  echo "$CONTENT_READ"
  echo "++++++++++++++++++++++++++++++++"

  while read -r REPO; do
    echo "[*] deleting $REPO"
    curl -X DELETE -s -H "Authorization: token $APIKEY" https://api.github.com/user/starred/$REPO
    sleep $DELETE_SLEEP_TIME
  done <<< "$CONTENT_READ"
done
