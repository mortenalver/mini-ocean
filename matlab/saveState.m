function saveState(filename, imax, jmax, kmax, time, os);

ncid = netcdf.open(filename,'WRITE');

tdim = netcdf.inqDimID(ncid,'time');
[name, index] = netcdf.inqDim(ncid,tdim);

index = index;

netcdf.putVar(ncid, netcdf.inqVarID(ncid, 'time'), index, 1, time);
tmp = zeros(imax,jmax,kmax);
tmp(1:imax-1,:,:) = os.U;
netcdf.putVar(ncid, netcdf.inqVarID(ncid, 'U'), [0 0 0 index], [imax jmax kmax 1], tmp);
tmp = zeros(imax,jmax,kmax);
tmp(:,1:jmax-1,:) = os.V;
netcdf.putVar(ncid, netcdf.inqVarID(ncid, 'V'), [0 0 0 index], [imax jmax kmax 1], tmp);
netcdf.putVar(ncid, netcdf.inqVarID(ncid, 'E'), [0 0 index], [imax jmax 1], os.E);
netcdf.putVar(ncid, netcdf.inqVarID(ncid, 'T'), [0 0 0 index], [imax jmax kmax 1], os.T);
netcdf.putVar(ncid, netcdf.inqVarID(ncid, 'S'), [0 0 0 index], [imax jmax kmax 1], os.S);

netcdf.close(ncid);

