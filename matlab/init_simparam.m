% Activate/deactivate features:
sp.freshwaterOn = 1;
sp.coriolisOn = 1;


% Time:
sp.dt = 2.5; % Time step (s)
sp.t_end = 3600*24+sp.dt; % Duration of simulation

% Coriolis parameters:
sp.omega = 0.7292e-4; % Earth rotational speed (rad/s)
sp.phi = 70*pi/180 * ones(size(E)); % Latitude of simulation grid
if sp.coriolisOn==0
    sp.phi = 0*phi;
end

% Atmo:
sp.p_atm = 101000*ones(imax,jmax); % Atmospheric pressure (Pa)
sp.windStressU = 0*ones(size(U(:,:,1)));
sp.windStressV = 0*0.0005*ones(size(V(:,:,1))); % Wind stress. 


% Constant density used in momentum equation
sp.rho_0 = dens(30,6); 

% Bottom friction:
sp.C_b = 2.5e-3; % taken from SINMOD's splitt_v7

% Eddy viscosity:
sp.A_xy = 1e5; % Horizontal eddy viscosity
sp.A_z = 10*1e-2; % Vertical eddy viscosity

% Storage:
sp.filename = 'test.nc';
sp.saveIntS = 1*3600;