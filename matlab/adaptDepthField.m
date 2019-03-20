
depth(depth<0) = 0;
depth(depth>0 & depth<=dz(1)) = dz(1)+1;
for i=1:imax
    for j=1:jmax
        %distance = 2*sqrt(((i-imax/2)/imax).^2 + ((j-jmax/2)/jmax).^2);
        %depth(i,j) = 50;% - 10./(1+exp(-1*(distance-0.5)));

        if depth(i,j) == 0
            dzz(i,j,1) = 0;
            kmm(i,j) = 0;
            continue;
        end
        for k=1:kmax

            if (depth(i,j) > layerDepths(k))
                dzz(i,j,k) = dz(k); 
            else
                dzz(i,j,k) = depth(i,j) - layerDepths(k-1);
                if dzz(i,j,k) < minBotLayerDepth
                    depth(i,j) = layerDepths(k-1) + minBotLayerDepth;
                    dzz(i,j,k) = minBotLayerDepth;
                end
                kmm(i,j) = k;
                break;
            end
            
        end
    end
end