% Activate/deactivate features:
freshwaterOn = 0;
coriolisOn = 1;


% Time:
dt = 10; % Time step (s)
t_end = 3600*0.5+dt; % Duration of simulation

% Coriolis parameters:
omega = 0.7292e-4; % Earth rotational speed (rad/s)
phi = 70*pi/180 * ones(size(E)); % Latitude of simulation grid
if coriolisOn==0
    phi = 0*phi;
end

% Wind:
windStressU = 0*ones(size(U(:,:,1)));
windStressV = 0*0.0005*ones(size(V(:,:,1)));

% Bottom friction:
C_b = 2.5e-3; % taken from SINMOD's splitt_v7

% Eddy viscosity:
A_xy = 1e5; % Horizontal eddy viscosity
A_z = 10*1e-2; % Vertical eddy viscosity

% Storage:
filename = 'test.nc';
saveIntS = 6*3600;