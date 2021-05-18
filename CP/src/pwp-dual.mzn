include "among.mzn";
include "lex_lesseq.mzn";

int: w;
int: h;
int: n;
array[1..n] of int: DX;
array[1..n] of int: DY;

% Primal problem: the i-th element of each array contains one (X/Y) coordinate of the bottom-left corner of the i-th piece of paper
array[1..n] of var 0..(w - min(DX)): X;
array[1..n] of var 0..(h - min(DY)): Y;
% Dual problem: each cell in the 2D grid contains the number of the piece of paper it belongs
array[1..h, 1..w] of var 0..n: B;

% Channelling constraint
constraint forall(i in 1..h, j in 1..w, v in 1..n) (
  B[i, j] = v <-> i > Y[v] /\ i <= Y[v] + DY[v] /\ j > X[v] /\ j <= X[v] + DX[v]
);

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

% Implied constraints (V1)
% ------------------------------------------------------------
% Function that, given an index for the row/column, 
% returns the set of pieces of paper along that row/column
%function var set of 0..n: get_set(int: k, bool: along_x) = 
%if along_x then
%  array2set([B[k, j] | j in 1..w])
%else
%  array2set([B[i, k] | i in 1..h])
%endif;

% Implied constraints
%constraint forall(i in 1..h) (
%  sum([DX[v] | v in get_set(i, true) where v != 0]) <= w
%);
%constraint forall(j in 1..w) (
%  sum([DY[v] | v in get_set(j, false) where v != 0]) <= h
%);
% ------------------------------------------------------------

% Implied constraints (V2)
constraint forall(i in 1..h) (
  among([B[i, j] | j in 1..w], 1..n) <= w
);
constraint forall(j in 1..w) (
  among([B[i, j] | i in 1..h], 1..n) <= h
);

% Symmetry breaking
constraint symmetry_breaking_constraint(
     lex_lesseq(array1d(B), [B[i, j] | i in reverse(1..h), j in 1..w])  % prevent vertical flip
  /\ lex_lesseq(array1d(B), [B[i, j] | i in 1..n, j in reverse(1..n)])  % prevent horizontal flip
  /\ lex_lesseq(array1d(B), [B[i, j] | i, j in reverse(1..n)])  % prevent 180deg rotation
);

solve satisfy;

output ["\(w) \(h)\n\(n)\n"] ++ ["\(DX[i]) \(DY[i])\t\(X[i]) \(Y[i])\n" | i in 1..n];
