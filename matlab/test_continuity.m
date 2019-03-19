updateCellHeights;

%i = 23; j = 22; k = 5;
i = 33; j = 33; k = 1;

% Find the cell heights interpolated to the cell boundaries:
vsize = [0.5*(cellHeights(i-1,j,k)+cellHeights(i,j,k)) ...
    0.5*(cellHeights(i,j,k)+cellHeights(i+1,j,k)) ...
    0.5*(cellHeights(i,j-1,k)+cellHeights(i,j,k)) ...
    0.5*(cellHeights(i,j,k)+cellHeights(i,j+2,k))];

horiz = [U(i-1,j,k) -U(i,j,k) V(i,j-1,k) -V(i,j,k)]
vert = [W(i,j,k+1) -W(i,j,k)]
horizQ = dx*horiz.*vsize
vertQ = dx*dx*vert
balance = sum(horizQ) + sum(vertQ)

