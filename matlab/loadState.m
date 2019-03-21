
function [os, layerDepths] = loadState(filename, sample);

os = OceanState();

ncid = netcdf.open(filename,'NOWRITE');
if sample < 0
   timeD = netcdf.inqDimID(ncid,'time');
   [~, sample] = netcdf.inqDim(ncid, timeD);
   sample = sample-1;
end
xcD = netcdf.inqDimID(ncid,'xc');
[~, imax] = netcdf.inqDim(ncid,xcD);
ycD = netcdf.inqDimID(ncid,'yc');
[~, jmax] = netcdf.inqDim(ncid,ycD);
zcD = netcdf.inqDimID(ncid,'zc');
[~, kmax] = netcdf.inqDim(ncid,zcD);
sample

os.U = netcdf.getVar(ncid, netcdf.inqVarID(ncid, 'U'), [0 0 0 sample], [imax jmax kmax 1]);
os.U = os.U(1:end-1,:,:);
os.V = netcdf.getVar(ncid, netcdf.inqVarID(ncid, 'V'), [0 0 0 sample], [imax jmax kmax 1]);
os.V = os.V(:,1:end-1,:);
os.E = netcdf.getVar(ncid, netcdf.inqVarID(ncid, 'E'), [0 0 sample], [imax jmax 1]);
os.T = netcdf.getVar(ncid, netcdf.inqVarID(ncid, 'T'), [0 0 0 sample], [imax jmax kmax 1]);
os.S = netcdf.getVar(ncid, netcdf.inqVarID(ncid, 'S'), [0 0 0 sample], [imax jmax kmax 1]);
layerDepths = netcdf.getVar(ncid, netcdf.inqVarID(ncid, 'zc'));