int: w;
int: h;
int: n;
array[1..n] of int: DX;
array[1..n] of int: DY;

% The i-th element of each array contains one (X/Y) coordinate of the bottom-left corner of the i-th piece of paper
array[1..n] of var 0..(w - min(DX)): X;
array[1..n] of var 0..(h - min(DY)): Y;

% Non-overlapping constraint
constraint forall(i, j in 1..n where i < j) (
     X[i] + DX[i] <= X[j]
  \/ X[j] + DX[j] <= X[i]
  \/ Y[i] + DY[i] <= Y[j]
  \/ Y[j] + DY[j] <= Y[i]
);

% Boundaries consistency constraint (computationally relevant)
constraint forall(i in 1..n) (
  X[i] + DX[i] <= w /\ Y[i] + DY[i] <= h
);

solve satisfy;

output ["\(w) \(h)\n\(n)\n"] ++ ["\(DX[i]) \(DY[i])\t\(X[i]) \(Y[i])\n" | i in 1..n];