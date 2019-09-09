function plotTimeSeries(filename,variable, coord, figHandle);

ncid = netcdf.open(filename,'NOWRITE');
timeD = netcdf.inqDimID(ncid,'time');
[~, nSamples] = netcdf.inqDim(ncid, timeD);
zD = netcdf.inqDimID(ncid,'zc');
[~, kmax] = netcdf.inqDim(ncid, zD);


% Find variable's number of dimensions:
varid = netcdf.inqVarID(ncid, variable);
[~,~,dimids,natts] = netcdf.inqVar(ncid,varid);

% Read time:
t = (netcdf.getVar(ncid,netcdf.inqVarID(ncid, 'time'), 0, nSamples))/3600;

if length(dimids)==3
    series = netcdf.getVar(ncid, varid, [coord(1) coord(2) 0], [1 1 nSamples]);
    series = permute(series,[3 1 2]);
else
    if length(coord) > 2
        series = netcdf.getVar(ncid, varid, [coord(1) coord(2) coord(3) 0], [1 1 1 nSamples]);
        series = permute(series,[4 1 2 3]);
    else
        series = netcdf.getVar(ncid, varid, [coord(1) coord(2) 0 0], [1 1 kmax nSamples]);
        series = permute(series,[3 4 1 2]);
    end
end
netcdf.close(ncid);

if nargin < 4
    figHandle = figure;
end
figure(figHandle),plot(t,series), grid, xlabel('Time (h)'), title(variable);
