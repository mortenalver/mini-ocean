% Initialize settings:
coldStart = 1;
initFile = 'init.nc';
initSample = -1;

% Initialize depth matrix:
minBotLayerDepth = 1; % Adjust depth matrix so the bottom layer is at least  this thick
%load depthdata;
%depthdata(isnan(depthdata)) = 11;
%depth = -45 + depthdata(1:size(depth,1), 1:size(depth,2))/2;
initFjord;

depth(depth<0) = 0;
depth(depth>0 & depth<=dz(1)) = dz(1)+1;
for i=1:imax
    for j=1:jmax
        %distance = 2*sqrt(((i-imax/2)/imax).^2 + ((j-jmax/2)/jmax).^2);
        %depth(i,j) = 50;% - 10./(1+exp(-1*(distance-0.5)));

        if depth(i,j) == 0
            dzz(i,j,1) = 0;
            kmm(i,j) = 0;
            continue;
        end
        for k=1:kmax

            if (depth(i,j) > layerDepths(k))
                dzz(i,j,k) = dz(k); 
            else
                dzz(i,j,k) = depth(i,j) - layerDepths(k-1);
                if dzz(i,j,k) < minBotLayerDepth
                    depth(i,j) = layerDepths(k-1) + minBotLayerDepth;
                    dzz(i,j,k) = minBotLayerDepth;
                end
                kmm(i,j) = k;
                break;
            end
            
        end
    end
end

rho_0 = dens(30,6); % Constant density used in momentum equation

% Initialize hydrography with measured profile:
profDepths = [0 2 4 6 8 10 15 20 25 30 40];
temp = [12 11.5 11 10.5 10.2 10.1 10 9.9 9.8 9.75 9.74];
salt = [20 21 22 23 25 26 30 31 31.5 31.88 31.885];

% Intepolate measurements to mid layer depths:
t_int = interp1(profDepths, temp, midLayerDepths,'linear','extrap');
s_int = interp1(profDepths, salt, midLayerDepths,'linear','extrap');

if coldStart > 0
    % Set values over the whole domain:
    for i=1:imax
        for j=1:jmax
            % Elevation:
            %E(i,j) = (1/2)*sqrt(((i-imax*0.5)/imax)^2 + ((j-jmax*0.5)/jmax)^2);

            % 3D variables:
            for k=1:kmax
                T(i,j,k) = t_int(k);
                S(i,j,k) = s_int(k);
            end
        end
    end

    %U(:) = 0.2*ones(size(U(:)));
else
    
    [U, V, E, T, S] = loadState(initFile, initSample);
   
end

% -----------------------------------------------------------
% Freshwater
riverXY = [imax-1 2; imax-1, jmax-1];
% riverXY = [21 2; 28 8; 53 13];
riverS = [0; 0];
riverT = [6; 6];
riverFlow = [500; 500]; % m3/s
