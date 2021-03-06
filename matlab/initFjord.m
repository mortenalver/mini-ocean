imax = 35;
jmax = 20;
kmax = 12;
dx = 1000; % Horizontal resolution (x/y) (m)
dz = [5; 5; 5; 5; 10; 10; 10; 20; 20; 30; 50; 50]; % Vertical size of layers (m)
sp.dt = 1.5; % Time step (s)
init_grid;
        
depth = 150*ones(imax,jmax);
dd = [60 110 130 150];

fjCentr = [floor(imax/2 + 2) floor(jmax/2)]
maxdist = min(imax-1-fjCentr(1), floor(2*(jmax-1-fjCentr(2))));
for i=1:imax
    for j=1:jmax
        distance = sqrt((i-fjCentr(1))^2 + 4*(j-fjCentr(2))^2);
        if distance > maxdist
            depth(i,j) =0;
        else
            diffe = ceil(0.5*(maxdist-distance));
            if diffe <= length(dd) & diffe > 0
                depth(i,j) = dd(diffe);
            end
        end
    end
end

jinds = floor(jmax*0.45):ceil(jmax*0.55);
iinds = 1:floor(imax*0.1);
% depth(1:iinds(end)-1,:) = 0*depth(1:iinds(end)-1,:);
% for pad=1:length(dd)
%    depth(iinds(end)-2+pad,pad:end-(pad-1)) = dd(pad);
%    depth(end-(pad-1),pad:end-(pad-1)) = dd(pad);
%    depth(iinds(end)-2+pad:end-(pad-1),pad) = dd(pad);
%    depth(iinds(end)-2+pad:end-(pad-1),end-(pad-1)) = dd(pad);
% end
depth(iinds,jinds) = 45*ones(size(depth(iinds,jinds)));
figure,mesh(-depth')

%%
% Initialize hydrography with measured profile:
profDepths = [0 2 4 6 8 10 15 20 25 30 40 100 200];
temp = [12 11.5 11 10.5 10.2 10.1 10 9.9 9.8 9.75 9.74 9.74 9.74];
salt = [20 21 22 23 25 26 30 31 31.5 31.88 31.885 31.885 31.885];
%temp = (9.71 + 12) - temp;
%salt = (20+31.885) - salt;
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
            if i<imax
                os.U(i,j,k) = 0.01;
            end

            os.T(i,j,k) = t_int(k);
            os.S(i,j,k) = s_int(k);
        end
    end
end


% Freshwater
j = floor(jmax/2);
for i=imax:-1:0
    if depth(i,j) > 0
        riverXY = [i j];
% riverXY = [21 2; 28 8; 53 13];
        riverS = [0];
        riverT = [12];
        riverFlow = [0500]; % m3/s
        break;
    end
end