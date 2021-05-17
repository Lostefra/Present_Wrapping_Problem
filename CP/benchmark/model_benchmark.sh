#!/bin/bash

cores=$1
if [[ cores -eq "" ]]; then
    cores=1
fi
echo "Using $cores cores"

for n in 10 11 12 13 14 15 16; do
    echo -e "\tTest naive model with N=$n"
    for _ in $(seq 5); do
	    minizinc --solver Gecode -p $cores --solver-statistics src/pwp-naive.mzn "in/${n}x${n}.dzn" | grep -E 'solveTime|failures'
    done
    echo -e "\tTest dual model with N=$n"
    for _ in $(seq 5); do
	    minizinc --solver Gecode -p $cores --solver-statistics src/pwp-dual.mzn "in/${n}x${n}.dzn" | grep -E 'solveTime|failures'
    done
    echo -e "\tTest final model with N=$n"
    for _ in $(seq 5); do
	    minizinc --solver Gecode -p $cores --solver-statistics src/pwp-final.mzn "in/${n}x${n}.dzn" | grep -E 'solveTime|failures'
    done
done
