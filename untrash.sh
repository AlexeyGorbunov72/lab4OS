findAllfiles(){ # $1 -- name of file
    lines=$(grep $1 /Users/Retard/lab/trash.log)
    echo $lines
    counter=0
    id=0
    oldPath=""
    for word in $lines; do
        if [[ $(($counter % 3)) == "0" ]]; then
            id=$word
        fi
    
        if [[ $(($counter % 3)) == "1" ]]; then
            oldPath=$word
        fi
    
        if [[ $(($counter % 3)) == "2" ]]; then
            isItYourFile $id $oldPath $name
        fi
        
        let "counter = counter + 1"
    done
}
isItYourFile(){ # $1 id $2 old path $3 name
    name=$3
    oldPath=$2
    id=$1
    echo "for unwarp to rm's type 'unwarp'"
    echo "Enter path to unwarp: "
    read pathUnwarp
    unwarp "$id" "$pathUnwarp/$name"
    while [[ "$?" != "0" ]]; do
        echo "please choose new name for that file"
        read newName
        unwarp "$id" "$pathUnwarp/$newName"
    done
    (deleteFromLog "$id $oldPath $name") && (deleteFromStorage "$id")
}

unwarp(){ # $1 index of file $2 path to unwarp + name
    ln "/Users/Retard/lab/.storage/$1" "$2"
}

deleteFromStorage(){ # $1 index of file
    rm "/Users/Retard/lab/.storage/$1"
}

deleteFromLog(){ # $1 line
    echo "" > tmp
    for line in /Users/Retard/lab/trash.log; do
        if [[ line != $1 ]]; then
            echo $line >> tmp
        fi
    done
    cat tmp > /Users/Retard/lab/trash.log
    rm tmp
}

findAllfiles "$1"
