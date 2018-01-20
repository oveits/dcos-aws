#!/bin/bash

usage(){
    echo "usage: $0 [-v] folder parameters"
}

runScripts(){

    SCRIPTS=$@
    for CMD in $SCRIPTS 
    do
       [ "$VERBOSE" == "true" ] && echo running $CMD
       echo $CMD | grep -q _source_ && source ./$CMD $PARAMS || sh ./$CMD $PARAMS 
       RETURNVALUE=$?
       if [ "$RETURNVALUE" != "0" ]; then
         echo 'Command "'"$CMD"'" has returned a non-zero value ('$RETURNVALUE'); Aborting...'
         exit $RETURNVALUE
       fi
    done

}

[ "$1" == "-v" ] && VERBOSE=true && shift
FOLDER=$1
shift
PARAMS=$@

[ "$FOLDER" == "" ] && usage && exit 1

BEFORE_SCRIPTS=$(echo before/[0-9][0-9]*_*)
UP_SCRIPTS=$(echo up/[0-9][0-9]*_*)
DOWN_SCRIPTS=$(echo down/[0-9][0-9]*_*)

runScripts $BEFORE_SCRIPTS
[ -d "$FOLDER" ] &&  runScripts $(echo $FOLDER/[0-9][0-9]*_*) 
#[ "$1" == "up" ] && runScripts $UP_SCRIPTS
#[ "$1" == "down" ] && runScripts $DOWN_SCRIPTS
