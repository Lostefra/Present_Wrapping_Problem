# Present_Wrapping_Problem
CP, SAT and SMT implementation of the PWP

## Authors
* [Lorenzo Mario Amorosa](https://github.com/Lostefra)
* [Mattia Orlandi](https://github.com/nihil21)
* [Giacomo Pinardi](https://github.com/GiacomoPinardi)

## Project structure
The project is structured in 5 folders:

- `CP`, which contains the report and the code related to the CP implementation;
- `SAT`, which contains the report and the code related to the SAT implementation;
- `SMT`, which contains the report and the code related to the SMT implementation;
- `Instances`, which contains all the 33 instances in .txt files;
- `pwp_utilities`, which contains three python scripts:
    - `instance_to_dzn.py` to convert the instance from .txt to .dzn (usage: `python instance_to_dzn.py <input_file> <output_file>`);
    - `plot_solution.py` to generate an image of a given solution (usage: `python plot_solution.py -f <file_name>`);
    - `solve_all_cp_instances.py` to generate one solution for each instance (to know how to use it: `python solve_all_cp_instances.py --help`).

### CP
The CP folder contains 4 subfolders:

- `benchmark`, containing all the bash scripts to run the benchmarks and all the corresponding results in .txt (you can run them from the `CP` folder);
- `in`, containing the instances in .dzn;
- `out`, containing the solutions to the instances in .txt;
- `src`, containing all the models developed, mainly:
    - the best one in `pwp-final.mzn`;
    - the one for taking into account rotation is `pwp-rotation.mzn`;
    - the one for taking into account identical pieces is `pwp-identical.mzn`.

### SAT
- `benchmark`, containing all the bash scripts to run the benchmarks and all the corresponding results in .txt (you can run them from the `SAT` folder);
- `out`, containing the solutions to the instances in .txt;
- `src`, containing all the models developed:
    - the best one in `pwp-final.py` (to know how to use it: `python pwp-final.py --help`);
    - the one for taking into account rotation is `pwp-rotation.py` (to know how to use it: `python pwp-rotation.py --help`);
    - the one for taking into account identical pieces is `pwp-identical.py` (to know how to use it: `python pwp-identical.py --help`).

### SMT
TODO