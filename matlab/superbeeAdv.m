function sum = superbeeAdv(dt, dx, c_ll, c_l, c_c, c_r, c_rr, v_l, v_r) 
% This function calculates the net advection for a single cell i along one
% dimension, using the Superbee flux limiter to avoid instability while
% suppressing numerical diffusion.
%
% dt: time step
% dx: cell width along x dimension
% c_ll: concentration in cell i-2
% c_l: concentration in cell i-1
% c_c: concentration in cell i
% c_r: concentration in cell i+1
% c_rr: concentration in cell i+2
% v_l: advection speed between cells i-1 and i
% v_r: advection speed between cells i and i+1

sum = 0;
if v_l >= 0
    sigma_l = maxmod(minmod((c_c-c_l)/dx, 2.*(c_l-c_ll)/dx), minmod(2.*(c_c-c_l)/dx, (c_l-c_ll)/dx));
    sum = sum + (v_l/dx)*(c_l + (sigma_l/2.0)*(dx-v_l*dt));
else
    sigma_l = maxmod(minmod((c_c-c_l)/dx, 2.*(c_r-c_c)/dx), minmod(2.*(c_c-c_l)/dx, (c_r-c_c)/dx));
    sum = sum + (v_l/dx)*(c_c - (sigma_l/2.0)*(dx+v_l*dt));
end

if v_r >= 0
    sigma_r = maxmod(minmod((c_c-c_l)/dx, 2.*(c_r-c_c)/dx), minmod(2.*(c_c-c_l)/dx, (c_r-c_c)/dx));
    sum = sum - (v_r/dx)*(c_c + (sigma_r/2.0)*(dx-v_r*dt));

else
    sigma_r = maxmod(minmod((c_r-c_c)/dx, 2.*(c_rr-c_r)/dx), minmod(2.*(c_r-c_c)/dx, (c_rr-c_r)/dx));
    sum = sum - (v_r/dx)*(c_r - (sigma_r/2.0)*(dx+v_r*dt));
end
