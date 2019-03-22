function runsim();
    
c = clock;
tic
init_ocean;
init_simparam;

filename = 'test.nc';
ncid = initSaveFile(filename,imax,jmax,kmax,depth,layerDepths);

E0 = os.E;

%vidObj = VideoWriter('elevation.avi');
%vidObj.FrameRate=23;
%open(vidObj);

firstPl = 1;

plotint = -10;
infoInt = 50;
saveInt = sp.saveIntS/sp.dt;
saveCount = 0;
plotLayer = 3;
count = 0; count2 = 0; countInfo=0;
nSamples = floor(sp.t_end/sp.dt);

for sample=1:nSamples
    % This section handles the stepping of the whole model:
    set_bounds; % Update boundary values
    os = os.updateCellHeights(kmm, dzz, sp); % Update cell heights matrix based on current elevation
    os = os.updateRho(kmm, sp); % Update density values for all cells based on S and T
    
    % Compute vertical mixing coefficients using the Richards
    os = calcVerticalMixingCoeffRichardson(os, kmm, sp);
           
    if sp.freshwaterOn > 0
        addFreshwater; % Add fresh water from rivers
    end
    % Integrate the U, V and E states into U_next, V_next and E_next,
    % and calculate W from the current U and V values:
    os = step_uve_nopar(os,kmm,sp);
       
    % Call advection function for temperature and salinity:
    T_next = advectTempSalt_nopar(os.T,os,kmm,sp);
    S_next = advectTempSalt_nopar(os.S,os,kmm,sp);
    
    % Update all state values for next time step:
    os.U = os.U_next;
    os.V = os.V_next;
    os.E = os.E_next;
    os.T = T_next;
    os.S = S_next;
    
%     U(1:4,12,1)
    
    % Check if it's time to save the state values to file:
    saveCount = saveCount+1;
    if saveCount == saveInt
        saveCount = 0;
        saveState(filename, imax, jmax, kmax, sp.dt*sample, os);
    end
    
    % Check if we should display status information:
    countInfo = countInfo+1;
    if countInfo == infoInt
       countInfo = 0;
       timeHours = sample*sp.dt/3600
       c2 = clock;
       timeInterval = etime(c2,c)
       c = c2;
       %memory
       
    end
    % Check if we should update plots:
    if (plotint > 0)
        count = count+1;
        if count == plotint
            count2 = count2+1;
            count = 0;
        
            if firstPl > 0
                firstPl = 0;
                h = figure;
                set(gcf,'position', [100 100 1500 1100]);
            end

            plotState(os, imax, jmax, kmax, depth, layerDepths);
            
            f = getframe(h);
            %writeVideo(vidObj, f);
        end
    end
end

toc
%close(vidObj);