% Activate/deactivate features:
sp.freshwaterOn = 0;
sp.coriolisOn = 0;
sp.atmoOn = 0;
sp.trcVertMix = 1;
sp.trcHorizMix = 1;
sp.passiveTracer = 0;

% Time and storage:
sp.t_end = 3600*24*5 + 30;%3600*24*30+60; % Duration of simulation
sp.filename = 'test.nc';
sp.saveIntS = 900;%3600;

% Boundary zone:
sp.frsZone = 2; % Size of FRS zone

% Coriolis parameters:
sp.omega = 0.7292e-4; % Earth rotational speed (rad/s)
sp.latitude = 60;

if sp.coriolisOn>0
    sp.phi = sp.latitude*pi/180 * ones(size(os.E)); % Latitude of simulation grid
else
    sp.phi = zeros(size(os.E));
end

% Atmosphere/waves:
sp.atmoUpdateInterval = 300; % Update interval for atmo data (s)
sp.p_atm = 101000*ones(imax,jmax); % Atmospheric pressure (Pa)
sp.windStressU = zeros(size(os.U(:,:,1))); % Values assigned in atmo
sp.windStressV = zeros(size(os.V(:,:,1))); % Values assigned in atmo
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
sp.CM = 1.0;
sp.CH = 0.4;
%sp.A_xy = 0.0001*2e5;%0.2e6; %1e5; % NOT USED, Smagorinsky is used instead. Horizontal eddy viscosity.
sp.A_z = 10*1e-2; % Vertical eddy viscosity

