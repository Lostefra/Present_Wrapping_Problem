#!/bin/bash

for n in $(seq 20 25); do
    echo -e "\tTest model with N=$n"
    for _ in $(seq 5); do
        python3 src/pwp-final.py -i "../Instances/${n}x${n}.txt" -o out/ -ic | grep -E 'Elapsed|instance'
    done
    echo -e "\tTest model + implied constraints with N=$n"
    for _ in $(seq 5); do
        python3 src/pwp-final.py -i "../Instances/${n}x${n}.txt" -o out/ | grep -E 'Elapsed|instance'
    done
done
