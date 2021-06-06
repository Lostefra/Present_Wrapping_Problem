# Present_Wrapping_Problem
SAT implementation of the PWP.

## Authors
* [Lorenzo Mario Amorosa](https://github.com/Lostefra)
* [Mattia Orlandi](https://github.com/nihil21)
* [Giacomo Pinardi](https://github.com/GiacomoPinardi)

### SAT
The SAT folder contains 3 subfolders:

- `benchmark`, containing all the bash scripts to run the benchmarks and all the corresponding results in .txt (you must run them from the `SAT` folder);
- `out`, containing the solutions to the instances in .txt;
- `src`, containing all the models developed:
    - the main ones:
        - the final one is `pwp-final.py` (to know how to use it: `python pwp-final.py --help`);
        - the one for taking into account rotation is `pwp-rotation.py` (to know how to use it: `python pwp-rotation.py --help`);
        - the one for taking into account identical pieces is `pwp-identical.py` (to know how to use it: `python pwp-identical.py --help`);
    - the corresponding Jupyter notebooks used for data exploration:
        - the final one is `pwp-final.ipynb`;
        - the one for taking into account rotation is `pwp-rotation.ipynb`;
        - the one for taking into account identical pieces is `pwp-identical.ipynb`.
