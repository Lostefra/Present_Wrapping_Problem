include "diffn.mzn";

int: w;
int: h;
int: n;
array[1..n] of int: DX;
array[1..n] of int: DY;

% Primal problem: the i-th element of each array contains one (X/Y) coordinate of the bottom-left corner of the i-th piece of paper
array[1..n] of var 0..(w - min(DX)): X;
array[1..n] of var 0..(h - min(DY)): Y;
% Dual problem: each cell in the 2D grid contains the number of the piece of paper it belongs
array[1..w, 1..h] of var 1..n: B;

% Function that, given an index for the row/column, returns the set of pieces of paper along that row/column
function var set of 1..n: get_set(int: k, bool: along_x) = 
if along_x then
  array2set([B[k, j] | j in 1..h])
else
  array2set([B[i, k] | i in 1..w])
endif;

%OLD CONSTRAINTS
%----------------------------------------------
% Non-overlapping constraint
%constraint forall(i, j in 1..n where i < j) (
%     X[i] + DX[i] <= X[j]
%  \/ X[j] + DX[j] <= X[i]
%  \/ Y[i] + DY[i] <= Y[j]
%  \/ Y[j] + DY[j] <= Y[i]
%);
% Bigger blocks are placed left-most and lower-most (TODO)
%constraint forall(i, j in 1..n where i != j) (
%     DX[i] >= DX[j] -> X[i] <= X[j]
%  /\ DY[i] >= DY[j] -> Y[i] <= Y[j]
%);
%----------------------------------------------

% Non-overlapping constraint
constraint diffn(X, Y, DX, DY);

% Channelling constraint
constraint forall(i in 1..w, j in 1..h, v in 1..n) (
  B[i, j] = v <-> i > X[v] /\ i <= X[v] + DX[v] /\ j > Y[v] /\ j <= Y[v] + DY[v]
);

% Implied constraints
constraint forall(i in 1..w) (
  sum([DY[v] | v in get_set(i, true)]) <= h
);
constraint forall(j in 1..h) (
  sum([DX[v] | v in get_set(j, false)]) <= w
);

% Boundaries consistency constraint (computationally relevant)
constraint forall(i in 1..n) (
  X[i] + DX[i] <= w /\ Y[i] + DY[i] <= h
);

solve satisfy;

output ["\(DX[i]) \(DY[i])\t\(X[i]) \(Y[i])\n" | i in 1..n];