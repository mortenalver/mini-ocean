
% Compute current cell heights for entire grid (taking bottom and elevation
% into account):
for i=1:imax
    for j=1:jmax
        for k=1:kmax
            cellHeights(i,j,k) = dzz(i,j,k);
            
            if kmm(i,j)>0 & k==1
                cellHeights(i,j,k) = cellHeights(i,j,k) + E(i,j);
            end
            
%             % Mean cell heights between cells in x and y direction:
%             if i<imax
%                cellHeightsU(i,j,k) 
%             end
        end
    end
end