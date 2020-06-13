#!/usr/bin/env bash


# Okay
# printf "\033[32mvenv created in $venv_path \033[0m\n"
# Error
# printf "\033[31merror \033[0m\n"

VERSION='1.2'
AUTHOR='Krzysztof Kowalski'
EMAIL='email@mail.com'
declare -A COMMANDS=(
  [exit]="Exits program"
  [help]="Provides commands list with descriptions"
  [version]="Displays script's version"
  [mkdir]="Creates directory and basic HTML template within given path, example: mkdir [path] [directory name]"
  [addeditor]="Lists available code editors"
  [setupdjango]="Installs dependencies like PIP and VENV, also creates virtual enviroment and installs Django in it"
)

function display_version() {
  echo "Current version: $1"
}

function display_greetings() {
  echo "---------------------"
  echo "Welcome to WebDev Helper version $1"
  echo "Author: $2"
  printf "\nPurpose of this script is to help with daily work with website development\nand also speed up learning process by putting series of commands into one place\n\nType 'help' for more details about available commands\nType 'exit' to exit the program\n"
  echo "---------------------"
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

function install_pip() {
  echo "Installing PIP..."
  sudo apt-get install python3-pip
}

function is_package_installed() {
  local package_name=$1
  dpkg -s $package_name &> /dev/null
  if [[ $? -eq 0 ]]; then
    echo true
  else
    echo false
  fi
}

function install_package() {
  local package_name=$1
  case $package_name in
    "pip" ) printf "\033[33mInstalling $package_name... \033[0m\n"; sudo apt-get install python3-pip
      ;;
    "venv" ) printf "\033[33mInstalling $package_name... \033[0m\n"; sudo apt-get install python3-venv;
        ;;
  esac
}


function setup_django() {
  echo "Setting up Django"
  if [ $(is_package_installed python3-pip) = true ]; then
    printf '\033[32mpython3-pip installed \033[0m\n'
  else
    install_package pip
    printf '\033[32mpython3-pip installed \033[0m\n'
  fi
  if [ $(is_package_installed python3-venv) = true ]; then
    printf '\033[32mpython3-venv installed \033[0m\n'
  else
    install_package venv
    printf '\033[32mpython3-venv installed successfully \033[0m\n'
  fi
  echo "Creating venv"
  read -e -p ">> Select path: " venv_path
  create_venv $venv_path
  source $venv_path/bin/activate
  pip freeze
  pip show django &> /dev/null
  if [[ $? -eq 0 ]]; then
    printf "\033[32mDjango is already installed \033[0m\n"
  else
    pip install Django
    printf "\033[32mDjango installed successfully \033[0m\n"
  fi
  echo "pip packages: "
  pip freeze
}

function display_cheatsheet() {
  echo "Django cheat sheet"
  echo "----------------"
  printf "CREATE PROJECT\ndjango-admin start PROJECTNAME\n"
  echo "----------------"
  printf "RUN SERVER\npython manage.py runserver\n"
  echo "----------------"
  printf "CREATE AN APP\npython manage.py start app APPNAME\n"
}


function install_editor() {
  echo "sublime"
  echo "atom"
  read -p ">> Choose: " editor

  case $editor in
    "atom" ) echo "Installing selected editor...";
    echo "Insert su password";
    sudo add-apt-repository ppa:webupd8team/atom;
    sudo apt-get update;
    sudo apt-get install atom;
    printf '\033[32mEditor successfully installed \033[0m\n'
      ;;
    "sublime" ) echo "Installing selected editor...";
    echo "Insert su password";
    wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | sudo apt-key add -;
    echo "deb https://download.sublimetext.com/ apt/stable/" | sudo tee /etc/apt/sources.list.d/sublime-text.list;
    sudo apt-get update;
    sudo apt-get install sublime-text;
    printf '\033[32mEditor successfully installed \033[0m\n';
    ;;
    * ) echo "This editor is not supported."
  esac
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
    mkdir $destination_path$directory_name
    mkdir $destination_path$directory_name/static
    touch $destination_path$directory_name/index.html
    touch $destination_path$directory_name/static/style.css
    touch $destination_path$directory_name/static/main.js
    create_html_template $destination_path$directory_name/index.html
    printf '\033[32mDirectory created \033[0m\n'
    tree $directory_name
  fi
}

function create_html_template() {
  local file_directory=$1
  echo '<!DOCTYPE html>
    <html lang="en" dir="ltr">
      <head>
        <link rel="stylesheet" href="static/style.css">
        <script src="static/main.js" charset="utf-8"></script>
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


function read_input() {
  local command=$(echo $1 | awk '{print $1}' )
  local arg1=$2
  local arg2=$3

  case $command in
    "help" ) display_help ;;
    "exit" ) exit_script ;;
    "version" ) display_version $VERSION ;;
    "mkdir" ) create_default_directory $arg1 $arg2 ;;
    "addeditor" ) install_editor $arg1 ;;
    "setupvenv" ) setup_venv $arg1 $arg2 ;;
    "setupdjango" ) setup_django ;;
    * ) echo "'$command' command not found"
  esac
}

function main() {

  if [[ $1 = "cheat" ]]; then
    display_cheatsheet
  else
    clear
    display_greetings $VERSION "$AUTHOR"
    while [[ true ]]; do
      read -e -p ">> " input
      read_input $input
    done

  fi

}

main $1
