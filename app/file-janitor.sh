#!/usr/bin/env bash
echo 'File Janitor, 2025'
echo 'Powered by Bash'

if [ "$1" = "help" ]; then
   cat ./file-janitor-help.txt
else
  echo "Type $0 help to see available options"
fi