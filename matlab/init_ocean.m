% Initialize settings:
coldStart = 1;
initFile = 'init.nc';
initSample = -1;

scenario = 'simple fjord';
%scenario = 'C-fjord';
%scenario = 'load depths';

% Initialize depth matrix:
minBotLayerDepth = 1; % Adjust depth matrix so the bottom layer is at least  this thick


switch scenario
    case 'load depths'
        imax = 60;
        jmax = 50;
        kmax = 5;
        dx = 4000; % Horizontal resolution (x/y) (m)
        dz = [5; 5; 10; 10; 10; 20; 20]; % Vertical size of layers (m)
        init_grid;
        load depthdata;
        depthdata(isnan(depthdata)) = 11;
        depth = -45 + depthdata(1:imax, 1:jmax)/2;

        % Initialize hydrography with measured profile:
        profDepths = [0 2 4 6 8 10 15 20 25 30 40];
        temp = [12 11.5 11 10.5 10.2 10.1 10 9.9 9.8 9.75 9.74];
        salt = [20 21 22 23 25 26 30 31 31.5 31.88 31.885];
        % Intepolate measurements to mid layer depths:
        t_int = interp1(profDepths, temp, midLayerDepths,'linear','extrap');
        s_int = interp1(profDepths, salt, midLayerDepths,'linear','extrap');
        % Set values over the whole domain:
        for i=1:imax
            for j=1:jmax
                % Elevation:
                %E(i,j) = (1/2)*sqrt(((i-imax*0.5)/imax)^2 + ((j-jmax*0.5)/jmax)^2);

                % 3D variables:
                for k=1:kmax
                    os.T(i,j,k) = t_int(k);
                    os.S(i,j,k) = s_int(k);
                end
            end
        end

        % Freshwater
        riverXY = [];
        riverS = [];
        riverT = [];
        riverFlow = []; % m3/s
    case 'simple fjord'
        initFjord;
    case 'C-fjord'
        initCFjord;
end
% Copy grid sizes into sp struct for passing into functions:
sp.imax = imax;
sp.jmax = jmax;
sp.kmax = kmax;
sp.dx = dx;
adaptDepthField; % Make adjustments to depth field, and set all cell heights.




if coldStart == 0
   
    [U, V, E, T, S] = loadState(initFile, initSample);
   
end


