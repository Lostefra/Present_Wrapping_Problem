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

% Non-overlapping constraint
constraint forall(i, j in 1..n where i < j) (
     ((not R[i] /\ not R[j]) -> (    X[i] + DX[i] <= X[j]
                                  \/ X[j] + DX[j] <= X[i]
                                  \/ Y[i] + DY[i] <= Y[j]
                                  \/ Y[j] + DY[j] <= Y[i]))
  /\ ((not R[i] /\ R[j]) -> (        X[i] + DX[i] <= X[j]
                                  \/ X[j] + DY[j] <= X[i]
                                  \/ Y[i] + DY[i] <= Y[j]
                                  \/ Y[j] + DX[j] <= Y[i]))
  /\ ((R[i] /\ not R[j]) -> (        X[i] + DY[i] <= X[j]
                                  \/ X[j] + DX[j] <= X[i]
                                  \/ Y[i] + DX[i] <= Y[j]
                                  \/ Y[j] + DY[j] <= Y[i]))
  /\ ((R[i] /\ R[j]) -> (            X[i] + DY[i] <= X[j]
                                  \/ X[j] + DY[j] <= X[i]
                                  \/ Y[i] + DX[i] <= Y[j]
                                  \/ Y[j] + DX[j] <= Y[i]))
);

% Boundaries consistency constraint
constraint forall(i in 1..n) (
     ((not R[i]) -> X[i] + DX[i] <= w /\ Y[i] + DY[i] <= h)
  /\ (R[i] -> X[i] + DY[i] <= w /\ Y[i] + DX[i] <= h)
);

solve satisfy;

output ["\(w) \(h)\n\(n)\n"] ++ ["\(if R[i] then DY[i] else DX[i] endif) \(if R[i] then DX[i] else DY[i] endif)\t\(X[i]) \(Y[i])\n" | i in 1..n];
