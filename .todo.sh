#!/usr/bin/env bash

### Working on more features for the todo list functions
# Completed todo or just a single todo file?
# If completed file, should it be cleaned up at a certain point?
# Or if not, have it go remove/replace the FOLLOWUP field with another phrase?

## INITIAL VARS
FOLLOWUP_FILE="$HOME/.fup"
TODO_FILE="$HOME/.todo"

## Followups from engagement journals
function todo_check_followups(){
    DOC_YEAR=`date +%Y`
    DOC_PATH=`find ~/engagements/Customers/*/Journals/ -iname "$DOC_YEAR-*.md"`
    FUP_ID=0

    if [[ -f "$FOLLOWUP_FILE" ]];then
        echo "Followup file already exists."
    else
        touch "${FOLLOWUP_FILE}"
    fi

    for x in `grep FOLLOWUP $DOC_PATH`;do
        echo "$FUP_ID: `echo $x | sed 's/^[ \t]*//' | sed 's/-\ FOLLOWUP\ -\ //'`" >> $FOLLOWUP_FILE
        #echo "$FUP_ID: `echo $x | sed "s/^[ \t]*//" | sed "s/-\ FOLLOWUP\ -\ //"`" >> $FOLLOWUP_FILE
        FUP_ID=$(expr $FUP_ID + 1)
    done
    /usr/bin/cat $FOLLOWUP_FILE
}

function todo_remove_followups(){
    echo "Removing Followup item"
}

function todo_manage_file(){
}

function todo(){
    if [[ -z $1 ]];then
        echo "What do you need todo?"
        read newtodo
        echo $newtodo >> $TODO_FILE
    else
        case $1 in
            clean)
                echo "" > $TODO_FILE
                ;;
            fup)
                echo "Here are your Followup items:"
                echo ""
                todo_check_followups
                ;;
            *)
                echo "I have no idea what you want me to do"
                ;;
        esac
    fi
}
