function val = getUV(M, i, j, k, defVal)

% Get the indexed value from the matrix M. If the index is outside the
% edge, or the value is NaN, return the default value.
sm = size(M);
if i<1 || i>sm(1) || j<1 || j>sm(2) || k<1 || k>sm(3)
    val = defVal;
else
    val = M(i,j,k);
    if isnan(val)
        val = defVal;
    end
end


