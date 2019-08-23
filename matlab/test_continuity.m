os = os.updateCellHeights(kmm, dzz, sp);

%i = 23; j = 22; k = 5;
i = 20; j = 43; k = 2;

% Find the cell heights interpolated to the cell boundaries:
vsize = [0.5*(os.cellHeights(i-1,j,k)+os.cellHeights(i,j,k)) ...
    0.5*(os.cellHeights(i,j,k)+os.cellHeights(i+1,j,k)) ...
    0.5*(os.cellHeights(i,j-1,k)+os.cellHeights(i,j,k)) ...
    0.5*(os.cellHeights(i,j,k)+os.cellHeights(i,j+1,k))];

horiz = [os.U(i-1,j,k) -os.U(i,j,k) os.V(i,j-1,k) -os.V(i,j,k)]
vert = [os.W(i,j,k+1) -os.W(i,j,k)]
horizQ = dx*horiz.*vsize
vertQ = dx*dx*vert
balance = sum(horizQ) + sum(vertQ)

