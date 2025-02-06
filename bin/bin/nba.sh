#! /bin/bash

###################################
# Node Bulk Auditor               #
###################################

######################
# functions          #
######################
Help()
{
  echo "###################################"
  echo "# Node Bulk Auditor               #"
  echo "###################################"
  echo
  echo "Searches for subdirectories within [directory] which contain a package.json file, the runs npm audit --audit-level [audit-level] for each."
  echo
  echo "Syntax: nba [-h|q] [directory] [audit-level]"
  echo "[audit-level] should be one of low, medium, high, or critical."
  echo "options:"
  echo "h     Print this Help."
  echo "q     Run the program with no output other than a number indicating the total number of projects with one or more vulnerabilities matching audit-level."
  echo
}

QUIET=false
NUM_AFFECTED_PROJECTS=0
NOW=$(date +%s | tr " " "_")

while getopts ":hq" option; do
   case $option in
      h) # display Help
         Help
         exit;;
      q) # Enable quiet mode
         QUIET=true;;
     \?) # Invalid option
         echo "Error: Invalid option"
         Help
         exit;;
   esac
done
REPOS_DIR=${@:$OPTIND:1}
AUDIT_LEVEL=${@:$OPTIND+1:1}

OUTPUT_DIR="$HOME/sec/nba_audits/$NOW_$AUDIT_LEVEL"
mkdir -p $OUTPUT_DIR

if [[  "$QUIET" = false ]]; then
  echo "Finding Node projects in $REPOS_DIR..."
fi

JS_PROJECTS=$(cd $REPOS_DIR && find . -type f -name 'package.json' -depth 2 | sed -E 's|/[^/]+$||' | sort -u | cut -c 3-)
ARR=($JS_PROJECTS)

if [[  "$QUIET" = false ]]; then
  echo "Found ${#ARR[@]} Node projects"
fi

for PROJ in ${ARR[@]};
do
  if [[  "$QUIET" = false ]]; then
    echo "Checking $PROJ for $AUDIT_LEVEL vulnerabilities..."
  fi
  cd $REPOS_DIR/$PROJ
  RESULTS=$(npm audit --audit-level $AUDIT_LEVEL 2> /dev/null | grep "$AUDIT_LEVEL")

  if [[ -n ${RESULTS} ]]; then
    NUM_AFFECTED_PROJECTS=$(($NUM_AFFECTED_PROJECTS+1))
    if [[  "$QUIET" = false ]]; then
      printf "\n$PROJ:\n" >> "$OUTPUT_DIR"/report_"$NOW".txt
      echo $RESULTS >> $OUTPUT_DIR/report_$NOW.txt
    fi
  fi
done

if [[  "$QUIET" = false ]]; then
  printf "\n##################################################\n"
  echo "NBA scan complete"
  printf "##################################################\n"
  echo "$NUM_AFFECTED_PROJECTS projects with $AUDIT_LEVEL vulnerabilities found"
  cat $OUTPUT_DIR/report_$NOW.txt
  printf "\nThis report is stored at $OUTPUT_DIR/report_$NOW.txt"
else
  echo "$NUM_AFFECTED_PROJECTS"
fi

