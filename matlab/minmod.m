function v = minmod(a,b)

if a*b < 0
    v = 0;
elseif abs(a) > abs(b)
    v = b;
else
    v = a;
end

    