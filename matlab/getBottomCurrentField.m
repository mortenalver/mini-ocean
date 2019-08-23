% Script for getting the bottom currents over the whole domain, and
% interpolating these to mid-cell positions:
Ub = zeros(size(U,1), size(U,2));
Vb = zeros(size(V,1), size(V,2));

for i=1:size(U,1)
    for j=1:size(U,2)
        Ub(i,j) = NaN;
        for k=1:kmax
            if isnan(U(i,j,k))
                break;
            else
                Ub(i,j) = U(i,j,k);
            end
        end
    end
end
for i=1:size(V,1)
    for j=1:size(V,2)
        Vb(i,j) = NaN;
        for k=1:kmax
            if isnan(V(i,j,k))
                break;
            else
                Vb(i,j) = V(i,j,k);
            end
        end
    end
end

[uu,vv] = interpolateUV(Ub(:,:), Vb(:,:), 1);

figure, quiver(uu',vv');