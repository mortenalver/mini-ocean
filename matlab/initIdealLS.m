imax = 55;
jmax = 50;
kmax = 10;
dx = 10000; % Horizontal resolution (x/y) (m)
dz = [5; 5; 10; 10; 20; 50; 50; 50; 100; 200]; % Vertical size of layers (m)
sp.dt = 4; % Time step (s)
init_grid;

featureHeight = 0.01;

depth = 500*ones(imax,jmax);
for i=1:imax
    for j=1:jmax
        dist = sqrt((i-imax/2)^2 + (j-jmax/2)^2);
        modif = featureHeight*(1 - (dist/8)^2);
        if modif > 0
            depth(i,j) = depth(i,j)-modif;
        end
    end
end

%depth(:,1) = 0;
depth(:,end) = 0;
depth(:,end-1) = 40;
depth(:,end-2) = 100;
depth(:,end-3) = 200;
depth(:,end-4) = 400;


% Initialize hydrography with measured profile:
profDepths = [0 20 50 100 200 500 1000 2000];
%temp = [12 11.5 11 10.5 10.2 10.1 10 9.9];
%salt = [33 33.5 34 34.2 34.4 34.5 34.55 34.6];
temp = [12   11.5   11   10.5   10   9.5   9   8.5 ...
    8    7.9];
salt = [25   28   29   30   31   32   33   34 ...
    34.2   34.4];

% Intepolate measurements to mid layer depths:
%t_int = interp1(profDepths, temp, midLayerDepths,'linear','extrap');
%s_int = interp1(profDepths, salt, midLayerDepths,'linear','extrap');
% Set values over the whole domain:
for i=1:imax
    for j=1:jmax
        % Elevation:
        os.E(i,j) = 0.2 - 0.4*(i/imax);

        % 3D variables:
        for k=1:kmax
            if i<imax
                os.U(i,j,k) = 0.1;
            end

            os.T(i,j,k) = temp(k);%t_int(k);
            os.S(i,j,k) = salt (k);%s_int(k);
        end
    end
end


% Freshwater
riverXY = [];
% riverXY = [21 2; 28 8; 53 13];
riverS = [];
riverT = [];
riverFlow = []; % m3/s
