imax = 50;
jmax = 40;
kmax = 9;
dx = 10000; % Horizontal resolution (x/y) (m)
dz = [10; 10; 10; 20; 25; 25; 25; 50; 50]; % Vertical size of layers (m)
sp.dt = 5;%5; % Time step (s)
init_grid;

% Set up bathymetry:
load randomseed; % Load saved random seed
rng(s); % Set seed, so random values are the same every time
maxdepth = 200;
xy = [0 10; 10 2; 20 5; 30 10; 40 8; 51 10];
[P, S] = polyfit(xy(:,1), xy(:,2), 5);
xy2 = [0 35; 5 32; 15 35; 20 38; 23 36; 27 34; 30 36; 34 37; 40 35; 51 35];
[P2, S] = polyfit(xy2(:,1), xy2(:,2), 6);
xy3 = [0 20; 12 16; 20 20; 25 16; 30 15; 38 20; 51 22];
[P3, S] = polyfit(xy3(:,1), xy3(:,2), 5);
islCentr = [33 30];
for i=1:imax
    yco = ceil(polyval(P,i));
    yco2 = floor(polyval(P2,i));
    yco3 = floor(polyval(P3,i));
    for j=yco:yco2
        if j > yco3
            md = 2+yco2-yco3;
            depth(i,j) = maxdepth*(md-(j-yco3))/md;
            depth(i,j) = depth(i,j)*(1 + (1/20)*randn);
        else
            md = 2+yco3-yco;
            depth(i,j) = maxdepth*(md-(yco3-j))/md;
            depth(i,j) = depth(i,j)*(1 + (1/20)*randn);
        end       
    end
    
    for j=1:jmax
        distance = sqrt((i-islCentr(1))^2 + (j-islCentr(2))^2);
        if distance < 1.5
            depth(i,j) = 0;
        elseif distance < 2.5
            depth(i,j) = 25;
        elseif distance < 3.5
            depth(i,j) = 45;
        end
    end
end

figure, mesh(-depth');%,shading flat, colorbar

% Initialize hydrography with measured profile:
profDepths = [0 20 50 100 200 500 1000 2000];
temp = [12   11.5   11   10.5   10   9.5   9   8];
salt = [30   32   33   33.5   34   34   34   34.4];
t_lay = interp1(profDepths,temp, midLayerDepths)
s_lay = interp1(profDepths,salt, midLayerDepths)

% Set values over the whole domain:
for i=1:imax
    for j=1:jmax
        % 3D variables:
        for k=1:kmax
            os.T(i,j,k) = t_lay(k);
            os.S(i,j,k) = s_lay(k);
            
        end
    end
end

% Freshwater
riverXY = []
riverS = [];
riverT = [];
riverFlow = []; % m3/s