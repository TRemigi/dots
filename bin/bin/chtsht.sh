#!/usr/bin/env bash

languages=$(echo "golang ts js php dart c" | tr " " "\n")
core_utils=$(echo "find grep sed fzf xargs awk" | tr " " "\n")

selected=$(echo -e "$languages\n$core_utils" | fzf)

read -p "QUERY: " query 

if echo "$languages" | grep -qs $selected; then
  curl https://cht.sh/$selected/$(echo "$query" | tr " " "+")
else
  curl https://cht.sh/$selected~$query
fi
