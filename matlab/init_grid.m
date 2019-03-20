

% ---------------------------------------------------------------------------
% Layer information:
layerDepths = cumsum(dz);
midLayerDepths = layerDepths - 0.5*dz;

% Bathymetry matrix:
depth = zeros(imax,jmax);
kmm = zeros(imax,jmax);
dzz = zeros(imax,jmax,kmax);
cellHeights = zeros(imax,jmax,kmax);
cellDens = zeros(imax,jmax,kmax);
% cellHeightsU = zeros(imax-1,jmax,kmax);
% cellHeightsV = zeros(imax,jmax-1,kmax);
% States:
E = zeros(imax,jmax);
U = zeros(imax-1,jmax,kmax);
V = zeros(imax,jmax-1,kmax);
W = zeros(imax,jmax,kmax+1);
T = zeros(imax,jmax,kmax);
S = zeros(imax,jmax,kmax);


% ---------------------------------------------------------------------------
% Some temporary variables:
p_diff = zeros(imax,jmax);
p_above = zeros(imax,jmax);
p_mid = zeros(imax,jmax);
p_gradx = zeros(imax-1, jmax,kmax);
p_grady = zeros(imax, jmax-1,kmax);

U_next = zeros(size(U));
V_next = zeros(size(V));
E_next = zeros(size(E));
S_next = zeros(size(S));
T_next = zeros(size(T));
