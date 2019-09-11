function [diffU, diffV] = biharmon(os, kmm,sp)
% Calculates biharmonic "diffusion" of velocities.
%
% SINMOD (Sundfjord et al. 2008): "The model calculates horizontal diffusivity of momentum using 
% biharmonic friction while horizontal diffusion of scalars applies diffusion 
% coefficients as in Smagorinsky (1963)."
%
brd = 2;
dx4 = sp.dx^4;

diffU = zeros(size(os.U));
for i=(1+brd):(sp.imax-1-brd)
    for j=(1+brd):(sp.jmax-brd)
        for k=1:sp.kmax
            if os.maskU(i,j,k)==0
                continue;
            end
            U_ij = os.U(i,j,k);
            s1 = getUV(os.U,i+1,j,k,U_ij) + getUV(os.U,i,j+1,k,U_ij) ...
                + getUV(os.U,i-1,j,k,U_ij) + getUV(os.U,i,j-1,k,U_ij);
            s2 = getUV(os.U,i+1,j+1,k,U_ij) + getUV(os.U,i-1,j+1,k,U_ij) ...
                + getUV(os.U,i-1,j-1,k,U_ij) + getUV(os.U,i+1,j-1,k,U_ij);
            s3 = os.maskU(i+1,j,k)*getUV(os.U,i+2,j,k,U_ij) ...
                + os.maskU(i,j+1,k)*getUV(os.U,i,j+2,k,U_ij) ...
                + os.maskU(i-1,j,k)*getUV(os.U,i-2,j,k,U_ij) ...
                + os.maskU(i,j-1,k)*getUV(os.U,i,j-2,k,U_ij);
            diffU(i,j,k) = sp.KBi*(20*U_ij - 8*s1 + 2*s2 + s3)/dx4;
        end
    end
end

diffV = zeros(size(os.V));
for i=(1+brd):(sp.imax-brd)
    for j=(1+brd):(sp.jmax-1-brd)
        for k=1:sp.kmax
            if os.maskV(i,j,k)==0
                continue;
            end
            V_ij = os.V(i,j,k);
            s1 = getUV(os.V,i+1,j,k,V_ij) + getUV(os.V,i,j+1,k,V_ij) ...
                + getUV(os.V,i-1,j,k,V_ij) + getUV(os.V,i,j-1,k,V_ij);
            s2 = getUV(os.V,i+1,j+1,k,V_ij) + getUV(os.V,i-1,j+1,k,V_ij) ...
                + getUV(os.V,i-1,j-1,k,V_ij) + getUV(os.V,i+1,j-1,k,V_ij);
            s3 = os.maskV(i+1,j,k)*getUV(os.V,i+2,j,k,V_ij) ...
                + os.maskV(i,j+1,k)*getUV(os.V,i,j+2,k,V_ij) ...
                + os.maskV(i-1,j,k)*getUV(os.V,i-2,j,k,V_ij) ...
                + os.maskV(i,j-1,k)*getUV(os.V,i,j-2,k,V_ij);
            diffV(i,j,k) = sp.KBi*(20*V_ij - 8*s1 + 2*s2 + s3)/dx4;
        end
    end
end