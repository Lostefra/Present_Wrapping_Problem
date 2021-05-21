#!/bin/bash

cores=$1
if [[ cores -eq "" ]]
then
    cores=1
fi
echo "Using $cores cores"
for n in $(seq 20); do
    echo -e "\tTest input_order/indomain_min with N=$n"
    for _ in $(seq 5); do
        minizinc --solver Gecode -p $cores -t 120000 --solver-statistics src/pwp-final.mzn "in/${n}x${n}.dzn" -D mode=1 | grep -E 'solveTime|solutions|failures'
    done
    echo -e "\tTest first_fail/indomain_min with N=$n"
    for _ in $(seq 5); do
        minizinc --solver Gecode -p $cores -t 120000 --solver-statistics src/pwp-final.mzn "in/${n}x${n}.dzn" -D mode=2 | grep -E 'solveTime|solutions|failures'
    done
    echo -e "\tTest dom_w_deg/indomain_min with N=$n" 
    for _ in $(seq 5); do
        minizinc --solver Gecode -p $cores -t 120000 --solver-statistics src/pwp-final.mzn "in/${n}x${n}.dzn" -D mode=3 | grep -E 'solveTime|solutions|failures'
    done
    echo -e "\tTest input_order/indomain_random with N=$n" 
    for _ in $(seq 5); do
        minizinc --solver Gecode -p $cores -t 120000 --solver-statistics src/pwp-final.mzn "in/${n}x${n}.dzn" -D mode=4 | grep -E 'solveTime|solutions|failures'
    done
    echo -e "\tTest dom_w_deg/indomain_random with N=$n" 
    for _ in $(seq 5); do
        minizinc --solver Gecode -p $cores -t 120000 --solver-statistics src/pwp-final.mzn "in/${n}x${n}.dzn" -D mode=5 | grep -E 'solveTime|solutions|failures'
    done
done
