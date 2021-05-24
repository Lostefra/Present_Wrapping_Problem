include "diffn.mzn";
include "cumulative.mzn";

int: w;
int: h;
int: n;
array[1..n] of int: DX;
array[1..n] of int: DY;

int: min_xy = min(DX ++ DY);
% The i-th element of each array contains one (X/Y) coordinate of the bottom-left corner of the i-th piece of paper
array[1..n] of var 0..(w - min_xy): X;
array[1..n] of var 0..(h - min_xy): Y;

% Array of boolean decision variables to keep track of rotations
array[1..n] of var bool: R;

% Support arrays which store the actual size, taking into account rotation
array[1..n] of var int: TRUE_DX = [if R[i] then DY[i] else DX[i] endif | i in 1..n];
array[1..n] of var int: TRUE_DY = [if R[i] then DX[i] else DY[i] endif | i in 1..n];

% Non-overlapping constraint
constraint diffn(X, Y, TRUE_DX, TRUE_DY);

% Boundaries consistency constraint (computationally relevant)
constraint forall(i in 1..n) (
  X[i] + TRUE_DX[i] <= w /\ Y[i] + TRUE_DY[i] <= h
);

% Implied constraints
constraint cumulative(X, TRUE_DX, TRUE_DY, h);
constraint cumulative(Y, TRUE_DY, TRUE_DX, w);

constraint R[2] = true;

solve satisfy;

output ["\(w) \(h)\n\(n)\n"] ++ ["\(TRUE_DX[i]) \(TRUE_DY[i])\t\(X[i]) \(Y[i])\n" | i in 1..n];
