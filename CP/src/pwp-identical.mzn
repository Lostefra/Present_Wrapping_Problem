include "diffn.mzn";
include "cumulative.mzn";

int: w;
int: h;
int: n;
array[1..n] of int: DX;
array[1..n] of int: DY;

% The i-th element of each array contains one (X/Y) coordinate of the bottom-left corner of the i-th piece of paper
array[1..n] of var 0..(w - min(DX)): X;
array[1..n] of var 0..(h - min(DY)): Y;

% Non-overlapping constraint
constraint diffn(X, Y, DX, DY);

% Boundaries consistency constraint (computationally relevant)
constraint forall(i in 1..n) (
  X[i] + DX[i] <= w /\ Y[i] + DY[i] <= h
);

% Implied constraints
constraint cumulative(X, DX, DY, h);
constraint cumulative(Y, DY, DX, w);

% Symmetry breaking
constraint symmetry_breaking_constraint(
  X[1] <= w div 2 /\ Y[1] <= h div 2  % force first piece to be placed in the bottom-left corner
);

% Impose ordering in pieces with the same size X[i] <= X[j] /\ Y[i] <= Y[j]
constraint forall(i, j in 1..n where i < j) (
  (DX[i] = DX[j] /\ DY[i] = DY[j]) ->    (X[j] >= X[i] + DX[i] /\ Y[j] >= Y[i]) 
                                      \/ (Y[j] >= Y[i] + DY[i] /\ X[j] >= X[i])
);

solve satisfy;

output ["\(w) \(h)\n\(n)\n"] ++ ["\(DX[i]) \(DY[i])\t\(X[i]) \(Y[i])\n" | i in 1..n];