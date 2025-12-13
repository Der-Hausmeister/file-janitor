#!/usr/bin/env bash
echo 'File Janitor, 2025'
echo -e 'Powered by Bash\n'

list() {
  if [ -n "$1" ] && [ ! -e "$1" ]; then
        echo -e "$1 is not found"
        return 0
  fi
  if [ -n "$1" ] && [ ! -d "$1" ]; then
      echo -e "$1 is not a directory"
      return 0
  fi

  local dir=$1;
  if [ -z "$dir" ]; then
    echo -e "Listing files in the current directory\n"
    dir=.
  else
    echo -e "Listing files in $1\n"
  fi
  ## Okay, this is super complicated. This is the same as 'ls -A1 "$dir"' :-)
  ls -lA "$dir" | tail -n +4 | tr -s '[:space:]' | cut -d ' ' -f 9
}

if [ "$1" = "help" ]; then
  cat ./file-janitor-help.txt
elif [ "$1" = "list" ]; then
  list "$2"
else
  echo "Type $0 help to see available options"
fi