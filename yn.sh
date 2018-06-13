#!/bin/bash
defval="y"
yn(){
        read -ep "$1? [y/n]: " -i $defval sure
        while [[ "$sure" != "y"* ]] && [[ "$sure" != "n"* ]];
        do
                read -p "$1? [y/n]: " sure
        done;
        if [[ $sure == "y"* ]];then
                return 0
        else
                return 1
        fi;
}

