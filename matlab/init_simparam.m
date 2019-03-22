% Activate/deactivate features:
sp.freshwaterOn = 1;
sp.coriolisOn = 1;


% Time:
sp.dt = 2.5; % Time step (s)
sp.t_end = 3600*24*10+sp.dt; % Duration of simulation

% Coriolis parameters:
sp.omega = 0.7292e-4; % Earth rotational speed (rad/s)
sp.phi = 70*pi/180 * ones(size(os.E)); % Latitude of simulation grid
if sp.coriolisOn==0
    sp.phi = 0*phi;
end

% Atmosphere/waves:
sp.p_atm = 101000*ones(imax,jmax); % Atmospheric pressure (Pa)
sp.windStressU = 0*ones(size(os.U(:,:,1)));
sp.windStressV = 0*0.0005*ones(size(os.V(:,:,1))); % Wind stress. 
sp.H_wave = 0.5; % Wave height (m)
sp.T_wave = 3; % Wave period (s)



% Constant density used in momentum equation
sp.rho_0 = dens(30,6); 

% Bottom friction:
sp.C_b = 2.5e-3; % taken from SINMOD's splitt_v7

% Vertical mixing:
sp.Ri0 = 0.65; % Threshold Richardson number value. Taken from SINMOD
sp.G_vmix = 30; % Shape parameter for Richardson number vertical mixing scheme
sp.KVm = 3e-2; % [m2/s] Maximum vertical diffusivity

% Eddy viscosity:
sp.A_xy = 1e5; % Horizontal eddy viscosity
sp.A_z = 10*1e-2; % Vertical eddy viscosity

% Storage:
sp.filename = 'test.nc';
sp.saveIntS = 6*3600;