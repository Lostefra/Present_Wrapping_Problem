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

% Parameters to control the search heuristic and restart strategy
int: hs_mode = 3;
int: r_mode = 2;

ann: search_ann = 
if hs_mode == 1 then
  int_search(X, input_order, indomain_min)
elseif hs_mode == 2 then
  int_search(X, first_fail, indomain_min)
elseif hs_mode == 3 then
  int_search(X, dom_w_deg, indomain_min)
elseif hs_mode == 4 then
  int_search(X, input_order, indomain_random)
else
  int_search(X, dom_w_deg, indomain_random)
endif;

ann: restart_ann =
if r_mode == 1 then
  restart_constant(100)
elseif r_mode == 2 then
  restart_geometric(1.5, 100)
else
  restart_luby(100)
endif;

solve :: search_ann
      :: restart_ann
         satisfy;

output ["\(w) \(h)\n\(n)\n"] ++ ["\(DX[i]) \(DY[i])\t\(X[i]) \(Y[i])\n" | i in 1..n];
