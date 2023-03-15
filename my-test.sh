# !/bin/bash
if [ "$1" = "-c" ]; then
    cd baselines/hgs_vrptw
    make clean
    make all
    cd ../..
fi

echo "File name, HGS, Hill Climbing" > data.csv

cnt=0
for file in instances/*.txt
do 
    if [ $cnt -eq 20 ]; then
        break
    fi
    echo $file

    echo -n $file >> data.csv
    python controller.py --instance $file \
    --epoch_tlim 5 \
    -- python solver.py --strategy random --static > output.txt

    for data in $(grep "Cost of solution" output.txt | awk '{print $4}') 
    do 
        echo -n ", $data" >> data.csv
    done

    python controller.py --instance $file \
    --epoch_tlim 5 \
    -- python solver.py --strategy random --static --hill_climbing > output.txt

    for data in $(grep "Cost of solution" output.txt | awk '{print $4}') 
    do 
        echo -n ", $data" >> data.csv
    done
    echo "" >> data.csv

    rm output.txt
    echo ""
    cnt=$((cnt+1))
done