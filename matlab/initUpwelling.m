imax = 70;
jmax = 40;
kmax = 10;
dx = 10000; % Horizontal resolution (x/y) (m)
dz = [5; 5; 10; 10; 20; 50; 50; 50; 100; 200]; % Vertical size of layers (m)
sp.dt = 2; % Time step (s)
init_grid;

depth = 400*ones(imax,jmax);
depth(:,end) = min(depth(:,end), 0);
depth(:,end-1) = min(depth(:,end-1), 35);
depth(:,end-2) = min(depth(:,end-2), 70);
depth(:,end-3) = min(depth(:,end-3), 115);
depth(:,end-4) = min(depth(:,end-4), 150);
depth(:,end-5) = min(depth(:,end-5), 200);
depth(:,end-6) = min(depth(:,end-6), 250);
depth(:,end-7) = min(depth(:,end-7), 300);
depth(:,end-8) = min(depth(:,end-8), 350);
depth(:,end-9) = min(depth(:,end-9), 375);

maxdepth = 400;
load randomseed; % Load saved random seed
rng(s); % Set seed, so random values are the same every time
subg = 7;
[X,Y] = meshgrid(1:subg:imax, 1:subg:jmax);
ds = zeros(size(X));
for i=1:numel(ds)
    ds(i) = 1 + 0.04*randn;
end
F = scatteredInterpolant(X(:),Y(:),ds(:));
[tx,ty] = meshgrid(1:imax, 1:jmax);
dmod = F(tx,ty)';
depth = depth.*dmod;
depth = smooth(depth,3); % Smoothing by diffusion



%depth(:,1) = 0;



% Initialize hydrography with measured profile:
% profDepths = [0 20 50 100 200 500 1000 2000];
% %temp = [12 11.5 11 10.5 10.2 10.1 10 9.9];
% %salt = [33 33.5 34 34.2 34.4 34.5 34.55 34.6];
% temp = [12   11.5   11   10.5   10   9.5   9   8.5 ...
%     8    7.9];
% salt = [25   28   29   30   31   32   33   34 ...
%     34.2   34.4];
profDepths = [0 10 20 30 40 100 200 1000];
temp = [13 12 11 10 9 8 7 6];
salt = [20 25 30 31 32 33 34 34.5];

% Intepolate measurements to mid layer depths:
t_int = interp1(profDepths, temp, midLayerDepths,'linear','extrap');
s_int = interp1(profDepths, salt, midLayerDepths,'linear','extrap');
% Set values over the whole domain:
for i=1:imax
    for j=1:jmax
        % Elevation:
        os.E(i,j) = 0.25-0.5*i/imax;

        % 3D variables:
        for k=1:kmax
            if i<imax
                os.U(i,j,k) = 0.1;
            end

            os.T(i,j,k) = t_int(k);
            os.S(i,j,k) = s_int(k);
        end
    end
end


% Freshwater
riverXY = [];
% riverXY = [21 2; 28 8; 53 13];
riverS = [];
riverT = [];
riverFlow = []; % m3/s
