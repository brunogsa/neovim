#!/usr/bin/env bash

# Cheatsheet: https://devhints.io/bash

set -o errexit     # Abort script on any error
set -o nounset     # Raise a failure if an unset var is used
shopt -s nullglob  # Allows iterating through empty arrays without errors

# Make using relative paths easy
SCRIPT_PATH="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"

# On errors, print the line and an error stack
function log_stack() {
  local i=0
  local FRAMES=${#BASH_LINENO[@]}

  # FRAMES-2 skips main, the last one in arrays
  for ((i=FRAMES-2; i>=0; i--)); do
    echo "  File \"${BASH_SOURCE[i+1]}\", line ${BASH_LINENO[i]}, in ${FUNCNAME[i+1]}"
    # Grab the source code of the line
    #sed -n "${BASH_LINENO[i]}{s/^/    /;p}" "${BASH_SOURCE[i+1]}"
  done

  return 0
}
function die() {
  echo "ERROR $? IN ${BASH_SOURCE[0]} AT LINE ${BASH_LINENO[0]}" 1>&2
  # log_stack
  exit 1
}
trap die ERR


# Syntax sugar for debug mode
function enableDebug() {
  echo -e "\n"
  set -x
}
function disableDebug() {
  set +x
}

# Explain how to use your script
function usage() {
cat <<EOF
Usage ${SCRIPT_PATH}/$0 OPTIONS
Options:
    --help, -h   this help
EOF
}

# Parse arguments
version=""
daemon=0
args=()

while [[ $# -gt 0 ]]; do
  case "$1" in
  -v=* | --version=*)
    # set an option with argument
    version="${1#*=}"
    ;;

  -d | --daemon)
    # set a binary option
    daemon=1
    ;;

  -h | --help)
    usage
    exit 0
    ;;

  --)
    # forward all arguments after `--` to the command
    shift
    args+=("${@}")
    break
    ;;

  *)
    echo "ERROR: unknown option '$1'"
    usage
    exit 1
    ;;
  esac

  shift  # Removes the first argument from list
done

# That's how you import another script file
source urls.sh

# OK do here something with "${args[@]}"
echo "SCRIPT_PATH = ${SCRIPT_PATH}"
echo "args    = ${args[*]:-}"
echo "version = $version"
echo "daemon  = $daemon"


# Conditional examples
if [[ -z "$environment" ]]; then
  echo "Param environment is mandatory, provided: ${environment}"
  exit 1
fi
if [[ $environment != "staging" && $environment != "production" ]]; then
  echo "Unknown environment provided: ${environment}"
  exit 1
fi

# That's how you export a function
export -f enableDebug
export -f disableDebug
