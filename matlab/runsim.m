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
            %subplot(2,3,count2), 
            %pcolor(E'), colorbar
            %mesh(E');
            %subplot(1,2,1), mesh(U(:,:,1)');
            %subplot(1,2,2), mesh(V(:,:,1)');

    %         [uu,vv] = interpolateUV(U(:,:,1), V(:,:,1), 2);
    %         subplot(2,2,1), quiver(uu',vv'); %mesh(U(:,:,1)');
    %         title(num2str(sample*dt));
    %         [uu,vv] = interpolateUV(U(:,:,2), V(:,:,2), 2);
    %         subplot(2,2,2), quiver(uu',vv'); %mesh(U(:,:,1)');
    %         [uu,vv] = interpolateUV(U(:,:,3), V(:,:,3), 2);
    %         subplot(2,2,3), quiver(uu',vv'); %&mesh(E')
    %         [uu,vv] = interpolateUV(U(:,:,4), V(:,:,4), 2);
    %         subplot(2,2,4), quiver(uu',vv'); %&mesh(E')

            subs = 1;
            subplot(2,2,1)%, pcolor(S(:,:,2)'), shading flat, colorbar
    %         [uu,vv, t1, t2] = interpolateUV(U(:,:,1), V(:,:,1), subs);
    %          pcolor(t1', t2', sqrt(uu.^2 + vv.^2)'), shading flat, colorbar
    %         hold on, quiver(t1'+subs*0.5,t2'+subs*0.5, uu',vv');
    %         title(['t=' num2str(sample*dt)]);

            inds = depth==0;
            %S_mrk = os.S(:,:,1); S_mrk(inds) = NaN;
            S_mrk = permute(os.S(:,5,:),[3 1 2])';
            pcolor(S_mrk'), shading flat, colorbar, set(gca,'YDir','reverse');
            title(['Salinity k=1, t=' num2str(sample*sp.dt)]);
            subplot(2,2,2)
            [uu,vv, t1, t2] = interpolateUV(os.U(:,:,1), os.V(:,:,1), subs);

            uu(inds) = NaN;
            vv(inds) = NaN;
             pcolor(t1', t2', sqrt(uu.^2 + vv.^2)'), shading flat, colorbar
            hold on, quiver(t1'+subs*0.5,t2'+subs*0.5, uu',vv','k'); %mesh(U(:,:,1)');
            title('Current');
            %T_mrk = os.T(:,:,1); T_mrk(inds) = NaN;
            T_mrk = permute(os.T(:,5,:),[3 1 2])'; 
            subplot(2,2,3), pcolor(T_mrk'), shading flat, colorbar, set(gca,'YDir','reverse');
            title('Temperature k=1');
            E_mrk = os.E;
            E_mrk(inds) = NaN;
            subplot(2,2,4), pcolor(E_mrk'), shading flat, colorbar
            %caxis([-1 1])
            title('Elevation');

            %subplot(2,3,count2), pcolor((E-E0)'), colorbar
            %caxis([-1.5 1.5]);

            f = getframe(h);
            %writeVideo(vidObj, f);
        end
    end
end

toc
%close(vidObj);