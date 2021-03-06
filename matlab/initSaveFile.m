function ncid = initSaveFile(filename, imax, jmax, kmax, depth, layerDepths);

ncid = netcdf.create(filename,'CLOBBER');

timeD = netcdf.defDim(ncid,'time',netcdf.getConstant('UNLIMITED'));
xcD = netcdf.defDim(ncid,'xc', imax);
ycD = netcdf.defDim(ncid,'yc', jmax);
zcD = netcdf.defDim(ncid,'zc', kmax);

time = netcdf.defVar(ncid, 'time','double',timeD);
zc = netcdf.defVar(ncid, 'zc','double',zcD);
vDepth = netcdf.defVar(ncid, 'depth','double',[xcD ycD]);
u = netcdf.defVar(ncid, 'U','double',[xcD ycD zcD timeD]);
v = netcdf.defVar(ncid, 'V','double',[xcD ycD zcD timeD]);
e = netcdf.defVar(ncid, 'E','double',[xcD ycD timeD]);
sal = netcdf.defVar(ncid, 'S', 'double', [xcD ycD zcD timeD]);
temp = netcdf.defVar(ncid, 'T', 'double', [xcD ycD zcD timeD]);
netcdf.endDef(ncid);
netcdf.putVar(ncid, vDepth, depth);
netcdf.putVar(ncid, zc, layerDepths);
netcdf.close(ncid);