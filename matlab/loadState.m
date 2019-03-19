
function [U, V, E, T, S] = loadState(filename, sample);

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

U = netcdf.getVar(ncid, netcdf.inqVarID(ncid, 'U'), [0 0 0 sample], [imax jmax kmax 1]);
U = U(1:end-1,:,:);
V = netcdf.getVar(ncid, netcdf.inqVarID(ncid, 'V'), [0 0 0 sample], [imax jmax kmax 1]);
V = V(:,1:end-1,:);
E = netcdf.getVar(ncid, netcdf.inqVarID(ncid, 'E'), [0 0 sample], [imax jmax 1]);
T = netcdf.getVar(ncid, netcdf.inqVarID(ncid, 'T'), [0 0 0 sample], [imax jmax kmax 1]);
S = netcdf.getVar(ncid, netcdf.inqVarID(ncid, 'S'), [0 0 0 sample], [imax jmax kmax 1]);