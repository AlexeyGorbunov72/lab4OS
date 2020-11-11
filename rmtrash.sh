checkTrashDir(){
    buff=$(ls -a ~/lab/ | grep .trash)
    if [[ $buff != ".trash" ]]; then
        mkdir ~/lab/.trash
    fi
}
addLog(){ # $1 -- uid; $2 -- path; $3 -- name.extension
    echo "$1 $2 $3" >> /Users/Retard/lab/trash.log
}
createHardLink(){
    if [[ $# -ne 1 ]]; then
        exit -1
    fi
    id=$(cat /Users/Retard/lab/.config)
    echo $id
    id="$(($id + 1))"
    echo "$id" > /Users/Retard/lab/.config
    path=$(pwd)
    ln "$path/$1" "/Users/Retard/lab/.storage/$id"
    if [[ "$?" == "0" ]]; then
        addLog "$id" "$path" "$1"
        rm "$path/$1"
    fi
    
}


createHardLink "$1"
