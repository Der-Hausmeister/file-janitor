#!/usr/bin/env bash

passwordCheck() {
  echo "Checking the password entered by user"

  echo "Enter password: "
  read input
  if [ "$input" = "pass" ]; then
    echo "Correct password entered"
  else
    echo "Incorrect password entered"
  fi
}

compareNumber() {
  num1=20;
  num2=10;

  if [ "$num1" -eq "$num2" ]; then
      echo "Numbers are equal"
  elif [ "$num1" -gt "$num2" ]; then
      echo "First number is greater"
  else
    echo "Second number is greater"
  fi
}

solve() {
    if [ $1 = $2 ]; then
        echo "Correct password entered. Proceeding further"
    else
        echo "Incorrect password. Please try again"
    fi
}
