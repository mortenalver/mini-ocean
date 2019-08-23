function os = frsZone(os, kmm, dzz, sp);
    
    os.E = frsZoneVar(os.E, kmm, dzz, sp);
    %os.U = frsZoneVar(os.U, kmm, dzz, sp);
    %os.V = frsZoneVar(os.V, kmm, dzz, sp);
    os.T = frsZoneVar(os.T, kmm, dzz, sp);
    os.S = frsZoneVar(os.S, kmm, dzz, sp);

end

function var = frsZoneVar(var, kmm, dzz, sp);

    imax = size(var,1);
    jmax = size(var,2);
    
    vd = size(var,3);
    for step=1:sp.frsZone
        % Left and right borders:
        for j=(1+step):(jmax-step)
            if kmm(1,j)>0
                for k=1:min(vd,kmm(1+step,j))
                    % Compute weighted sum of boundary value and value within
                    % FRS zone:
                    wSum = ((sp.frsZone+1-step)/(sp.frsZone+1))*var(1,j,k) ...
                        + (step/(sp.frsZone+1))*var(2+sp.frsZone,j,k);
                    var(1+step,j,k) = wSum;
                end
            end
            
            if kmm(imax,j)>0
                for k=1:min(vd,kmm(imax-step,j))
                    % Compute weighted sum of boundary value and value within
                    % FRS zone:
                    wSum = ((sp.frsZone+1-step)/(sp.frsZone+1))*var(imax,j,k) ...
                        + (step/(sp.frsZone+1))*var(imax-sp.frsZone-1,j,k);
                    var(imax-step,j,k) = wSum;
                end      
            end
        end
        
        % Upper and lower borders:
        for i=(1+step):(imax-step)
            if kmm(i,1)>0
                for k=1:min(vd,kmm(i,1+step))
                    % Compute weighted sum of boundary value and value within
                    % FRS zone:
                    wSum = ((sp.frsZone+1-step)/(sp.frsZone+1))*var(i,1,k) ...
                        + (step/(sp.frsZone+1))*var(i,2+sp.frsZone,k);
                    var(i,1+step,k) = wSum;
                end
            end
            
            if kmm(i,jmax)>0
                for k=1:min(vd,kmm(i,jmax-step))
                    % Compute weighted sum of boundary value and value within
                    % FRS zone:
                    wSum = ((sp.frsZone+1-step)/(sp.frsZone+1))*var(i,jmax,k) ...
                        + (step/(sp.frsZone+1))*var(i,jmax-sp.frsZone-1,k);
                    var(i,jmax-step,k) = wSum;
                end      
            end
        end
    end
end