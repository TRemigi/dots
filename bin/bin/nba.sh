#! /bin/bash

###################################
# Node Bulk Auditor               #
###################################

######################
# functions          #
######################
Help()
{
  echo "Searches for subdirectories within [directory] which contain a package.json file, the runs npm audit --audit-level [audit-level] for each."
  echo
  echo "Syntax: nba [-h|q] [directory] [audit-level]"
  echo "options:"
  echo "h     Print this Help."
  echo "q     Run the program with no output other than a number indicating the total number of projects with one or more vulnerabilities matching audit-level."
  echo
}

QUIET=false
REPOS_DIR="$1"
AUDIT_LEVEL="$2"
NUM_AFFECTED_PROJECTS=0
NOW=$(date +%s | tr " " "_")

while getopts ":hq:" option; do
   case $option in
      h) # display Help
         Help
         exit;;
      n) # Enter a name
         Name=$OPTARG;;
     \?) # Invalid option
         echo "Error: Invalid option"
         exit;;
   esac
done

OUTPUT_DIR="$HOME/sec/nba_audits/$NOW_$AUDIT_LEVEL"
mkdir -p $OUTPUT_DIR

if [[ -n ${QUIET} ]]; then
  echo "Finding Node projects in $REPOS_DIR..."
fi

JS_PROJECTS=$(cd $REPOS_DIR && find . -type f -name 'package.json' -depth 2 | sed -E 's|/[^/]+$||' | sort -u | cut -c 3-)
ARR=($JS_PROJECTS)

if [[ -n ${QUIET} ]]; then
  echo "Found ${#ARR[@]} Node projects"
fi

for PROJ in ${ARR[@]};
do
  if [[ -n ${QUIET} ]]; then
    echo "Checking $PROJ for $AUDIT_LEVEL vulnerabilities..."
  fi
  cd $REPOS_DIR/$PROJ
  RESULTS=$(npm audit --audit-level $AUDIT_LEVEL | grep "$AUDIT_LEVEL")

  if [[ -n ${RESULTS} ]]; then
    NUM_AFFECTED_PROJECTS=$(($NUM_AFFECTED_PROJECTS+1))
    if [[ -z ${QUIET} ]]; then
      printf "\n$PROJ:\n" >> $OUTPUT_DIR/report.txt
      echo $RESULTS >> $OUTPUT_DIR/report.txt
    fi
  fi
done

if [[ -n ${QUIET} ]]; then
  printf "\n##################################################\n"
  echo "NBA scan complete"
  printf "##################################################\n"
fi
echo "$NUM_AFFECTED_PROJECTS projects with $AUDIT_LEVEL vulnerabilities found"
if [[ -n ${QUIET} ]]; then
  cat $OUTPUT_DIR/report.txt
  printf "\nThis report is stored at $OUTPUT_DIR/report.txt"
fi

