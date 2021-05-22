#!/bin/bash

cores=$1
if [[ cores -eq "" ]]
then
    cores=1
fi
echo "Using $cores cores"
for n in $(seq 15 20); do
    echo -e "\tTest input_order/indomain_min with N=$n"
    for _ in $(seq 5); do
        minizinc --solver Gecode -p $cores -t 120000 --solver-statistics src/pwp-final.mzn "in/${n}x${n}.dzn" -D hs_mode=1 | grep -E 'solveTime|solutions|failures'
    done
    echo -e "\tTest first_fail/indomain_min with N=$n"
    for _ in $(seq 5); do
        minizinc --solver Gecode -p $cores -t 120000 --solver-statistics src/pwp-final.mzn "in/${n}x${n}.dzn" -D hs_mode=2 | grep -E 'solveTime|solutions|failures'
    done
    echo -e "\tTest dom_w_deg/indomain_min with N=$n" 
    for _ in $(seq 5); do
        minizinc --solver Gecode -p $cores -t 120000 --solver-statistics src/pwp-final.mzn "in/${n}x${n}.dzn" -D hs_mode=3 | grep -E 'solveTime|solutions|failures'
    done
    echo -e "\tTest input_order/indomain_random with N=$n" 
    for _ in $(seq 5); do
        minizinc --solver Gecode -p $cores -t 120000 --solver-statistics src/pwp-final.mzn "in/${n}x${n}.dzn" -D hs_mode=4 | grep -E 'solveTime|solutions|failures'
    done
    echo -e "\tTest dom_w_deg/indomain_random with N=$n" 
    for _ in $(seq 5); do
        minizinc --solver Gecode -p $cores -t 120000 --solver-statistics src/pwp-final.mzn "in/${n}x${n}.dzn" -D hs_mode=5 | grep -E 'solveTime|solutions|failures'
    done
done
