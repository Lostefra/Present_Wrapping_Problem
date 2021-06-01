#!/usr/bin/env python

import os
import argparse
import time
from z3 import *
from itertools import combinations
from typing import Sequence


# Cumulative constraint
def cumulative(solver, S: Sequence, D: Sequence, R: Sequence, C: int):
    # Iterate over the durations
    for u in D:
        solver.add(
            Sum(
                [If(And(S[i] <= u, u < S[i] + D[i]), R[i], 0) for i in range(len(S))]
            ) <= C)


# Validity function for identical pieces
def is_valid(x_i, y_i, x_j, y_j, dx, dy):
    right = And(x_j >= x_i + dx, y_j >= y_i)
    up = And(y_j >= y_i + dy, x_j >= x_i)
    return Or(right, up)


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
    XY = [(Int(f'XY_{i}_0'), Int(f'XY_{i}_1')) for i in range(n)]

    print('Adding constraints...')

    # Non-overlapping constraint
    for (i, j) in combinations(range(n), 2):
        solver.add(Or(XY[i][0] + DX[i] <= XY[j][0], 
                    XY[j][0] + DX[j] <= XY[i][0],
                    XY[i][1] + DY[i] <= XY[j][1],
                    XY[j][1] + DY[j] <= XY[i][1]))

    # Boundaries consistency constraint
    for i in range(n):
        solver.add(XY[i][0] >=0)
        solver.add(XY[i][1] >= 0)
        solver.add(XY[i][0] + DX[i] <= w)
        solver.add(XY[i][1] + DY[i] <= h)

    if args.implied:
        # Implied constraints
        cumulative(solver,
                S=list(map(lambda t: t[0], XY)),  # take x coordinates
                D=DX,
                R=DY,
                C=h)
        cumulative(solver,
                S=list(map(lambda t: t[1], XY)),  # take y coordinates
                D=DY,
                R=DX,
                C=w)
    else:
        print('Implied constraints disabled.')
    
    for (i, j) in combinations(range(n), 2):
        solver.add(Or(Not(And(DX[i] == DX[j], DY[i] == DY[j])), is_valid(XY[i][0], XY[i][1], XY[j][0], XY[j][1], DX[i], DY[i])))

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

        xy = [(model[XY[i][0]], model[XY[i][1]]) for i in range(n)]

        # Write solution to file
        instance_name = input_filename.split('/')[-1]
        instance_name = instance_name[:len(instance_name) - 4]
        output_filename = os.path.join(args.out_path, instance_name + '-out.txt')
        with open(output_filename, 'w') as f_out:
            f_out.write(f'{w} {h}\n')
            f_out.write(f'{n}\n')
            for i in range(n):
                f_out.write(f'{DX[i]} {DY[i]}\t{xy[i][0]} {xy[i][1]}\n')


if __name__ == '__main__':
    main()
