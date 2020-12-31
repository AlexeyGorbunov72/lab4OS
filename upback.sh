file=$(ls /Users/Retard/lab/backup | tail -1)

if [[ -n $file ]]
then
    awk -v f=$file 'BEGIN{flag=0}{
        if ($2 == f)
            flag = 1
        if (flag == 1)
        {
            if ($1 == "Copy:")
                print $2
        }
    }' /Users/Retard/lab/backup-report | {
        add=$(awk '{print $0}')

        for i in $add
        do
            cp /Users/Retard/lab/backup/$file/$i /Users/Retard/lab/restore/
        done
    }
else
    echo "Not exist backup"
fi
