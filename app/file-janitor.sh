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
  ls -lA "$dir" | tail -n +2 | tr -s '[:space:]' | cut -d ' ' -f 9
}

printFilesAndBytes() {
  FILES_COUNT=$(find "$1" -maxdepth 1 -name "*.$2" | wc -w)
  FILES_SIZE=$(find "$1" -maxdepth 1 -name "*.$2" -exec wc -c {} \+ | tail -n 1 | cut -d " " -f 1)
  echo "$FILES_COUNT $2 file(s), with total size of $FILES_SIZE bytes"
}

report() {
  DIR=".";
  if [ -n "$1" ]; then
    DIR=$1
    echo "$1 contains:"
  else
    echo "The current directory contains:"
  fi

  printFilesAndBytes $DIR "tmp"
  printFilesAndBytes $DIR "log"
  printFilesAndBytes $DIR "py"
}

if [ "$1" = "help" ]; then
  cat ./file-janitor-help.txt
elif [ "$1" = "list" ]; then
  list "$2"
elif [ "$1" = "report" ]; then
  report "$2"
else
  echo "Type $0 help to see available options"
fi