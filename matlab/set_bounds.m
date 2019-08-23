% Set outer bounds (for E, U, V, T and S) depending on which scenario we are running:
switch sp.scenario
    case 'load depths'
        
    case 'upwelling'
        vv = 0.25;
        os.E(:,1) = 0.5*vv;
        for j=1:sp.jmax
            os.E(end,j) = vv*((sp.jmax-j)/sp.jmax - 0.5);
            os.E(1,j) = vv*((sp.jmax-j)/sp.jmax - 0.5);
        end
        os.T(1,:,:) = os.T(2,:,:);
        os.T(end,:,:) = os.T(end-1,:,:);
        os.T(:,1,:) = os.T(:,2,:);
        os.S(1,:,:) = os.S(2,:,:);
        os.S(end,:,:) = os.S(end-1,:,:);
        os.S(:,1,:) = os.S(:,2,:);
        
        os.U(:,1,:) = os.U(:,2,:);
        os.U(1,:,:) = os.U(2,:,:);
        os.V(1,:,:) = os.V(2,:,:);
        os.U(end,:,:) = os.U(end-1,:,:);
        os.V(end,:,:) = os.V(end-1,:,:);
    case 'simple fjord'
        
    case 'C-fjord'
             
    case 'bottomEffect'
        ev = 0.1;
        for i=1:imax
            os.E(i,1) = ev*(1-(i-1)/imax);
            os.E(i,end) = ev*(-(i-1)/imax);
        end
        for j=1:jmax
            os.E(1,j) = ev*(1-( j-1)/jmax);
            os.E(end,j) = ev*(-(j-1)/jmax);
        end
        %os.E(end,:) = -ev;
        %os.E(1,:) = ev;
        
        os.U(1,:,:) = 0.14;%0.2;
        os.U(end,:,:) = 0.14;%0.2;
        os.U(:,1,:) = 0.14;%0.2;
        os.U(:,end,:) = 0.14;%0.2;
        os.V(1,:,:) = 0.14;
        os.V(end,:,:) = 0.14;
        os.V(:,1,:) = 0.14;
        os.V(:,end,:) = 0.14;
        
        os.T(1,:,:) = os.T(2,:,:);
        os.T(end,:,:) = os.T(end-1,:,:);
        os.T(:,1,:) = os.T(:,2,:);
        os.T(:,end,:) = os.T(:,end-1,:);
        
        os.S(1,:,:) = os.S(2,:,:);
        os.S(end,:,:) = os.S(end-1,:,:);
        os.S(:,1,:) = os.S(:,2,:);
        os.S(:,end,:) = os.S(:,end-1,:);
    case 'channel'
        os.U(1,:,:) = 0.25;
        os.U(end,:,:) = 0.25;
        os.V(1,:,:) = 0;
        os.V(end,:,:) = 0;
        os.E(1,:) = 0.2;
        os.E(end,:) = -0.2;

        
end


