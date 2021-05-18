#!/bin/bash

cores=$1
if [[ cores -eq "" ]]; then
    cores=1
fi
echo "Using $cores cores"

for n in $(seq 10 15); do
    echo -e "\tTest naive model with N=$n"
    for _ in $(seq 5); do
	    minizinc --solver Gecode -p $cores -a -t 60000 --solver-statistics src/pwp-naive.mzn "in/${n}x${n}.dzn" | grep -E 'solveTime|solutions|failures'
    done
    echo -e "\tTest dual model with N=$n"
    for _ in $(seq 5); do
	    minizinc --solver Gecode -p $cores -a -t 60000 --solver-statistics src/pwp-dual.mzn "in/${n}x${n}.dzn" | grep -E 'solveTime|solutions|failures'
    done
    echo -e "\tTest final model (no symmetry breaking) with N=$n"
    for _ in $(seq 5); do
	    minizinc --solver Gecode -p $cores -a -t 60000 --solver-statistics src/pwp-final.mzn "in/${n}x${n}.dzn" -D mzn_ignore_symmetry_breaking_constraints=true | grep -E 'solveTime|solutions|failures'
    done
    echo -e "\tTest final model (symmetry breaking) with N=$n"
    for _ in $(seq 5); do
	    minizinc --solver Gecode -p $cores -a -t 60000 --solver-statistics src/pwp-final.mzn "in/${n}x${n}.dzn" | grep -E 'solveTime|solutions|failures'
    done
done
