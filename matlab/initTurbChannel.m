imax = 40;
jmax = 35;
kmax = 7;
dx = 200; % Horizontal resolution (x/y) (m)
dz = [10; 10; 15; 15; 15; 15; 20]; % Vertical size of layers (m)
sp.dt = 0.05; % Time step (s)
init_grid;
   
maxdepth = 70;
% depth = maxdepth*ones(imax,jmax);
% dd = [0 40 60 70 75];
% for pad=1:length(dd)
%    depth(1:imax/2,pad) = dd(pad);
%    depth(1:imax,jmax+1-pad) = dd(pad);
% end
% 
% for pad=1:length(dd)
%    depth(imax+1-pad,1:(jmax+1-length(dd))) = dd(pad);
% end
% depth(imax,1:jmax) = 0;

load randomseed; % Load saved random seed
rng(s); % Set seed, so random values are the same every time
subg = 7;
[X,Y] = meshgrid(1:subg:imax, 1:subg:jmax);
ds = zeros(size(X));
for i=1:numel(ds)
    ds(i) = maxdepth + (maxdepth/5)*randn;
end
F = scatteredInterpolant(X(:),Y(:),ds(:))
[tx,ty] = meshgrid(1:imax, 1:jmax);
depth = F(tx,ty)';
depth = smooth(depth,3); % Smoothing by diffusion

%%
% load randomseed; % Load saved random seed
% rng(s); % Set seed, so random values are the same every time
% for i=1:imax
%     for j=1:jmax
%         if depth(i,j) > 0
%             depth(i,j) = depth(i,j)*(1 + (1/20)*randn);
%         end
%     end
% end

% islCentr = [5.5 23.5];
% for i=1:imax
%     for j=1:jmax
%         distance = sqrt((i-islCentr(1))^2 + (j-islCentr(2))^2);
%         if distance < 1.5
%             depth(i,j) = 0.2*maxdepth;
%         elseif distance < 3.5
%             depth(i,j) = 0.6*maxdepth;
%         elseif distance < 4.5
%             depth(i,j) = 0.8*maxdepth;
%         end
%     end
% end

% Initialize hydrography with measured profile:
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
        os.E(i,j) = 0.1 - ((i-1)/(imax-1))*0.2;

        % 3D variables:
        for k=1:kmax
            if i<imax & j<jmax/2 & depth(i,j)>0
                os.U(i,j,k) = 0.4;
                os.S(i,j,k) = s_int(k);
            elseif i<imax& j>=jmax/2 & depth(i,j)>0
                os.U(i,j,k) = -0.4;
                os.S(i,j,k) = s_int(k) + 0.5;
            end

            os.T(i,j,k) = t_int(k);
            
        end
    end
end


% Freshwater
riverXY = []
riverS = [];
riverT = [];
riverFlow = []; % m3/s
