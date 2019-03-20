
for i=1:imax
    for j=1:jmax
        for k=1:kmax
            if k<=kmm(i,j)
                cellDens(i,j,k) = dens(S(i,j,k), T(i,j,k));
            else
                cellDens(i,j,k) = 0;
            end
        end
    end
end