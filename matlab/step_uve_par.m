function os = step_uve_nopar(os,kmm,sp);
% This function integrates the Navier-Stokes equation with a simple scheme.
% - Purely 3D, no mode splitting (therefore short time step is required
%
% The routine takes U, V and E states at a time t. It calculates and returns
% vertical speeds W at time t, and updated U, V and E values for time t+dt.
%
% - Time integration is forward Euler.
% - Advection of speeds (nonlinear terms) lacks subgrid
%   approximation (therefore significant numerical diffusion).
% - Molecular viscosities are neglected.
% - Hydrostatic conditions are assumed.
% - Eddy viscosities are included.
imax = sp.imax;
jmax = sp.jmax;
kmax = sp.kmax;
dx = sp.dx;

% Iterate over layers from top to calculate pressure gradients:
p_above = sp.p_atm;
for k=1:kmax

    % Compute pressure differential in whole layer:
    for i=1:imax
        for j=1:jmax
            if k<=kmm(i,j)
                p_diff(i,j) = os.cellHeights(i,j,k)*9.81*os.rho(i,j,k);
            else
                p_diff(i,j) = 0;
            end
        end
    end
    
    % Compute horizontal pressure gradients. For each cell boundary, the
    % gradient is evaluated at the mid height *at the boundary*. This means
    % we need to measure from below in the surface layer, and from above in
    % other layers to find the appropriate pressure.
    parfor i=1:imax-1
        for j=1:jmax
            % For the gradient to be valid, both bordering cells must be
            % wet. If not, set p_gradx to NaN:
            if kmm(i,j)<k | kmm(i+1,j)<k
                p_gradx(i,j,k) = NaN;
            else
                meanCellHeight = 0.5*(os.cellHeights(i,j,k) + os.cellHeights(i+1,j,k)); % height measured from below
                if k == 1 % Surface layer:
                    p_gradx(i,j,k) = (p_above(i+1,j) + p_diff(i+1,j)*(os.cellHeights(i+1,j,k)-0.5*meanCellHeight)/os.cellHeights(i+1,j,k) ...
                        - (p_above(i,j) + p_diff(i,j)*(os.cellHeights(i,j,k)-0.5*meanCellHeight)/os.cellHeights(i,j,k)))/dx;
                else % Mid or bottom layer:
                    p_gradx(i,j,k) = (p_above(i+1,j) + p_diff(i+1,j)*0.5*meanCellHeight/os.cellHeights(i+1,j,k) ...
                        - (p_above(i,j) + p_diff(i,j)*0.5*meanCellHeight/os.cellHeights(i,j,k)))/dx;
                end

            end
        end
    end
    parfor i=1:imax
        for j=1:jmax-1
            % For the gradient to be valid, both bordering cells must be
            % wet. If not, set p_grady to NaN:
            if kmm(i,j)<k | kmm(i,j+1)<k
                p_grady(i,j,k) = NaN;
            else
                meanCellHeight = 0.5*(os.cellHeights(i,j,k) + os.cellHeights(i,j+1,k)); % height measured from below
                if k == 1 % Surface layer
                    p_grady(i,j,k) = (p_above(i,j+1) + p_diff(i,j+1)*(os.cellHeights(i,j+1,k)-0.5*meanCellHeight)/os.cellHeights(i,j+1,k) ...
                        - (p_above(i,j) + p_diff(i,j)*(os.cellHeights(i,j,k)-0.5*meanCellHeight)/os.cellHeights(i,j,k)))/dx;
                else
                    p_grady(i,j,k) = (p_above(i,j+1) + p_diff(i,j+1)*0.5*meanCellHeight/os.cellHeights(i,j+1,k) ...
                        - (p_above(i,j) + p_diff(i,j)*0.5*meanCellHeight/os.cellHeights(i,j,k)))/dx;
                end
            end
        end
    end
      
    p_above = p_above + p_diff; % Update p_above with bottom pressure for cells in this layer
    
end


% Compute vertical speeds, from bottom up per horizontal location:
%W = zeros(imax,jmax,kmax+1);
for i=2:imax-1
    for j=2:jmax-1
        os.W(i,j,kmm(i,j)+1) = 0; % No current through bottom
        for k=kmm(i,j):-1:1
            % Current through upper boundary is calculated to balance
            % flow rates through the other ones.
            
            % Calculate mean cell heights on both borders in x and y
            % direction, to find areas of cell interfaces:
            meanHeightU = [0.5*(os.cellHeights(i-1,j,k) + os.cellHeights(i,j,k)) 0.5*(os.cellHeights(i,j,k) + os.cellHeights(i+1,j,k))];
            meanHeightV = [0.5*(os.cellHeights(i,j-1,k) + os.cellHeights(i,j,k)) 0.5*(os.cellHeights(i,j,k) + os.cellHeights(i,j+1,k))];
            
            flowDiff = os.W(i,j,k+1)*dx.^2 ...
                + os.U(i-1,j,k)*dx*meanHeightU(1) - os.U(i,j,k)*dx*meanHeightU(2) ...
                + os.V(i,j-1,k)*dx*meanHeightV(1) - os.V(i,j,k)*dx*meanHeightV(2);
            os.W(i,j,k) = flowDiff/(dx.^2);
            
        end
    end
end

% Based on the values in W(i,k,1), calculate new elevation:
os.E_next = os.E;
os.E_next(2:end-1,2:end-1) = os.E_next(2:end-1,2:end-1) + sp.dt*os.W(2:end-1,2:end-1,1);

% Compute u and v from momentum equation.
% - neglecting viscosity 
% - including Coriolis, but neglecting w term in u equation 
os.U_next = 0*os.U_next;
os.V_next = 0*os.V_next;
parfor i=1:imax-1
    for j=1:jmax
        for k=1:kmax
            if isnan(p_gradx(i,j,k))
                U_next(i,j,k) = 0;
                break;
            else
                U_ij = os.U(i,j,k);
                % Estimate the local du/dx by upstream scheme:
                if U_ij >= 0
                    dudx = (U_ij - getUV(os.U,i-1,j,k,U_ij))/dx;
                else
                    dudx = (getUV(os.U,i+1,j,k,U_ij) - U_ij)/dx;
                end
                
%                 if i==2 & j==12 & k ==1
%                     dudx
%                 end
                % Estimate the local du/dy by upstream scheme:
                % First check if estimated v value here is positive or
                % negative:
                V_values = [getUV(os.V,i,j-1,k, NaN) getUV(os.V,i,j,k, NaN) getUV(os.V,i+1,j-1,k, NaN) getUV(os.V,i+1,j,k, NaN)];
                V_mean = mean(V_values(~isnan(V_values)));
                if V_mean > 0
                    dudy = (U_ij - getUV(os.U,i,j-1,k,U_ij))/dx;
                else
                    dudy = (getUV(os.U,i,j+1,k,U_ij) - U_ij)/dx;
                end
                % Estimate the local du/dz by upstream scheme:
                % First check if estimated w value here is positive or
                % negative:
                W_values = [getUV(os.W,i,j,k, NaN) getUV(os.W,i+1,j,k, NaN)];
                W_mean = mean(W_values(~isnan(W_values)));
                if W_mean > 0
                    if k<kmax
                        dudz = (U_ij - getUV(os.U,i,j,k+1,U_ij))/(0.5*(os.cellHeights(i,j,k)+os.cellHeights(i,j,k+1)));
                    else
                        dudz = 0;
                    end
                else
                    if k>1
                        dudz = (getUV(os.U,i,j,k-1,U_ij) - U_ij)/(0.5*(os.cellHeights(i,j,k)+os.cellHeights(i,j,k-1)));
                    else
                        dudz = 0;
                    end
                end
                % Estimate the local d2u/dz2 (double derivative):
                if k>1
                    dz_up = 0.5*(os.cellHeights(i,j,k)+os.cellHeights(i,j,k-1));
                else
                    dz_up = os.cellHeights(i,j,k);
                end
                if k<kmax
                    dz_down = 0.5*(os.cellHeights(i,j,k)+os.cellHeights(i,j,k+1));
                else
                    dz_down = os.cellHeights(i,j,k);
                end
                d2u_dz2 = ((getUV(os.U,i,j,k-1,U_ij) - U_ij)/dz_up - (U_ij - getUV(os.U,i,j,k+1,U_ij))/dz_down)/(0.5*(dz_up+dz_down));
                % Estimate the local d2u/dx2 (double derivative):
                d2u_dx2 = (getUV(os.U,i-1,j,k,U_ij) - 2*U_ij + getUV(os.U,i+1,j,k,U_ij))/(dx*dx);
                % Estimate the local d2u/dy2 (double derivative):
                d2u_dy2 = (getUV(os.U,i,j-1,k,U_ij) - 2*U_ij + getUV(os.U,i,j+1,k,U_ij))/(dx*dx);
                
                % Calculate updated U value:
                os.U_next(i,j,k) = U_ij ...
                    + sp.dt*(-p_gradx(i,j,k)/sp.rho_0 ... % Pressure term
                        - U_ij*dudx - V_mean*dudy - W_mean*dudz) ... % Advective terms
                        + sp.A_z*d2u_dz2 + sp.A_xy*(d2u_dx2 + d2u_dy2) ... % Eddy viscosity
                        + 2*sp.omega*sin(sp.phi(i,j))*V_mean; % Coriolis
                    
%                 if (i==2 | i==3) & j == 12 && k==1
%                     U(i-1:i,j,k)
%                     U_next(i-1:i,j,k)
%                 end
            end
        end
    end
end
parfor i=1:imax
    for j=1:jmax-1
        for k=1:kmax
            if isnan(p_grady(i,j,k))
                V_next(i,j,k) = 0;
                break;
            else
                V_ij = os.V(i,j,k);
                % Estimate the local dv/dy by upstream scheme:
                if V_ij > 0
                    dvdy = (V_ij - getUV(os.V,i,j-1,k,V_ij))/dx;
                else
                    dvdy = (getUV(os.V,i,j+1,k,V_ij) - V_ij)/dx;
                end
                % Estimate the local dv/dx by upstream scheme:
                % First check if estimated u value here is positive or
                % negative:
                U_values = [getUV(os.U,i-1,j,k, NaN) getUV(os.U,i,j,k, NaN) getUV(os.U,i-1,j+1,k, NaN) getUV(os.U,i,j+1,k, NaN)];
                U_mean = mean(U_values(~isnan(U_values)));
                
                if U_mean > 0
                    dvdx = (V_ij - getUV(os.V,i-1,j,k,V_ij))/dx;
                else
                    dvdx = (getUV(os.V,i+1,j,k,V_ij) - V_ij)/dx;
                end
                % Estimate the local dv/dz by upstream scheme:
                % First check if estimated w value here is positive or
                % negative:
                W_values = [getUV(os.W,i,j,k, NaN) getUV(os.W,i,j+1,k, NaN)];
                W_mean = mean(W_values(~isnan(W_values)));
                if W_mean > 0
                    if k<kmax
                        dvdz = (V_ij - getUV(os.V,i,j,k+1,V_ij))/(0.5*(os.cellHeights(i,j,k)+os.cellHeights(i,j,k+1)));
                    else
                        dvdz = 0;
                    end
                else
                    if k>1
                        dvdz = (getUV(os.V,i,j,k-1,V_ij) - V_ij)/(0.5*(os.cellHeights(i,j,k)+os.cellHeights(i,j,k-1)));
                    else
                        dvdz = 0;
                    end
                end
                % Estimate the local d2v/dz2 (double derivative):
                if k>1
                    dz_up = 0.5*(os.cellHeights(i,j,k)+os.cellHeights(i,j,k-1));
                else
                    dz_up = os.cellHeights(i,j,k);
                end
                if k<kmax
                    dz_down = 0.5*(os.cellHeights(i,j,k)+os.cellHeights(i,j,k+1));
                else
                    dz_down = os.cellHeights(i,j,k);
                end
                d2v_dz2 = ((getUV(os.V,i,j,k-1,V_ij) - V_ij)/dz_up - (V_ij - getUV(os.V,i,j,k+1,V_ij))/dz_down)/(0.5*(dz_up+dz_down));
                % Estimate the local d2v/dx2 (double derivative):
                d2v_dx2 = (getUV(os.V,i-1,j,k,V_ij) - 2*V_ij + getUV(os.V,i+1,j,k,V_ij))/(dx*dx);
                % Estimate the local d2v/dy2 (double derivative):
                d2v_dy2 = (getUV(os.V,i,j-1,k,V_ij) - 2*V_ij + getUV(os.V,i,j+1,k,V_ij))/(dx*dx);
                
                % Calculate updated V value:
                os.V_next(i,j,k) = os.V(i,j,k) ...
                    + sp.dt*(-p_grady(i,j,k)/sp.rho_0 ... % Pressure term
                        - V_ij*dvdy - U_mean*dvdx - W_mean*dvdz) ... % Advective terms
                        + sp.A_z*d2v_dz2 + sp.A_xy*(d2v_dx2 + d2v_dy2) ... % Eddy viscosity
                        - 2*sp.omega*sin(sp.phi(i,j))*U_mean; % Coriolis
                    
            end
        end
    end
end     
    
% Wind stress and bottom friction, U:
for i=1:imax-1
    for j=1:jmax
        if ~isnan(p_gradx(i,j,1)) % Check if there is a valid current vector at this position
            % Surface cell, average height on cell border:
            dz_mean = 0.5*(os.cellHeights(i,j,1)+os.cellHeights(i+1,j,1));
            os.U_next(i,j,1) = os.U_next(i,j,1) + sp.dt*sp.windStressU(i,j)/dz_mean;
            
            % Bottom friction. Apply at the minimum kmax of the
            % neighbouring cells. We need to calculate the absolute value
            % of the current speed here, based on U and interpolated V
            % values:
            k = min(kmm(i,j), kmm(i+1,j));
            % Bottom cell, average height on cell border:
            dz_mean = 0.5*(os.cellHeights(i,j,k)+os.cellHeights(i+1,j,k));
            % V value interpolated here:
            v_values = [getUV(os.V,i,j-1,k,NaN) getUV(os.V,i+1,j-1,k,NaN) getUV(os.V,i,j,k,NaN) getUV(os.V,i+1,j,k,NaN)];
            meanV = mean(v_values(~isnan(v_values)));
            speed = sqrt(os.U(i,j,k).^2 + meanV.^2);
            os.U_next(i,j,k) = os.U_next(i,j,k) - sp.dt*sp.C_b*os.U(i,j,k)*speed/dz_mean;    
        end
    end
end
% Wind stress and bottom friction, V:
for i=1:imax
    for j=1:jmax-1
        if ~isnan(p_grady(i,j,1)) % Check if there is a valid current vector at this position
            % Surface cell, average height on cell border:
            dz_mean = 0.5*(os.cellHeights(i,j,1)+os.cellHeights(i,j+1,1));
            os.V_next(i,j,1) = os.V_next(i,j,1) + sp.dt*sp.windStressV(i,j)/dz_mean;
            
            % Bottom friction. Apply at the minimum kmax of the
            % neighbouring cells. We need to calculate the absolute value
            % of the current speed here, based on V and interpolated U
            % values:
            k = min(kmm(i,j), kmm(i,j+1));
            % Bottom cell, average height on cell border:
            dz_mean = 0.5*(os.cellHeights(i,j,k)+os.cellHeights(i,j+1,k));
            % U value interpolated here:
            u_values = [getUV(os.U,i-1,j,k,NaN) getUV(os.U,i-1,j+1,k,NaN) getUV(os.U,i,j,k,NaN) getUV(os.U,i,j+1,k,NaN)];
            meanU = mean(u_values(~isnan(u_values)));
            speed = sqrt(os.V(i,j,k).^2 + meanU.^2);
            os.V_next(i,j,k) = os.V_next(i,j,k) - sp.dt*sp.C_b*os.V(i,j,k)*speed/dz_mean;
        end
    end
end 


