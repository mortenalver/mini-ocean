timeHours = sample*sp.dt/3600;

% Set outer bounds (for E, U, V, T and S) depending on which scenario we are running:
switch sp.scenario
    case 'real'
        os.T(1,:,:) = os.T(2,:,:);
        os.T(end,:,:) = os.T(end-1,:,:);
        %os.T(:,1,:) = os.T(:,2,:);
        %os.T(:,end,:) = os.T(:,end-1,:);
        os.S(1,:,:) = os.S(2,:,:);
        os.S(end,:,:) = os.S(end-1,:,:);
        %os.S(:,1,:) = os.S(:,2,:);
        %os.S(:,end,:) = os.S(:,end-1,:);
        
        os.U(1,:,:) = os.U(2,:,:);
        %os.U(:,1,:) = os.U(:,2,:);
        %os.U(:,end,:) = os.U(:,end-1,:);
        os.U(end,:,:) = os.U(end-1,:,:);
        os.V(1,:,:) = os.V(2,:,:);
        %os.V(:,1,:) = os.V(:,2,:);
        %os.V(:,end,:) = os.V(:,end-1,:);
        os.V(end,:,:) = os.V(end-1,:,:);
        
        vv = 0.5;
        os.E(1,:) = vv*0.5;
        os.E(end,:) = -vv*0.5;
%         for j=1:sp.jmax
%             os.E(1,j) = 0.5*vv - 0.1*(sp.jmax-j)/sp.jmax;
%             os.E(end,j) = -0.5*vv;% + 0.6*(sp.jmax-j)/sp.jmax;
%             midlim = ceil(0.7*sp.jmax);
%             
%             if j<midlim
%                 os.E(end,j) = os.E(end,j) + 0.7*(midlim-j)/midlim;
%             end
%         end
%         for i=1:sp.imax
%             os.E(i,end) = -vv*(i/sp.imax - 0.5);
%         end
        
    case 'channel'
        
%         os.T(1,:,:) = os.T(2,:,:);
%         os.T(end,:,:) = os.T(end-1,:,:);
%         os.S(1,:,:) = os.S(2,:,:);
%         os.S(end,:,:) = os.S(end-1,:,:);
%         
        os.U(1,:,:) = os.U(2,:,:);
        os.U(end,:,:) = os.U(end-1,:,:);
        os.V(1,:,:) = os.V(2,:,:);
        os.V(end,:,:) = os.V(end-1,:,:);

        os.E(1,:) = os.E(2,:);
        os.E(end,:) = os.E(end-1,:);
        midSect = floor(0.3*sp.jmax):ceil(0.7*sp.jmax); 
        os.E(1,midSect) = 0.08;
        os.E(end,midSect) = -0.08;
        os.U(1,:,:) = max(os.U(1,:,:), 0);
        os.V(1,:,:) = 0;
        os.V(end,:,:) = 0;
        os.U(end,:,:) = max(os.U(end,:,:), 0);
%         os.U(1:2,:,:) = max(os.U(1:2,:,:), 0);
%         os.V(1:2,:,:) = 0;
%         os.V(end-1:end,:,:) = 0;
%         os.U(end-1:end,:,:) = max(os.U(end-1:end,:,:), 0);
%         for j=1:sp.jmax
%             os.E(1,j) = 0.07 - 0.15*j/sp.jmax;
%             os.E(end,j) = -0.07 - 0.15*j/sp.jmax;
%         end
        
     case 'turbChannel'
        ev = 0.05;
        for i=1:imax
            os.E(i,1) = ev*(1-(i-1)/imax);
            os.E(i,end) = ev*(-(i-1)/imax);
        end
        for j=1:jmax
            os.E(1,j) = ev*(1-( j-1)/jmax);
            os.E(end,j) = ev*(-(j-1)/jmax);
        end
        
        os.T(1,:,:) = os.T(2,:,:);
        os.T(end,:,:) = os.T(end-1,:,:);
        os.T(:,1,:) = os.T(:,2,:);
        os.T(:,end,:) = os.T(:,end-1,:);
        
        os.S(1,:,:) = os.S(2,:,:);
        os.S(end,:,:) = os.S(end-1,:,:);
        os.S(:,1,:) = os.S(:,2,:);
        os.S(:,end,:) = os.S(:,end-1,:);

        os.U(1,:,:) = os.U(2,:,:);
        os.U(:,1,:) = os.U(:,2,:);
        os.U(:,end,:) = os.U(:,end-1,:);
        os.U(end,:,:) = os.U(end-1,:,:);
        os.V(1,:,:) = os.V(2,:,:);
        os.V(:,1,:) = os.V(:,2,:);
        os.V(:,end,:) = os.V(:,end-1,:);
        os.V(end,:,:) = os.V(end-1,:,:);
        
        %os.U(end,floor(jmax/2),:) = -1;
        %os.U(end-1,floor(jmax/2),:) = -1;
%         os.T(1,:,:) = os.T(2,:,:);
%         os.T(end,:,:) = os.T(end-1,:,:);
%         os.S(1,:,:) = os.S(2,:,:);
%         os.S(end,:,:) = os.S(end-1,:,:);
%         
%         os.U(1,:,:) = os.U(2,:,:);
%         os.U(:,1,:) = 0;%os.U(end-1,:,:);
%         os.V(1,:,:) = 0;%.V(2,:,:);
%         os.V(:,1,:) = os.V(:,2,:);
% 
%         os.E(1,:) = 0.25;
%         os.E(:,1) = -0.25;
%         
    case 'upwelling'
        vv = 0.2;
        for j=1:sp.jmax
            os.E(1,j) = vv*(1- 1.5*j/sp.jmax);
            os.E(end,j) = -2*vv + vv*(1- 1.5*j/sp.jmax);
        end
        for i=1:sp.imax
            os.E(i,1) = vv - 2*vv*(i/sp.imax);
        end
%         for j=1:sp.jmax
%             os.E(end,j) = vv*((sp.jmax-j)/sp.jmax - 0.5);
%             os.E(1,j) = -vv*((sp.jmax-j)/sp.jmax - 0.5);
%         end
%         os.T(1,:,:) = os.T(2,:,:);
%         os.T(end,:,:) = os.T(end-1,:,:);
%         os.T(:,1,:) = os.T(:,2,:);
%         os.S(1,:,:) = os.S(2,:,:);
%         os.S(end,:,:) = os.S(end-1,:,:);
%         os.S(:,1,:) = os.S(:,2,:);
        
        os.U(:,1,:) = os.U(:,2,:);
        os.U(1,:,:) = os.U(2,:,:);
        os.V(1,:,:) = os.V(2,:,:);
        os.U(end,:,:) = os.U(end-1,:,:);
        os.V(end,:,:) = os.V(end-1,:,:);
        
    case 'simple fjord'
        E_val = 0.75*sin(2*pi*timeHours/(12.2))
        for j=1:jmax
            if depth(1,j) > 0
                E(1,j) = E_val;
            end
        end
    case 'C-fjord'
             
    case 'open'
        ev = 0.25;
        for i=1:imax
            os.E(i,1) = ev*(1-(i-1)/imax);
            os.E(i,end) = ev*(-(i-1)/imax);
        end
        for j=1:jmax
            os.E(1,j) = ev*(1-( j-1)/jmax);
            os.E(end,j) = ev*(-(j-1)/jmax);
        end
        
        os.T(1,:,:) = os.T(2,:,:);
        os.T(end,:,:) = os.T(end-1,:,:);
        os.T(:,1,:) = os.T(:,2,:);
        os.T(:,end,:) = os.T(:,end-1,:);
        
        os.S(1,:,:) = os.S(2,:,:);
        os.S(end,:,:) = os.S(end-1,:,:);
        os.S(:,1,:) = os.S(:,2,:);
        os.S(:,end,:) = os.S(:,end-1,:);

        os.U(1,:,:) = os.U(2,:,:);
        os.U(:,1,:) = os.U(:,2,:);
        os.U(:,end,:) = os.U(:,end-1,:);
        os.U(end,:,:) = os.U(end-1,:,:);
        os.V(1,:,:) = os.V(2,:,:);
        os.V(:,1,:) = os.V(:,2,:);
        os.V(:,end,:) = os.V(:,end-1,:);
        os.V(end,:,:) = os.V(end-1,:,:);
        
end


