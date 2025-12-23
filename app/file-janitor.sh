#!/usr/bin/env bash
echo 'File Janitor, 2025'
echo -e 'Powered by Bash\n'

FILES_COUNT=0

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

countFiles() {
  FILES_COUNT=$(find "$1" -maxdepth 1 -type f -name "*.$2" | wc -w)
}

printFilesAndBytes() {
  countFiles "$1" "$2"
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

clean() {
  if ! is_validate_directory "$1"; then
        return 1
  fi

  DIR=$1
  SUCCESS_MSG="Clean up of $DIR is complete!"
  if [ -z "$1" ]; then
    ## I think one can define a default to a var with something like this DIR="${2:-"."}". Seems also reasonable to me
    DIR=.
    echo "Cleaning the current directory..."
    SUCCESS_MSG="Clean up of the current directory is complete!"
  else
    echo "Cleaning $1..."
  fi

  echo -n "Deleting old log files...  "
  FILES_COUNT=$(find "$DIR" -maxdepth 1 -type f -mtime +3  -name "*.log" | wc -w)
  find "$DIR" -type f -mtime +3 -name "*.log" -exec rm {} \;
  echo "done! $FILES_COUNT files have been deleted"

  echo -n "Deleting temporary files...  "
  countFiles "$DIR" "tmp"
  ## Also good idea it to use -print option that prints the found files at the end  even with the exec option in place.
  ## we can then pipe into wc as we do in countFiles
  find "$DIR" -maxdepth 1 -type f -name "*.tmp" -exec rm {} \;
  echo "done! $FILES_COUNT files have been deleted"

  echo -n "Moving python files...  "
  countFiles "$DIR" "py"
  if [ "$FILES_COUNT" -ne 0 ]; then
     mkdir "$DIR/python_scripts"
     find "$DIR" -maxdepth 1 -type f -name "*.py" -exec mv {} -t "$DIR/python_scripts" \;
  fi
  echo "done! $FILES_COUNT files have been moved"
  echo -e "\n$SUCCESS_MSG"
}

if [ "$1" = "help" ]; then
  cat ./file-janitor-help.txt
elif [ "$1" = "list" ]; then
  list "$2"
elif [ "$1" = "report" ]; then
  report "$2"
elif [ "$1" = "clean" ]; then
  clean "$2"
else
  echo "Type $0 help to see available options"
fi