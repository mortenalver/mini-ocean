imax = 50;
jmax = 25;
kmax = 9;
dx = 10000; % Horizontal resolution (x/y) (m)
dz = [5; 5; 5; 5; 10; 15; 15; 20; 20]; % Vertical size of layers (m)
sp.dt = 2; % Time step (s)
init_grid;
        
depth = 100*ones(imax,jmax);
dd = [0 30 50 70 90];


for pad=1:length(dd)
   depth(1:imax,pad) = dd(pad);
   depth(1:imax,jmax+1-pad) = dd(pad);
end

% Uncomment the following two lines to include a shallower area:
% centreBox = [floor(imax/2 - 3) ceil(imax/2 + 3) floor(jmax/2 - 2) ceil(jmax/2 + 2)];
% depth(centreBox(1):centreBox(2),centreBox(3):centreBox(4)) = 100;




% Initialize hydrography with measured profile:
profDepths = [0 2 4 6 8 10 15 20 25 30 40 100 200];
temp = [12 11.5 11 10.5 10.2 10.1 10 9.9 9.8 9.75 9.74 9.74 9.74];
salt = [20 21 22 23 25 26 30 31 31.5 31.88 31.885 31.885 31.885];

% Intepolate measurements to mid layer depths:
t_int = interp1(profDepths, temp, midLayerDepths,'linear','extrap');
s_int = interp1(profDepths, salt, midLayerDepths,'linear','extrap');
% Set values over the whole domain:
for i=1:imax
    for j=1:jmax
        % Elevation:
        E(i,j) = 0.2 - ((i-1)/(imax-1))*0.4;

        % 3D variables:
        for k=1:kmax
            if i<imax
                os.U(i,j,k) = 0.01;
            end

            os.T(i,j,k) = t_int(k);
            os.S(i,j,k) = s_int(k);
        end
    end
end


% Freshwater
riverXY = []
riverS = [];
riverT = [];
riverFlow = []; % m3/s
