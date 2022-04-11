#!/bin/sh

for imapnotify_config in ~/Documents/passwords/*_imapnotify.json; do
  LOG_FILE=$(sed 's#/#_#g' <<< "$imapnotify_config" )
  # sleep for internet to get ready lol
  (sleep 60 && goimapnotify -conf "$imapnotify_config" &> ~/.cache/"$LOG_FILE") &
done

