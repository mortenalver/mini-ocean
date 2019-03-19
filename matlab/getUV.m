function val = getUV(M, i, j, k, defVal)

% Get the indexed value from the matrix M. If the index is outside the
% edge, or the value is NaN, return the default value.

if i<1 | i>size(M,1) | j<1 | j>size(M,2) | k<1 | k>size(M,3)
    val = defVal;
else
    val = M(i,j,k);
    if isnan(val)
        val = defVal;
    end
end


