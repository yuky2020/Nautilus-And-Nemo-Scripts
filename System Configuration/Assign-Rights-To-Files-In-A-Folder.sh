!#/bin/bash


# SIVIA81 :
# GPL     :
# assign rights to files in a folder 1.0 :


path="$@"
find "$@" -name "*"."*" -exec chmod 777 "{}" "{}" \; | (zenity --progress --pulsate --auto-close --title="chmod 777" --text="$fails")

