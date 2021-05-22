#!/bin/bash

cores=$1
if [[ cores -eq "" ]]
then
    cores=1
fi
echo "Using $cores cores"
for n in $(seq 20 25); do
    echo -e "\tTest constant restart with N=$n"
    for _ in $(seq 5); do
        minizinc --solver Gecode -p $cores -t 180000 --solver-statistics src/pwp-final.mzn "in/${n}x${n}.dzn" -D r_mode=1 | grep -E 'solveTime|solutions|failures'
    done
    echo -e "\tTest geometric restart with N=$n"
    for _ in $(seq 5); do
        minizinc --solver Gecode -p $cores -t 180000 --solver-statistics src/pwp-final.mzn "in/${n}x${n}.dzn" -D r_mode=2 | grep -E 'solveTime|solutions|failures'
    done
    echo -e "\tTest Luby restart with N=$n" 
    for _ in $(seq 5); do
        minizinc --solver Gecode -p $cores -t 180000 --solver-statistics src/pwp-final.mzn "in/${n}x${n}.dzn" -D r_mode=3 | grep -E 'solveTime|solutions|failures'
    done
done
