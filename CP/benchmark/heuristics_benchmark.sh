#!/bin/bash

cores=$1
if [[ cores -eq "" ]]
then
    cores=1
fi
echo "Using $cores cores"
for n in 8 9 10 11 12 13; do
    echo -e "\tTest naive model with N=$n"
    minizinc --solver Gecode -a -p $cores --solver-statistics src/pwp-naive.mzn "in/${n}x${n}.dzn" | grep -E 'solutions|failures'
    echo -e "\tTest dual model with N=$n"
    minizinc --solver Gecode -a -p $cores --solver-statistics src/pwp-dual.mzn "in/${n}x${n}.dzn" -D mzn_ignore_symmetry_breaking_constraints=true | grep -E 'solutions|failures'
    echo -e "\tTest dual model + symmetry breaking with N=$n"
    minizinc --solver Gecode -a -p $cores --solver-statistics src/pwp-dual.mzn "in/${n}x${n}.dzn" | grep -E 'solutions|failures'
done
