include "diffn.mzn";

int: w;
int: h;
int: n;
array[1..n] of int: DX;
array[1..n] of int: DY;

array[1..n] of var 0..(w - min(DX)): X;
array[1..n] of var 0..(h - min(DY)): Y;

%constraint forall(i, j in 1..n where i < j) (
%     X[i] + DX[i] <= X[j]
%  \/ X[j] + DX[j] <= X[i]
%  \/ Y[i] + DY[i] <= Y[j]
%  \/ Y[j] + DY[j] <= Y[i]
%);

constraint diffn(X, Y, DX, DY);

constraint forall(i in 1..n) (
  X[i] + DX[i] <= w /\ Y[i] + DY[i] <= h
);

% Bigger blocks are placed left-most and lower-most
constraint forall(i, j in 1..n where i != j) (
     DX[i] >= DX[j] -> X[i] <= X[j]
  /\ DY[i] >= DY[j] -> Y[i] <= Y[j]
);

solve satisfy;

output ["\(DX[i]) \(DY[i])\t\(X[i]) \(Y[i])\n" | i in 1..n];