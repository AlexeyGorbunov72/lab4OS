
function newBackup {
    file=$(echo "Backup-"$(date +"%Y-%m-%d-%M"))
    mkdir /Users/Retard/lab/backup/$file
    echo "Create: "$file >> /Users/Retard/lab/backup-report
    
    for i in $(ls /Users/Retard/lab/source)
    do
        check=$(file /Users/Retard/lab/source/$i | awk '{print $2}')
        
        if [[ "$check" != "directory" ]]
        then
            cp /Users/Retard/lab/source/$i /Users/Retard/lab/backup/$file/$i
            echo "Copy: " $i >> /Users/Retard/lab/backup-report
        fi
    done
}
find /Users/Retard/lab/source > /dev/null 2> /dev/null
if [[ $? -ne 0 ]]; then
    echo "cant find source"
    exit -1
fi
last_file=$(ls /Users/Retard/lab/backup | tail -1)

if [[ -z $last_file ]]
then
    newBackup
else
    file=$(echo "Backup-"$(date +"%Y-%m-%d-%M"))

    date1=$(echo $last_file | awk -F "-" '{print $5}')
    date2=$(echo $file | awk -F "-" '{print $5}')
    delta=$(echo $date2"-"$date1 | bc)
    if [[ $delta -ge 5 ]]
    then
        newBackup
    else
        flag="0"
        touch buffer1
        touch buffer2

        for i in $(ls /Users/Retard/lab/source/)
        do
            find /Users/Retard/lab/backup/$last_file/$i -type f 2> /dev/null > /dev/null

            if [[ $? == "1" ]]
            then
                if [[ $flag == "0" ]]
                then
                    echo "Update: "$last_file  $(date +"%Y-%m-%d-%M") >> /Users/Retard/lab/backup-report
                    flag="1"
                fi

                cp /Users/Retard/lab/source/$i /Users/Retard/lab/backup/$last_file/$i
                echo "Copy: " $i >> buffer1
            else
                size1=$(wc -c /Users/Retard/lab/backup/$last_file/$i | awk '{print $1}')
                size2=$(wc -c /Users/Retard/lab/source/$i | awk '{print $1}')

                if [[ $size1 -ne $size2 ]]
                then
                    if [[ $flag == "0" ]]
                    then
                        echo "Update: "$last_file  $(date +"%Y-%m-%d-%M") >> /Users/Retard/lab/backup-report
                        flag="1"
                    fi

                    mv /Users/Retard/lab/backup/$last_file/$i /Users/Retard/lab/backup/$last_file/$i"."$(echo $last_file | awk -F "-" '{print $2"-"$3"-"$4"-"$5}')
                    cp /Users/Retard/lab/source/$i /Users/Retard/lab/backup/$last_file/$i

                    echo "New: "$i  $i"."$(echo $last_file | awk -F "-" '{print $2"-"$3"-"$4"-"$5}') >> buffer2
                fi
            fi
        done

        cat buffer1 >> /Users/Retard/lab/backup-report
        cat buffer2 >> /Users/Retard/lab/backup-report

        rm buffer1
        rm buffer2
    fi
fi
