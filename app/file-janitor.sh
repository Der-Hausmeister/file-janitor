#!/usr/bin/env bash
echo 'File Janitor, 2025'
echo -e 'Powered by Bash\n'

is_validate_directory() {
    if [ -n "$1" ] && [ ! -e "$1" ]; then
        echo -e "$1 is not found"
        return 1
    fi

    if [ -n "$1" ] && [ ! -d "$1" ]; then
        echo -e "$1 is not a directory"
        return 1
    fi

    return 0
}

list() {
    # Validate directory first
    ## call own command and not "test", therefore no use of "[ ]"
    if ! is_validate_directory "$1"; then
        return 1
    fi

  DIR=$1;
  if [ -z "$DIR" ]; then
    echo -e "Listing files in the current directory\n"
    DIR=.
  else
    echo -e "Listing files in $1\n"
  fi
  ## Okay, this is super complicated. This is the same as 'ls -A1 "$DIR"' :-)
  ls -lA "$DIR" | tail -n +2 | tr -s '[:space:]' | cut -d ' ' -f 9
}

printFilesAndBytes() {
  FILES_COUNT=$(find "$1" -maxdepth 1 -name "*.$2" | wc -w)
  ## Nice is also: "find  -maxdepth 1 -name '*.ps' -type f -printf "%s"",
  # but this also does not help with the empty result
  FILES_SIZE=$(find "$1" -maxdepth 1 -name "*.$2" -exec wc -c {} \+ | tail -n 1 | cut -d " " -f 1)
  if [ -z "$FILES_SIZE" ]; then
      FILES_SIZE=0
  fi
  echo "$FILES_COUNT $2 file(s), with total size of $FILES_SIZE bytes"
}

report() {
    if ! is_validate_directory "$1"; then
        return 1
    fi

  DIR=$1
  if [ -z "$1" ]; then
    DIR=.
    echo "The current directory contains:"
  else
    echo "$1 contains:"
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