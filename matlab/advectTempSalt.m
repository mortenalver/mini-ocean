function trc_next = advectTempSalt_nopar(trc,os,kmm,sp);

imax = sp.imax;
jmax = sp.jmax;
dx = sp.dx;

% Based on current speeds U, V and W, 
% update the temperature and salt fields, T and S.

% Basic advection scheme, no subgrid approximations used.
% We do not modify the outer boundary cells.
% Turbulent mixing is not done by this routine.

trc_next = trc;

parfor i=2:imax-1
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
            
            % Vertical mixing:
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
            
            trc_next(i,j,k) = trc(i,j,k) + sp.dt*advS/(dx*dx*os.cellHeights(i,j,k)) + sp.dt*diffS;
        end
    end
end


