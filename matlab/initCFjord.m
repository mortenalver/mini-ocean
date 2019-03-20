imax = 22;
jmax = 16;
kmax = 7;
dx = 4000; % Horizontal resolution (x/y) (m)
dz = [5; 5; 10; 10; 10; 20; 20]; % Vertical size of layers (m)
init_grid;
        
depth = [80*ones(imax,ceil(jmax/2)) 40*ones(imax,floor(jmax/2))];
dd = [0 8 20 40];

jinds1 = floor(jmax*0.25):ceil(jmax*0.35);
jinds2 = floor(jmax*0.65):ceil(jmax*0.75);
iinds = 1:floor(imax*0.35);
depth(1:iinds(end)-1,:) = 0*depth(1:iinds(end)-1,:);
for pad=1:length(dd)
   depth(iinds(end)-2+pad,pad:end-(pad-1)) = dd(pad);
   depth(end-(pad-1),pad:end-(pad-1)) = dd(pad);
   depth(iinds(end)-2+pad:end-(pad-1),pad) = dd(pad);
   depth(iinds(end)-2+pad:end-(pad-1),end-(pad-1)) = dd(pad);
end
depth(iinds,jinds1) = 40*ones(size(depth(iinds,jinds1)));
depth(iinds,jinds2) = 20*ones(size(depth(iinds,jinds2)));
%figure,mesh(-depth')


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
            T(i,j,k) = t_int(k);
            S(i,j,k) = s_int(k);
        end
    end
end


% Freshwater
riverXY = [];
riverS = [];
riverT = [];
riverFlow = []; % m3/s
