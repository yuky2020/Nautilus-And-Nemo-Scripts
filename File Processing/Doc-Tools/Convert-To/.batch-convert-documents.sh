#!/bin/bash 
# License: GPL
# Author: tongphe.org@gmail.com
HELP="A bash script which uses OpenOffice's (or LibreOffice) UNO bindings to convert many document formats to pdf, html...
    $(basename $0) [OPTION]... <PARAMETER=\"absolute paths of files/dirs passed by Nautilus\">
Options:
    -f
        output format (default format is 'pdf')
    -s
        convert documents then move output files to a sub dir
    -c
        copy log path to the clipboard (xclip)
    -r
        recursively convert all files in dirs (be careful)
    --format
        display supported formats of input and output file
    --help
        display help
Note: If you are running some office windows for some documents, this script will use the first window you opened as listener
to convert documents. If not you won't normally start office until all conversions finished
"
SUPPORTED_FORMATS="bib doc xml htm html odt ott ooxml pdf rtf ltx sdw stw sxw txt uot vor xhtml
csv dbf dif ods ots sdc slk stc sxc uos xls xlt
bmp emf eps gif jpg met odd otg pbm pct pgm png ppm ras std svg svm swf sxd tiff wmf xpm
odg odp otp pbm pct pot ppt pwp sda sdd sxd sti svg svm sxi uop
"

lower_str() {
    echo "$(echo "$1" | tr '[:upper:]' '[:lower:]')"
}

check_depend() {
    local miss=""

    for depend in $*; do
        if [ ! $(command -v $depend) ]; then
            miss="$miss $depend"
        fi
    done
    if [ "$miss" != "" ]; then
         zenity --error --text "Missing dependences:$miss"
        return 1
    fi
    return 0
}

get_previous_tasks() {
    local tasks_list="$(pgrep $PNAME)"

    for task in $tasks_list; do
        if [ $task -ne $$ ]; then
            previous_tasks_list="$previous_tasks_list $task"
        fi
    done
}

get_turn() {
    local tasks_list="$(pgrep $PNAME)"
    local tasks_left=0

    for pre_task in $previous_tasks_list; do
        if [[ $tasks_list =~ $pre_task ]]; then
            tasks_left=$[tasks_left + 1]
        fi
    done
    echo $tasks_left
}

# start OpenOffice instance as listener or connect to an existing one
start_listener() {
    if [[ $(pgrep soffice)  && ! $(fuser $OWN_PORT/tcp) ]]; then
        port=$USER_PORT    # user are running some office windows
    else
        port=$OWN_PORT
    fi
    # start own listener or make the existing instance listen
    soffice -headless -accept="socket,host=localhost,port=$port;urp;"
    sleep 0.5
}

# stop OpenOffice listener
stop_listener() {
    if [ $port -eq $OWN_PORT ]; then
        pkill soffice
        sleep 0.5
        killall -9 soffice.bin
    fi
}

# check files which are the same name and format: return 0 - the same, return 1 - different
compare_filename() {
    local lower_file1="$(lower_str "$(basename "$1")")"
    local lower_file2="$(lower_str "$(basename "$2")")"
    if [ "$lower_file1" == "$lower_file2" ]; then
        echo 0
    else
        echo 1
    fi
}

# add a file path to files list
files_list_add() {
    if [ -f "$1" ]; then
        size=$[size + $(stat -c %s "$1")]
        files_amount=$[files_amount + 1]
        files_list[files_amount]="$1"
    fi
}

# add a dir path to dirs list
dir_list_add() {
    if [ -d "$1" ]; then
        dirs_amount=$[$dirs_amount + 1]
        dirs_list[dirs_amount]="$1"
    fi
}

scan_dir() {
    local dir="$1"
    
    dir_list_add "$dir"
    dir_files_list_index[dirs_amount]=$[files_amount + 1]
    for file in $(find -L "$dir" -maxdepth 1  -type f | sort); do
        files_list_add "$file"
    done
    if [ "$RECURSION_OPT" == "true" ]; then
        for folder in $(find -L "$dir"  -maxdepth 1 -type d | sort); do
            if [ "$dir" != "$folder" ]; then
                scan_dir "$folder"
            fi
        done
    fi
}

# init files/dirs list and resolve spaces in filenames in argument
init_files_list() {
    for file in $(echo -e "$*" | sort); do
        if [ -f "$file" ]; then
            files_list_add "$file"
        fi
    done
    
    if [ "${files_list[1]}" != "" ]; then 
        dirs_list[1]="$(dirname "${files_list[1]}")"
    fi
    
    for folder in $(echo -e "$*" | sort); do
        if [ -d "$folder" ]; then
            scan_dir "$folder"
        fi
    done
    
    if [ "${dirs_list[1]}" == "" ]; then
        dirs_list[1]="$(dirname "${dirs_list[2]}")"
    fi
    
    dir_files_list_index[dirs_amount + 1]=$[files_amount + 1]
}

init_icon() {
    local icon="dialog-information"

    case $1 in
        pdf)
            icon="application-pdf";;
        html)
            icon="text-html";;
        #----more icons here----
    esac
    echo $icon
}

check_supported_format() {
    local format=${1##*.}
    local supported=1

    format=$(lower_str $format)
    if [ "$format" != "" ]; then
        for s_format in $SUPPORTED_FORMATS; do
            if [ "$s_format" == "$format" ]; then
                supported=0
                break
            fi
        done
    fi
    echo $supported
}

# convert documents and show progress as progressbar
convert_documents() {
    local start_index=0
    local end_index=0
    local folder_log=""
    local percents=0
    local file_size=0
    local dir_show=""
    local dir_work=""
    local sub_folder=""
    local dir_files_amount=0
    local dir_failed_files_amount=0
    local canceled_dir=1
    local canceled_file=1
    local turn=0
    
    (    
    # wait for previous tasks done
    turn=$(get_turn)
    while [ $turn -gt 0 ]; do
        echo "#Waiting for previous tasks (*$turn left)"
        sleep 1
        turn=$(get_turn)
    done

    for ((index=1; index<=$dirs_amount; index++)); do
        start_index=${dir_files_list_index[index]}
        end_index=$[${dir_files_list_index[index + 1]} - 1]
        dir_files_amount=$[end_index - start_index + 1]
        dir_failed_files_amount=0
        folder_log=""

        if [ $start_index -gt $end_index ]; then
            log="$log\n\n${dirs_list[index]}\nselected:$dir_files_amount successful:$[dir_files_amount - dir_failed_files_amount] failed:$dir_failed_files_amount"
            continue
        fi
        
        dir_work="${dirs_list[index]}"
        # check dir write permission
        if [ ! -w "$dir_work" ]; then
            log="$log\n\n${dirs_list[index]}\nselected:$dir_files_amount successful:$[dir_files_amount - dir_failed_files_amount] failed:$dir_failed_files_amount\nPermission denied!"
            failed_files_amount=$[failed_files_amount + dir_files_amount]
            continue
        fi
        # relative path showed on progressbar
        if [ $index -eq 1 ]; then
            dir_show="."
        else
            dir_show=".${dir_work/"${dirs_list[1]}"}"
        fi
        # determine sub folder name based on parent dir
        if [ "$SUB_FOLDER_OPT" == "true" ]; then
            sub_folder="$(basename "$dir_work")_$output_format"
            mkdir "$dir_work/$sub_folder"
        fi

        for ((i=$start_index; i<=$end_index; i++)); do
            file="${files_list[i]}"
            output_file="${file%.*}.$output_format"
            # check input files removed during the conversion
            if [ ! -f "$file" ]; then
                folder_log="$folder_log\n$file (*file removed)"
                dir_failed_files_amount=$[dir_failed_files_amount + 1]
                continue
            fi
            # compute progress percents
            file_size=$(stat -c %s "$file")
            if [ $size -eq 0 ]; then
                percents=99
            else
                percents=$[percents + $[file_size/size]]
            fi

            # ignore input files which are the same format as output files
            if [ $(compare_filename "$file" "$output_file") -eq 0 ]; then
                echo "$percents"
                folder_log="$folder_log\n$file (*the same format)"
                dir_failed_files_amount=$[dir_failed_files_amount + 1]
                continue
            fi
            # ignore input files whose format not supported
            if [ $(check_supported_format "$file") -eq 1 ]; then
                echo "$percents"
                folder_log="$folder_log\n$file (*format not supported)"
                dir_failed_files_amount=$[dir_failed_files_amount + 1]
                continue
            fi
            # start converting documents
            echo "#$[i - start_index + 1]/$dir_files_amount $i/$files_amount: $dir_show/$(basename "$file")..."
            unoconv -c "socket,host=localhost,port=$port;urp;StarOffice.ComponentContext" -f $output_format "$file"
            # check conversion result
            if [ ! -f "$output_file" ]; then
                folder_log="$folder_log\n$file (*office listener stopped)"
                dir_failed_files_amount=$[dir_failed_files_amount + 1]
            else
                folder_log="$folder_log\n$file"
                if [ "$SUB_FOLDER_OPT" == "true" ]; then
                    mv "$output_file" "$dir_work/$sub_folder"
                fi
                canceled_file=$[i + 1]
            fi
            echo "$percents"
        done
        canceled_dir=$[index + 1]
        # remove empty sub dirs
        if [ "$SUB_FOLDER_OPT" == "true" ]; then
            rmdir "$dir_work/$sub_folder"
        fi
        log="$log\n\n${dirs_list[index]}\nselected:$dir_files_amount successful:$[dir_files_amount - dir_failed_files_amount] failed:$dir_failed_files_amount$folder_log"
        failed_files_amount=$[failed_files_amount + dir_failed_files_amount]
    done        
    log="Convert documents to $output_format\nWorking directory: ${dirs_list[1]}\nSelected:$files_amount Successful:$[files_amount - failed_files_amount] Failed:$failed_files_amount $log"
    # write log, notify the result and copy log path to the clipboard
    echo -e "$log" > "$log_path"
    notify_result $files_amount $failed_files_amount $icon $log_path
    if [ "$CLIPBOARD_OPT" == "true" ]; then
        echo "$log_path" | xclip -selection clipboard
    fi
    # close progressbar
    echo "100"
    ) | zenity --progress --title="Converting !" --auto-close
    
    # check conversion canceled
    if [ $? -eq 1 ] ; then
        if [ $turn -gt 0 ]; then
            return 1
        fi
        dir_files_amount=$[${dir_files_list_index[canceled_dir + 1]} - ${dir_files_list_index[canceled_dir]}]
        for((i=$canceled_file; i<${dir_files_list_index[canceled_dir + 1]}; i++)); do
            folder_log="$folder_log\n${files_list[i]} (*canceled)"
            dir_failed_files_amount=$[dir_failed_files_amount + 1]
        done
        failed_files_amount=$[failed_files_amount + dir_failed_files_amount]
        log="$log\n\n${dirs_list[canceled_dir]}\nselected:$dir_files_amount successful:$[dir_files_amount - dir_failed_files_amount] failed:$dir_failed_files_amount$folder_log"
        for((i=$[canceled_dir + 1]; i<=$dirs_amount; i++)); do
            start_index=${dir_files_list_index[i]}
            end_index=$[${dir_files_list_index[i + 1]} - 1]
            dir_files_amount=$[end_index - start_index + 1]
            dir_failed_files_amount=0
            folder_log=""

            for ((j=$start_index; j<=$end_index; j++)); do
                folder_log="$folder_log\n${files_list[j]} (*canceled)"
                dir_failed_files_amount=$[dir_failed_files_amount + 1]
            done
            failed_files_amount=$[failed_files_amount + dir_failed_files_amount]
            log="$log\n\n${dirs_list[canceled_dir]}\nselected:$dir_files_amount successful:$[dir_files_amount - dir_failed_files_amount] failed:$dir_failed_files_amount$folder_log"
        done
        log="Convert documents to $output_format\nWorking directory: ${dirs_list[1]}\nSelected:$files_amount Successful:$[files_amount - failed_files_amount] Failed:$failed_files_amount $log"
        
        # write log, notify the result and copy log path to the clipboard
        echo -e "$log" > "$log_path"
        notify_result $files_amount $failed_files_amount $icon $log_path
        if [ "$CLIPBOARD_OPT" == "true" ]; then
            echo "$log_path" | xclip -selection clipboard
        fi
    fi
    return 0
}

plural_check() {
    local amount=$1
    local name=$2

    if [ $amount -gt 1 ]; then
        name="${name}s"
    fi
    echo "$name"
}

# notify the result
notify_result() {
    local files_amount=$1
    local failed_files_amount=$2
    local icon="$3"
    local log_path="$4"
    local documents="$(plural_check $files_amount document)"
    local failed_documents="$(plural_check $failed_files_amount document)"
    local msg=""

    if [ $files_amount -eq $failed_files_amount ]; then
        icon="dialog-error"
        msg="Failed to convert all documents!"
    elif [ $failed_files_amount -eq 0 ]; then
        msg="Successfully converted $files_amount $documents!"
    else
        msg="Successfully converted $[files_amount - failed_files_amount] $documents. Failed to convert $failed_files_amount $failed_documents!"
    fi
    if [ "$CLIPBOARD_OPT" == "true" ]; then
        msg="$msg. Log path is copied to the clipboard"
    else
        msg="$msg. Log is written $log_path"
    fi
    notify-send -i "$icon" "Convert $documents" "$msg"
}

# ------------MAIN-----------------
files_amount=0
dirs_amount=1    # the first one is current dir
files_list[1]=""    # selected and scanned files paths in array, index starts from 1
dirs_list[1]=""    # selected and scanned dir paths in array, index starts from 1, start of array is current dir
dir_files_list_index[1]=1

size=0    # size of all files
log_path="/tmp/$(date +%H:%M:%S_%d-%m-%y_convert-documents.log)"

PNAME=""    # current process name
OWN_PORT=8100
USER_PORT=2002
port=0
previous_tasks_list=""

# -----------INIT Options and Parameters--------------
SUB_FOLDER_OPT="false"
CLIPBOARD_OPT="false"
RECURSION_OPT="false"
output_format="pdf"

PNAME="$(basename $0)"
PNAME="${PNAME:0:15}"

if [ $# -eq 0 ]; then
    echo "Type '$(basename "$0") --help' for more information."
    exit
elif [ $# -eq 1 ]; then
    case $1 in
        --help)
            echo "$HELP"
            exit;;
        --format)
            echo -e "Supported formats of input and output file:\n$SUPPORTED_FORMATS"
            exit;;
    esac
fi

while getopts "f:src-" opt; do
    case $opt in
        s)
            SUB_FOLDER_OPT="true";;
        f)
            output_format=$(lower_str $OPTARG);;
        r)
            RECURSION_OPT="true";;
        c)
            CLIPBOARD_OPT="true";;
        -)
            echo "Type '$(basename "$0") --help' for more information."
            exit;;
        \?)
            echo "Type '$(basename "$0") --help' for more information."
            exit;;
    esac
done

shift $(($OPTIND - 1))
# ----------------------------------------------------------------------

get_previous_tasks
check_depend unoconv notify-send xclip zenity fuser soffice
if [ $? -eq 1 ]; then
    exit
fi

if [ $(check_supported_format ".$output_format") -ne 0 ]; then
    zenity --error --text "Output format not supported!"
    exit
fi

SAVEIFS=$IFS
IFS=$(echo -en "\n\b")
init_files_list $*
IFS=$SAVEIFS

if [ $files_amount -eq 0 ]; then
    zenity --error --text "No file scanned!"
    exit
fi

icon=$(init_icon $output_format)

# start converting documents
start_listener

log=""
failed_files_amount=0
size=$[size/100]

convert_documents
# if [ $? -eq 0 ]; then
#     # write log, notify the result and copy log path to the clipboard
#     echo -e "$log" > "$log_path"
#     notify_result $files_amount $failed_files_amount $icon $log_path
#     if [ "$CLIPBOARD_OPT" == "true" ]; then
#         echo "$log_path" | xclip -selection clipboard
#     fi
# fi

# share listener with next tasks
if [ $(pgrep $PNAME | wc -l) -lt 3 ]; then
    stop_listener
fi
