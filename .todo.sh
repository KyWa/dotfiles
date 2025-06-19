#!/usr/bin/env bash

### Working on more features for the todo list functions
# Completed todo or just a single todo file?
# If completed file, should it be cleaned up at a certain point?
# Or if not, have it go remove/replace the FOLLOWUP field with another phrase?

function todo_check_followups(){
    DOC_YEAR=`date +%Y`
    DOC_PATH=`find ~/engagements/Customers/*/Journals/ -iname "$DOC_YEAR-*.md"`
    for x in $DOC_PATH;do
        grep "FOLLOWUP" $x | sed "s/^[ \t]*//" | sed "s/-\ FOLLOWUP\ -\ //"
    done
}

function todo(){
    if [[ -z $1 ]];then
        echo "What do you need todo?"
        read newtodo
        echo $newtodo >> ~/.todo
    else
        case $1 in
            clean)
                echo "" > ~/.todo
                ;;
            *)
                echo "I have no idea what you want me to do"
                ;;
        esac
    fi
}
