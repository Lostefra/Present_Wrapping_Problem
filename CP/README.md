# Present_Wrapping_Problem
CP implementation of the PWP.

## Authors
* [Lorenzo Mario Amorosa](https://github.com/Lostefra)
* [Mattia Orlandi](https://github.com/nihil21)
* [Giacomo Pinardi](https://github.com/GiacomoPinardi)

### CP
The CP folder contains 4 subfolders:

- `benchmark`, containing all the bash scripts to run the benchmarks and all the corresponding results in .txt (you must run them from the `CP` folder);
- `in`, containing the instances in .dzn;
- `out`, containing the solutions to the instances in .txt;
- `src`, containing all the models developed:
    - the main ones:
        - the final one is `pwp-final.mzn`;
        - the one for taking into account rotation is `pwp-rotation.mzn`;
        - the one for taking into account identical pieces is `pwp-identical.mzn`;
    - the naive ones:
        - the naive model is `pwp-naive.mzn`;
        - the dual model is `pwp-dual.mzn`.
