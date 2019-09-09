
function balance = testGeostrophic(os, i, j, k);

u = 0.5*(os.U(i-1,j,k) + os.U(i,j,k))
v = 0.5*(os.V(i,j-1,k) + os.V(i,j,k))

angle = atan2(u,v)
normalAng = angle+pi/2

normalVec = [sin(normalAng), cos(normalAng)]

[FX,FY] = gradient(os.E);

elevGradient = [FX(i,j) FY(i,j)];
elevGradientNorm = elevGradient ./ norm(elevGradient)


