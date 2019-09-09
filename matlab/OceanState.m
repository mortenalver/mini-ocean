% This class contains:
% - All state variables for the ocean model, plus next-value matrixes for
% the states.
% - A set of methods for calculating per-cell properties based on their
% state values (cell heights, cell densities and vertical mixing coefficients).
%
classdef OceanState
    properties
        U, V, E, W, T, S
        U_next, V_next, E_next, T_next, S_next
        X
        cellHeights 
        rho
        K_v, AH
        windU, windV
    end
    methods
        
        function os = updateCellHeights(os, kmm, dzz, sp)
            % Compute current cell heights for entire grid (taking bottom and elevation
            % into account):
            if isempty(os.cellHeights)
                os.cellHeights = zeros(sp.imax,sp.jmax,sp.kmax);
            end
            for i=1:sp.imax
                for j=1:sp.jmax
                    for k=1:sp.kmax
                        os.cellHeights(i,j,k) = dzz(i,j,k);
                        
                        if kmm(i,j)>0 & k==1
                            os.cellHeights(i,j,k) = os.cellHeights(i,j,k) + os.E(i,j);
                        end
                        
                        %             % Mean cell heights between cells in x and y direction:
                        %             if i<imax
                        %                cellHeightsU(i,j,k)
                        %             end
                    end
                end
            end
        end
        
        
        function os = updateRho(os, kmm, sp)
            % Compute density for all cells:
            if isempty(os.rho)
                os.rho = zeros(sp.imax,sp.jmax,sp.kmax);
            end
            for i=1:sp.imax
                for j=1:sp.jmax
                    for k=1:sp.kmax
                        if k<=kmm(i,j)
                            os.rho(i,j,k) = dens(os.S(i,j,k), os.T(i,j,k));
                        else
                            os.rho(i,j,k) = 0;
                        end
                    end
                end
            end
        end
        
        
        function os = calcVerticalMixingCoeffRichardson(os, kmm, sp)
           % Compute vertical mixing coefficients using the Richardson number scheme
           % (see e.g. Sundfjord et al. 2008; Vertical mixing in the marginal ice 
           % zone of the northern Barents Sea—Results from numerical model 
           % experiments).
           % Coefficients are defined in the cell centre, horizontally, and on
           % the edges, vertically.
           if isempty(os.K_v)
                os.K_v = zeros(sp.imax,sp.jmax,sp.kmax-1);
           end
           for i=1:sp.imax
                for j=1:sp.jmax
                    lowerDepth = 0;
                    for k=1:sp.kmax-1
                        lowerDepth = lowerDepth + os.cellHeights(i,j,k);
                        centerDepth = lowerDepth - 0.5*os.cellHeights(i,j,k);
                        if k<kmm(i,j)
                            k_w = 0.028*((sp.H_wave.^2)/sp.T_wave)*exp(-0.8*centerDepth/sp.H_wave); 
                            meanCellHeights = 0.5*(os.cellHeights(i,j,k) + os.cellHeights(i,j,k+1));
                            % Calculate the vertical gradient of the
                            % density. If density is increasing downwards
                            % we want a positive value:
                            d_rho_dz = (os.rho(i,j,k+1) - os.rho(i,j,k))/meanCellHeights;
                            meanU_above = mean([getUV(os.U,i-1,j,k,0) getUV(os.U,i,j,k,0)]);
                            meanU_below = mean([getUV(os.U,i-1,j,k+1,0) getUV(os.U,i,j,k+1,0)]);
                            meanV_above = mean([getUV(os.V,i,j-1,k,0) getUV(os.V,i,j,k,0)]);
                            meanV_below = mean([getUV(os.V,i,j-1,k+1,0) getUV(os.V,i,j,k+1,0)]);
                            d_U_dz2 = ((meanU_above - meanU_below).^2 + (meanV_above - meanV_below).^2)/meanCellHeights;
                            
                            Ri = (9.81/os.rho(i,j,k))*d_rho_dz/d_U_dz2;
                            if isnan(Ri)
                                Ri = 0;
                            end
                            os.K_v(i,j,k) = sp.KVm*(atan(sp.G_vmix*(sp.Ri0-Ri))/pi + 0.5) + k_w;

                        else
                            os.K_v(i,j,k) = 0;
                        end
                    end
                end
            end
            
        end
        
        function os = calcHorizontalDiffusivitySmagorinsky(os, kmm, sp)
            if isempty(os.AH)
                os.AH = zeros(sp.imax,sp.jmax,sp.kmax);
            end
            amLim= 0.0625*sp.dx.^2/(20*sp.dt);
            for i=2:sp.imax-1
                for j=2:sp.jmax-1
                    for k=1:kmm(i,j)
                        AM = sp.CM*sp.dx*sp.dx*sqrt(((os.U(i,j,k)-os.U(i-1,j,k))/sp.dx).^2 ...
                            +((os.V(i,j,k)-os.V(i,j-1,k))/sp.dx).^2 ...
                            +.5*(.25*(os.U(i-1,j-1,k) + os.U(i-1,j+1,k) - os.U(i,j-1,k) - os.U(i,j+1,k))/sp.dx ...
                            + .25*(os.V(i-1,j-1,k) + os.V(i+1,j-1,k)- os.V(i-1,j,k) - os.V(i+1,j,k))/sp.dx).^2);
                        %AM = min(AM,amLim);
                        
                        os.AH(i,j,k) = min((sp.CH/sp.CM)*AM, amLim);
                    end
                end
            end
            os.AH(1,:,:) = os.AH(2,:,:);
            os.AH(end,:,:) = os.AH(end-1,:,:);
            os.AH(:,1,:) = os.AH(:,2,:);
            os.AH(:,end,:) = os.AH(:,end-1,:);
            os.AH(1,1,:) = os.AH(2,2,:);
            os.AH(1,end,:) = os.AH(2,end-1,:);
            os.AH(end,1,:) = os.AH(end-1,2,:);
            os.AH(end,end,:) = os.AH(end-1,end-1,:);
            
            
        end
    end
end