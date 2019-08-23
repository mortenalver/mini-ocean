
function [os, nSamples, depth, layerDepths] = loadState(filename, sample);

os = OceanState();

ncid = netcdf.open(filename,'NOWRITE');
timeD = netcdf.inqDimID(ncid,'time');
[~, nSamples] = netcdf.inqDim(ncid, timeD);
if sample < 0
   sample = nSamples-1;
end
xcD = netcdf.inqDimID(ncid,'xc');
[~, imax] = netcdf.inqDim(ncid,xcD);
ycD = netcdf.inqDimID(ncid,'yc');
[~, jmax] = netcdf.inqDim(ncid,ycD);
zcD = netcdf.inqDimID(ncid,'zc');
[~, kmax] = netcdf.inqDim(ncid,zcD);

os.U = netcdf.getVar(ncid, netcdf.inqVarID(ncid, 'U'), [0 0 0 sample], [imax jmax kmax 1]);
os.U = os.U(1:end-1,:,:);
os.V = netcdf.getVar(ncid, netcdf.inqVarID(ncid, 'V'), [0 0 0 sample], [imax jmax kmax 1]);
os.V = os.V(:,1:end-1,:);
os.E = netcdf.getVar(ncid, netcdf.inqVarID(ncid, 'E'), [0 0 sample], [imax jmax 1]);
os.T = netcdf.getVar(ncid, netcdf.inqVarID(ncid, 'T'), [0 0 0 sample], [imax jmax kmax 1]);
os.S = netcdf.getVar(ncid, netcdf.inqVarID(ncid, 'S'), [0 0 0 sample], [imax jmax kmax 1]);
os.W = zeros(imax,jmax,kmax+1);
layerDepths = netcdf.getVar(ncid, netcdf.inqVarID(ncid, 'zc'));
depth = netcdf.getVar(ncid, netcdf.inqVarID(ncid, 'depth'));