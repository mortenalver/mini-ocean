
for riv=1:size(riverXY,1)
    added = riverFlow(riv)*sp.dt; % m3 added per time step
    i = riverXY(riv,1);
    j = riverXY(riv,2);
    cellVol = dx*dx*os.cellHeights(i,j,1); % m3 cell volume
    os.T(i,j,1) = (cellVol*os.T(i,j,1) + added*riverT(riv))/(cellVol+added);
    os.S(i,j,1) = (cellVol*os.S(i,j,1) + added*riverS(riv))/(cellVol+added);
    os.E(i,j) = os.E(i,j) + added/(dx*dx);
end