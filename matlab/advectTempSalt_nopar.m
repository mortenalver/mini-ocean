% Based on current speeds U, V and W, 
% update the temperature and salt fields, T and S.

% Basic advection scheme, no subgrid approximations used.
% We do not modify the outer boundary cells.
% Turbulent mixing is not done by this routine.

trc_next = trc;

for i=2:imax-1
    for j=2:jmax-1
        for k=1:kmm(i,j)
            advS = 0;
            % Find the cell heights interpolated to the cell boundaries:
            vsize = [0.5*(cellHeights(i-1,j,k)+cellHeights(i,j,k)) ...
                0.5*(cellHeights(i,j,k)+cellHeights(i+1,j,k)) ...
                0.5*(cellHeights(i,j-1,k)+cellHeights(i,j,k)) ...
                0.5*(cellHeights(i,j,k)+cellHeights(i,j+1,k))];
            % For each horizontal direction, if current is into this cell,
            % add advection term of the unit (vol/s)*deltaS
            if U(i-1,j,k) > 0
                advS = advS + U(i-1,j,k)*dx*vsize(1)*(trc(i-1,j,k)-trc(i,j,k));
            end
            if U(i,j,k) < 0
                advS = advS - U(i,j,k)*dx*vsize(2)*(trc(i+1,j,k)-trc(i,j,k));
            end
            if V(i-1,j,k) > 0
                advS = advS + V(i-1,j,k)*dx*vsize(3)*(trc(i,j-1,k)-trc(i,j,k));
            end
            if V(i,j,k) < 0
                advS = advS - V(i,j,k)*dx*vsize(4)*(trc(i,j+1,k)-trc(i,j,k));
            end
            % Vertically:
            if W(i,j,k+1) > 0
               advS = advS + W(i,j,k+1)*dx*dx*(trc(i,j,k+1)-trc(i,j,k)); 
            end
            if k > 1
                if W(i,j,k-1) < 0
                    advS = advS - W(i,j,k-1)*dx*dx*(trc(i,j,k-1)-trc(i,j,k)); 
                end
            end
            trc_next(i,j,k) = trc(i,j,k) + dt*advS/(dx*dx*cellHeights(i,j,k));
        end
    end
end


