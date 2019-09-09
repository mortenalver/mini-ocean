

% ---------------------------------------------------------------------------
% Layer information:
layerDepths = cumsum(dz);
midLayerDepths = layerDepths - 0.5*dz;

% Bathymetry matrix:
depth = zeros(imax,jmax);
kmm = zeros(imax,jmax);
dzz = zeros(imax,jmax,kmax);

% cellHeightsU = zeros(imax-1,jmax,kmax);
% cellHeightsV = zeros(imax,jmax-1,kmax);
% States:
os = OceanState();
os.E = zeros(imax,jmax);
os.U = zeros(imax-1,jmax,kmax);
os.V = zeros(imax,jmax-1,kmax);
os.W = zeros(imax,jmax,kmax+1);
os.T = zeros(imax,jmax,kmax);
os.S = zeros(imax,jmax,kmax);
os.windU = zeros(imax,jmax);
os.windV = zeros(imax,jmax);

% ---------------------------------------------------------------------------
% Some temporary variables:
p_diff = zeros(imax,jmax);
p_above = zeros(imax,jmax);
p_mid = zeros(imax,jmax);
p_gradx = zeros(imax-1, jmax,kmax);
p_grady = zeros(imax, jmax-1,kmax);

os.U_next = zeros(size(os.U));
os.V_next = zeros(size(os.V));
os.E_next = zeros(size(os.E));
os.S_next = zeros(size(os.S));
os.T_next = zeros(size(os.T));
