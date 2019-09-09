function trc_next = advectTempSalt_nopar(trc,os,kmm,sp);

imax = sp.imax;
jmax = sp.jmax;
dx = sp.dx;

% Based on current speeds U, V and W, 
% update the temperature and salt fields, T and S.

% Basic advection scheme, no subgrid approximations used.
% We do not modify the outer boundary cells.

trc_next = trc;

for i=2:imax-1
    for j=2:jmax-1
        for k=1:kmm(i,j)
            advS = 0;

            % Find the cell heights interpolated to the cell boundaries:
            vsize = [0.5*(os.cellHeights(i-1,j,k)+os.cellHeights(i,j,k)) ...
                0.5*(os.cellHeights(i,j,k)+os.cellHeights(i+1,j,k)) ...
                0.5*(os.cellHeights(i,j-1,k)+os.cellHeights(i,j,k)) ...
                0.5*(os.cellHeights(i,j,k)+os.cellHeights(i,j+1,k))];
            % For each horizontal direction, if current is into this cell,
            % add advection term of the unit (vol/s)*deltaS
            if os.U(i-1,j,k) > 0
                advS = advS + os.U(i-1,j,k)*dx*vsize(1)*(trc(i-1,j,k)-trc(i,j,k));
            end
            if os.U(i,j,k) < 0
                advS = advS - os.U(i,j,k)*dx*vsize(2)*(trc(i+1,j,k)-trc(i,j,k));
            end
            if os.V(i-1,j,k) > 0
                advS = advS + os.V(i-1,j,k)*dx*vsize(3)*(trc(i,j-1,k)-trc(i,j,k));
            end
            if os.V(i,j,k) < 0
                advS = advS - os.V(i,j,k)*dx*vsize(4)*(trc(i,j+1,k)-trc(i,j,k));
            end
            % Vertically:
            if os.W(i,j,k+1) > 0
               advS = advS + os.W(i,j,k+1)*dx*dx*(trc(i,j,k+1)-trc(i,j,k)); 
            end
            if k > 1
                if os.W(i,j,k-1) < 0
                    advS = advS - os.W(i,j,k-1)*dx*dx*(trc(i,j,k-1)-trc(i,j,k)); 
                end
            end

            % Horizontal mixing:
            % We need to make sure there is no diffusion between this cell
            % and neighbouring cells that are empty. This can be detected
            % based on computed cell heights, so we use a vector of flags
            % to turn each of the four horizontal turns on and off:
            if sp.trcHorizMix
                validNb = [os.cellHeights(i-1,j,k)>0 os.cellHeights(i+1,j,k)>0 ...
                    os.cellHeights(i,j-1,k)>0 os.cellHeights(i,j+1,k)>0];
                diffU = (validNb(2)*0.5*(os.AH(i,j)+os.AH(i+1,j))*(trc(i+1,j,k)-trc(i,j,k)) ... 
                    - validNb(1)*0.5*(os.AH(i-1,j)+os.AH(i,j))*(trc(i,j,k)-trc(i-1,j,k))) / (sp.dx.^2);
                diffV = (validNb(4)*0.5*(os.AH(i,j)+os.AH(i,j+1))*(trc(i,j+1,k)-trc(i,j,k)) ... 
                    - validNb(3)*0.5*(os.AH(i,j-1)+os.AH(i,j))*(trc(i,j,k)-trc(i,j-1,k))) / (sp.dx.^2);
            else
                diffU = 0;
                diffV = 0;
            end
            
            % Vertical mixing:
            if sp.trcVertMix
                v_here = trc(i,j,k);
                if k==1
                    v_above = v_here;
                    dz_up = 1;
                    kv_above = 0;
                else
                    v_above = trc(i,j,k-1);
                    dz_up = 0.5*(os.cellHeights(i,j,k)+os.cellHeights(i,j,k-1));
                    kv_above = os.K_v(i,j,k-1);
                end
                if k==kmm(i,j)
                    v_below = v_here;
                    dz_down = 1;
                    kv_below = 0;
                else
                    v_below = trc(i,j,k+1);
                    dz_down = 0.5*(os.cellHeights(i,j,k)+os.cellHeights(i,j,k+1));
                    kv_below = os.K_v(i,j,k);
                end
                diffS = (kv_above*(v_above-v_here)/dz_up - kv_below*(v_here - v_below)/dz_down)/(0.5*(dz_up+dz_down));
            else
                diffS = 0;
            end
            
            trc_next(i,j,k) = trc(i,j,k) + sp.dt*advS/(dx*dx*os.cellHeights(i,j,k)) + sp.dt*(diffS + diffU + diffV);
        end
    end
end


