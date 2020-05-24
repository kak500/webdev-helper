#!/usr/bin/env bash

VERSION='1.0'
AUTHOR='Krzysztof Kowalski'
EMAIL='email@mail.com'
declare -A COMMANDS=(
  [exit]="Exits program"
  [help]="Provides commands list with descriptions"
  [mkdir]="Creates directory and basic HTML template within given path,\n\t example: mkdir [path] [directory name]"
  [addeditor]="Install code editors"
)

function display_greetings() {
  echo "---------------------"
  echo "Welcome to WebDev Helper version $1"
  echo "Author: $2"
  printf "\nPurpose of this script is to help with daily work with website development\nand also speed up learning process by putting series of commands into one place\n\nType 'help' for more details about available commands\nType 'exit' to exit the program\n"
  echo "---------------------"
}

function install_editor() {

  # if [[ -z $1 ]]; then
  #   echo "'addeditor' expects argument"
  #   return 1
  # fi
  # echo "Choose editor"
  echo "sublime"
  echo "atom"
  read -p "Choose: " editor

  case $editor in
    "atom" ) echo "Installing selected editor...";
    echo "Insert su password";
    sudo add-apt-repository ppa:webupd8team/atom;
    sudo apt-get update;
    sudo apt-get install atom
      ;;
    "sublime" ) echo "Installing selected editor...";
    echo "Insert su password";
    wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | sudo apt-key add -;
    echo "deb https://download.sublimetext.com/ apt/stable/" | sudo tee /etc/apt/sources.list.d/sublime-text.list;
    sudo apt-get update;
    sudo apt-get install sublime-text;
    ;;
    * ) echo "This editor is not supported."
  esac
  printf '\033[32mEditor successfully installed \033[0m\n'

}

function create_default_directory() {

  if [[ -z $1 ]]; then
    echo "'mkdir' expects 2 arguments"
    return 1
  elif [[ -z $2 ]]; then
    echo "'mkdir' expects 2 arguments"
    return 1
  fi
  local destination_path=$1
  local directory_name=$2
  if [[ ! -d $destination_path ]]; then
    echo "Path doesn't exist"
    return 1
  fi
  if [[ -d "$destination_path/$directory_name" ]]; then
    echo "$directory_name exists"
  else
    # echo "Creating directory $directory_name"
    mkdir $destination_path/$directory_name
    mkdir $destination_path/$directory_name/static
    touch $destination_path/$directory_name/index.html
    touch $destination_path/$directory_name/static/style.css
    touch $destination_path/$directory_name/static/main.js
    create_html_template $destination_path/$directory_name/index.html
    printf '\033[32mDirectory created \033[0m\n'
    tree $directory_name
  fi
}

function create_html_template() {
  local file_directory=$1
  echo '<!DOCTYPE html>
    <html lang="en" dir="ltr">
      <head>
        <link rel="stylesheet" href="/static/style.css">
        <script src="/static/main.js" charset="utf-8"></script>
        <meta charset="utf-8">
        <title>Template</title>
      </head>
      <body>
        <h1>Template File</h1>
        <p>Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.</p>
      </body>
    </html>
' > $file_directory
}

function display_help() {
  echo "Usage: "
  for K in "${!COMMANDS[@]}"; do
    printf "$K --- ${COMMANDS[$K]}\n";
  done
}

function exit_script() {
  printf "Exiting program...\n"
  exit 1
}

function read_input() {
  local command=$(echo $1 | awk '{print $1}' )
  local arg1=$2
  local arg2=$3

  case $command in
    "help" ) display_help ;;
    "exit" ) exit_script ;;
    "mkdir" ) create_default_directory $arg1 $arg2 ;;
    "addeditor" ) install_editor $arg1 ;;
    * ) echo "'$command' command not found"
  esac
}



function main() {
  clear
  display_greetings $VERSION "$AUTHOR"
  while [[ true ]]; do
    read -p ">> " input
    read_input $input
  done
}

main
