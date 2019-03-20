
for riv=1:size(riverXY,1)
    added = riverFlow(riv)*sp.dt; % m3 added per time step
    i = riverXY(riv,1);
    j = riverXY(riv,2);
    cellVol = dx*dx*cellHeights(i,j,1); % m3 cell volume
    T(i,j,1) = (cellVol*T(i,j,1) + added*riverT(riv))/(cellVol+added);
    S(i,j,1) = (cellVol*S(i,j,1) + added*riverS(riv))/(cellVol+added);
    E(i,j) = E(i,j) + added/(dx*dx);
end