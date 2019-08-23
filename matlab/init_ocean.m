
% Initialize depth matrix:
minBotLayerDepth = 1; % Adjust depth matrix so the bottom layer is at least  this thick


switch sp.scenario
    case 'load depths'
        kmax = 12;
        dx = 20000; % Horizontal resolution (x/y) (m)
        dz = [20; 30; 50; 100; 200; 300; 300; 500; 500; 500; 500; 500]; % Vertical size of layers (m)
        sp.dt = 2.5; %2.5; % Time step (s)
        ginX = 70:120;
        ginY = 35:55;
        imax = length(ginX);
        jmax = 2*length(ginY);
        init_grid;
        load gin_depth;
        depth = gin_depth(ginX,ginY);
        depth(isnan(depth)) = 0;
        depth = depth;%*0.35;
        depth = [depth flipud(fliplr(depth))];
        %depth(:,end) = 0;
        %depth(:,end-1) = 30;
        %depth(:,end-2) = 80;
        
        % Initialize hydrography with measured profile:
        profDepths = [0 10 30 60 100 500 1000 5000];
        temp = [8 7 6 5 4.5 4.2 4.1 4];
        salt = [33 33.5 33.9 34.4 34.6 34.6 34.6 34.6];
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
        riverXY = [2 2; 24 3; 9 35; 21 39];
        riverS = [0; 0; 0; 0];
        riverT = [12; 12; 12; 12];
        riverFlow = [1000; 1000; 1000; 1000]; % m3/s
    case 'upwelling'
        initIdealLS;
    case 'simple fjord'
        initFjord;
    case 'C-fjord'
        initCFjord;
    case 'bottomEffect'
        initBottomEffect;
    case 'channel'
        initChannel;
end
% Copy grid sizes into sp struct for passing into functions:
sp.imax = imax;
sp.jmax = jmax;
sp.kmax = kmax;
sp.dx = dx;
adaptDepthField; % Make adjustments to depth field, and set all cell heights.

riverN = size(riverXY,1);

if sp.coldStart == 0
   
    [os, nSamples, depth, layerDepths] = loadState(sp.initFile, sp.initSample);
    os.U_next = zeros(size(os.U));
    os.V_next = zeros(size(os.V));
    os.T_next = zeros(size(os.T));
    os.S_next = zeros(size(os.S));
    
end


