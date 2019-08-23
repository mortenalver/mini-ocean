function runsim();
   
global h1 h2;

% -------------------------------------------------------------------
% Configuration:
% -------------------------------------------------------------------
%sp.scenario = 'simple fjord';
%sp.scenario = 'upwelling';
%sp.scenario = 'C-fjord';
%sp.scenario = 'load depths';
%sp.scenario = 'bottomEffect';
sp.scenario = 'channel';

% Initialize settings:
sp.coldStart = 1;
sp.initFile = 'upwelling.nc';
sp.initSample = -1;

% Plot settings:
plotInt = 5;
infoInt = 50;

% Model configuration:
updateMixingInt = 5; % Time steps between updating mixing coeffs
% -------------------------------------------------------------------


% Initialize model:
c =clock;
tic
init_ocean;
init_simparam;

% Open file to store model states in:
ncid = initSaveFile(sp.filename,imax,jmax,kmax,depth,layerDepths);

% Various initializations:
%vidObj = VideoWriter('elevation.avi');
%vidObj.FrameRate=23;
%open(vidObj);
firstPl = 1;
saveInt = sp.saveIntS/sp.dt;
saveCount = 0;
count = 0; count2 = 0; countInfo=0; countMix=0;
nSamples = floor(sp.t_end/sp.dt);
if plotInt > 0
   h1 = figure;
   h2 = figure;
end

% Main simulation loop, one cycle per model time step:
for sample=1:nSamples

    % -------------------------------------------------------------------
    % The following section handles the stepping of the whole model:
    % -------------------------------------------------------------------
    set_bounds; % Update boundary values
    os = frsZone(os, kmm, dzz, sp); % Then adjust the FRS zone by linearly interpolating between boundary
                           % values and values inside.

    os = os.updateCellHeights(kmm, dzz, sp); % Update cell heights matrix based on current elevation
    os = os.updateRho(kmm, sp); % Update density values for all cells based on S and T
    
    countMix = countMix+1;
    if sample==1 || countMix==updateMixingInt
        countMix = 0;
        % Update horizontal diffusivity of tracers
        os = os.calcHorizontalDiffusivitySmagorinsky(kmm, sp); 

        % Compute vertical mixing coefficients using the Richards
        os = os.calcVerticalMixingCoeffRichardson(kmm, sp);
    end
    
    % Add fresh water from rivers:
    if sp.freshwaterOn > 0
        addFreshwater; 
    end
    
    % Integrate the U, V and E states into U_next, V_next and E_next,
    % and calculate W from the current U and V values:
    os = step_uve_nopar(os,kmm,sp);
    
    % Call advection function for temperature and salinity:
    T_next = advectTempSalt_nopar(os.T,os,kmm,sp);
    S_next = advectTempSalt_nopar(os.S,os,kmm,sp);
    
    % ---------------------------------------------------------------
    % At this point, U, V, W, T and S are "in sync", since W was
    % calculated based on U and V.
    % U_next, V_next, T_next and S_next contain the states for the
    % next time step.
    % ---------------------------------------------------------------
    
    % Update all states to new values:
    os.T = T_next;
    os.S = S_next;
    os.U = os.U_next;
    os.V = os.V_next;
    os.E = os.E_next;
    
    % -------------------------------------------------------------------
    % The following section handles saving and plotting:
    % -------------------------------------------------------------------

    % Check if it's time to save the state values to file:
    saveCount = saveCount+1;
    if saveCount == saveInt
        saveCount = 0;
        saveState(sp.filename, imax, jmax, kmax, sp.dt*sample, os);
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
    if (plotInt > 0)
        count = count+1;
        if count == plotInt
            count2 = count2+1;
            count = 0;
        
            if firstPl > 0
                firstPl = 0;
                %h = figure;
                %set(gcf,'position', [100 100 1500 1100]);
            end

            plotState(os, imax, jmax, kmax, depth, layerDepths);
            
            f = getframe(h1);
            %writeVideo(vidObj, f);
        end
    end
end

toc
%close(vidObj);