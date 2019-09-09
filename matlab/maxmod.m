function v = maxmod(a,b)

if a*b < 0
    v = 0;
elseif abs(a) > abs(b)
    v = a;
else
    v = b;
end