#!/bin/bash

for n in $(seq 31 40); do
    echo -e "\tTest model with N=$n"
    python3 src/pwp-final.py -i "../Instances/${n}x${n}.txt" -o out/ -t 3600 | grep -E 'Elapsed|instance'
done
