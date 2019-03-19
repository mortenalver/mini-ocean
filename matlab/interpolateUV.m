function [uu, vv, t1, t2] = interpolateUV(U, V, sub)

% Interpolate U and V to center positions for quiver plotting:

if nargin < 3
    sub = 1;
end


imax = size(V,1);
jmax = size(U,2);

uco1 = 1:imax-1;
uco2 = 0.5:1:jmax-0.5;
[u1, u2] = meshgrid(uco1, uco2);
u1=u1'; u2=u2';
vco1 = 0.5:1:imax-0.5;
vco2 = 1:jmax-1;
[v1, v2] = meshgrid(vco1, vco2);
v1=v1'; v2=v2';
% Target grid:
[t1, t2] = meshgrid(0.5:sub:imax-0.5, 0.5:sub:jmax-0.5);
t1=t1'; t2=t2';
% Create interpolants:
int1 = scatteredInterpolant(u1(:), u2(:), U(:));
int2 = scatteredInterpolant(v1(:), v2(:), V(:));

uu = int1(t1,t2);
vv = int2(t1,t2);
