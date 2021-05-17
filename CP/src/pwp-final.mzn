include "diffn.mzn";
include "among.mzn";
include "lex_lesseq.mzn";

int: mode = 5;
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
constraint diffn(X, Y, DX, DY);

% Implied constraints
constraint forall(i in 1..h) (
  among([B[i, j] | j in 1..w], 1..n) <= w
);
constraint forall(j in 1..w) (
  among([B[i, j] | i in 1..h], 1..n) <= h
);

% Boundaries consistency constraint (computationally relevant)
constraint forall(i in 1..n) (
  X[i] + DX[i] <= w /\ Y[i] + DY[i] <= h
);

constraint symmetry_breaking_constraint(
     lex_lesseq(array1d(B), [B[i, j] | i in reverse(1..h), j in 1..w])  % prevent vertical flip
  /\ lex_lesseq(array1d(B), [B[i, j] | i in 1..n, j in reverse(1..n)])  % prevent horizontal flip
  /\ lex_lesseq(array1d(B), [B[i, j] | i, j in reverse(1..n)])  % prevent 180deg rotation
);

ann: search_ann = 
if mode == 1 then
  int_search(X, input_order, indomain_min)
elseif mode == 2 then
  int_search(X, first_fail, indomain_min)
elseif mode == 3 then
  int_search(X, dom_w_deg, indomain_min)
elseif mode == 4 then
  int_search(X, input_order, indomain_random)
else
  int_search(X, dom_w_deg, indomain_random)
endif;

solve satisfy;

output ["\(w) \(h)\n\(n)\n"] ++ ["\(DX[i]) \(DY[i])\t\(X[i]) \(Y[i])\n" | i in 1..n];