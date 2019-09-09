imax = 45;
jmax = 40;
kmax = 9;
dx = 10000; % Horizontal resolution (x/y) (m)
dz = [10; 10; 10; 20; 20; 20; 30; 30; 50]; % Vertical size of layers (m)
sp.dt = 2.5;%5; % Time step (s)
init_grid;

addShallowArea = 1; % Set to 1 to include shallow area, 0 to not include


polygon = floor([0.4*imax 0.3*jmax; 0.6*imax 0.3*jmax; 
    0.6*imax 0.7*jmax; 0.4*imax 0.7*jmax]);
for ii=1:imax
    for jj=1:jmax
        if addShallowArea > 0 & inpolygon(ii, jj, polygon(:,1), polygon(:,2))
            depth(ii,jj) = 100;
        else
            depth(ii,jj) = 200;
        end
    end
end
depth = smooth(depth, 5);
%figure, mesh(depth');

% Initialize hydrography with measured profile:
profDepths = [0 20 50 100 200 500 1000 2000];
temp = [12   11.5   11   10.5   10   9.5   9   8.5 ...
    8    7.9];
%salt = [25   28   29   30   31   32   33   34 ...
%    34.2   34.4];
salt = [25   27   28   29   29.5  30 30.3 ...
    30.6   30.9];

saltdiff = 4;

% Set values over the whole domain:
for i=1:imax
    for j=1:jmax
        % 3D variables:
        for k=1:kmax
            os.T(i,j,k) = temp(k);
            os.S(i,j,k) = salt(k) + saltdiff*(i/imax)*4*exp(-(midLayerDepths(k)-5)/10);
            
        end
    end
end

% Freshwater
riverXY = [];
riverS = [];
riverT = [];
riverFlow = []; % m3/s