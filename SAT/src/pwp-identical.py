#!/usr/bin/env python

import os
import argparse
import time
from z3 import *
import numpy as np
from itertools import combinations
from tqdm.auto import tqdm
from typing import Sequence


# Functions encoding at-least-one and at-most-one constraints
def at_least_one(bool_vars: Sequence):
    return Or(bool_vars)


def at_most_one(bool_vars: Sequence):
    return [Not(And(pair[0], pair[1])) for pair in combinations(bool_vars, 2)]


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("-i", "--in_path", help="Path to the file constaining the input instance", required=True, type=str)
    parser.add_argument("-o", "--out_path", help="Path to the directory that will contain the output solution", required=True, type=str)
    parser.add_argument("-t", "--timeout", help="Timeout in seconds (300 by default)", required=False, type=int)
    parser.add_argument("-ic", "--implied", help="Don't use implied constraints (they're used by default)", action='store_false')
    args = parser.parse_args()

    # Read the input instance
    input_filename = args.in_path
    w, h, n, DX, DY = None, None, None, None, None
    with open(input_filename, 'r') as f_in:
        lines = f_in.read().splitlines()

        split = lines[0].split(' ')
        w = int(split[0])
        h = int(split[1])

        n = int(lines[1])

        DX = []
        DY = []

        for i in range(int(n)):
            split = lines[i + 2].split(' ')
            DX.append(int(split[0]))
            DY.append(int(split[1]))

    # Define solver and base model
    solver = Solver()
    B = [[[Bool(f'B_{i}_{j}_{k}') for k in range(n)] for j in range(w)] for i in range(h)]

    print('Adding constraints...')

    # Add constraint "at most one piece in each cell"
    for i in tqdm(range(h), leave=False):
        for j in range(w):
            solver.add(at_most_one(B[i][j]))
    
    # Group packages by dimensions
    indexes = {}
    for idx, dim in enumerate(zip(DX, DY)):
        if dim in indexes:
            indexes[dim] += [idx]
        else:
            indexes[dim] = [idx]

    # Iterate over all the dimensions
    for (dx, dy), p_list in indexes.items():
        if len(p_list) > 1:  # case 1: multiple identical pieces
            # Iterate over identical pieces in pairs
            for i in range(len(p_list) - 1):
                p1 = p_list[i]
                p2 = p_list[i + 1]

                package_clauses_p1 = {}
                package_clauses_p2 = {}
                package_clauses_joint = []

                # Iterate over all the coordinates where p can fit
                for i in range(h - dy + 1):
                    for j in range(w - dx + 1):

                        patch_clauses_p1 = []
                        patch_clauses_p2 = []
                        # Iterate over the cells of p's patch
                        for f1 in range(dy):
                            for f2 in range(dx):
                                patch_clauses_p1.append(B[i + f1][j + f2][p1])
                                patch_clauses_p2.append(B[i + f1][j + f2][p2])
                        
                        # (i+dy-1, j) bottom-left corner
                        package_clauses_p1[(i + dy - 1, j)] = And(patch_clauses_p1)
                        package_clauses_p2[(i + dy - 1, j)] = And(patch_clauses_p2)
                
                # Filter valid p2 clauses
                for (i1, j1), patch_p1 in package_clauses_p1.items():
                    # Condition for validity: i2 <= i1 and j2 >= j1
                    valid_patches_p2 = [patch_p2 for (i2, j2), patch_p2 in package_clauses_p2.items() if (i2 <= i1 and j2 >= j1)]
                    
                    package_clauses_joint.append(And(patch_p1, at_least_one(valid_patches_p2)))
                    
                solver.add(at_least_one(package_clauses_joint))
        else:  # case 2: unique piece
            p = p_list[0]
            package_clauses = []

            # Iterate over all the coordinates where p can fit
            for i in range(h - dy + 1):
                for j in range(w - dx + 1):

                    patch_clauses = []
                    # Iterate over the cells of p's patch
                    for f1 in range(dy):
                        for f2 in range(dx):
                            patch_clauses.append(B[i + f1][j + f2][p])

                    package_clauses.append(And(patch_clauses))

            solver.add(at_least_one(package_clauses))

    if args.implied:
        # Define auxiliary variables for implied constraints
        Sr = [[Bool(f'C_row_{i}_{j}') for j in range(w)] for i in range(w - 1)]
        Sc = [[Bool(f'C_col_{i}_{j}') for j in range(h)] for i in range(h - 1)]

        # Add implied constraint for rows
        for r in tqdm(range(h), leave=False):
            solver.add(Or(Not(at_least_one(B[r][0])), Sr[0][0]))  # SC1
            for j in range(1, w):
                solver.add(Not(Sr[0][j]))  # SC2
            for i in range(1, w - 1):
                solver.add(Or(Not(at_least_one(B[r][i])), Sr[i][0]))  # SC3
                solver.add(Or(Not(Sr[i - 1][0]), Sr[i][0]))  # SC4
                for j in range(1, w):
                    solver.add(Or(Not(at_least_one(B[r][i])), Not(Sr[i - 1][j - 1]), Sr[i][j]))  # SC5
                    solver.add(Or(Not(Sr[i - 1][j]), Sr[i][j]))  # SC6
                solver.add(Or(Not(at_least_one(B[r][i])), Not(Sr[i - 1][w - 1])))  # SC7
            solver.add(Or(Not(at_least_one(B[r][w - 1])), Not(Sr[w - 2][w - 1])))  # SC8

        # Add implied constraint for columns
        for c in tqdm(range(w), leave=False):
            solver.add(Or(Not(at_least_one(B[0][c])), Sc[0][0]))  # SC1
            for j in range(1, h):
                solver.add(Not(Sc[0][j]))  # SC2
            for i in range(1, h - 1):
                solver.add(Or(Not(at_least_one(B[i][c])), Sc[i][0]))  # SC3
                solver.add(Or(Not(Sr[i - 1][0]), Sc[i][0]))  # SC4
                for j in range(1, h):
                    solver.add(Or(Not(at_least_one(B[i][c])), Not(Sc[i - 1][j - 1]), Sc[i][j]))  # SC5
                    solver.add(Or(Not(Sc[i - 1][j]), Sc[i][j]))  # SC6
                solver.add(Or(Not(at_least_one(B[i][c])), Not(Sc[i - 1][h - 1])))  # SC7
            solver.add(Or(Not(at_least_one(B[h - 1][c])), Not(Sc[h - 2][h - 1])))  # SC8

    # Set timeout for solver (in msec)
    timeout = args.timeout * 1000 if args.timeout is not None else 300000
    solver.set('timeout', timeout)

    print('Checking the model...')
    start_time = time.time()
    res = solver.check()
    elapsed_time = time.time() - start_time
    print(f'Elapsed: {elapsed_time:.3f} s')

    if res == sat:
        print('The instance is SAT.')
        model = solver.model()
        
        # Create solution array
        solution = np.zeros((h, w, n), dtype=bool)
        for i in range(h):
            for j in range(w):
                for k in range(n):
                    solution[i, j, k] = is_true(model[B[i][j][k]])
        xy = {}
        for p in range(n):
            y_ids, x_ids = solution[:, :, p].nonzero()
            x = np.min(x_ids)
            y = h - 1 - np.max(y_ids)
            xy[p] = [x, y]

        # Write solution to file
        instance_name = input_filename.split('/')[-1]
        instance_name = instance_name[:len(instance_name) - 4]
        output_filename = os.path.join(args.out_path, instance_name + '-out.txt')
        with open(output_filename, 'w') as f_out:
            f_out.write(f'{w} {h}\n')
            f_out.write(f'{n}\n')
            for i in range(n):
                f_out.write(f'{DX[i]} {DY[i]}\t{xy[i][0]} {xy[i][1]}\n')
    else:
        print('The instance is UNSAT in the given time.')


if __name__ == '__main__':
    main()
