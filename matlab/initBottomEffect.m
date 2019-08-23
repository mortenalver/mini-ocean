imax = 60;
jmax = 50;
kmax = 10;
dx = 10000; % Horizontal resolution (x/y) (m)
dz = [5; 5; 10; 10; 20; 50; 50; 50; 100; 200]; % Vertical size of layers (m)
sp.dt = 4; % Time step (s)
init_grid;

featureHeight = 0.01;

%polygon = floor([imax/3.5 jmax/3.5; imax/2 jmax/3.5; 2.5*imax/3.5 2.5*jmax/3.5; imax/2 2.5*jmax/3.5]);
polygon = floor([0.4*imax 0.3*jmax; 0.6*imax 0.3*jmax; 
    0.6*imax 0.7*jmax; 0.4*imax 0.7*jmax]);

for ii=1:imax
    for jj=1:jmax
        if inpolygon(ii, jj, polygon(:,1), polygon(:,2))
            depth(ii,jj) = 500;%250;
        else
            depth(ii,jj) = 500;
        end
    end
end

%figure, mesh(depth');

% Initialize hydrography with measured profile:
profDepths = [0 20 50 100 200 500 1000 2000];
temp = [12   11.5   11   10.5   10   9.5   9   8.5 ...
    8    7.9];
salt = [25   28   29   30   31   32   33   34 ...
    34.2   34.4];

% Set values over the whole domain:
for i=1:imax
    for j=1:jmax
        % 3D variables:
        for k=1:kmax
            os.T(i,j,k) = temp(k);
            os.S(i,j,k) = salt (k);
            if i<imax
                os.U(i,j,k) = 0.2;
            end
            
        end
    end
end

% Freshwater
riverXY = [];
riverS = [];
riverT = [];
riverFlow = []; % m3/s