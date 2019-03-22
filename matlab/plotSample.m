function plotSample(filename, sample);

[os, nSamplesInFile, depth, layerDepths] = loadState(filename, sample);
nSamplesInFile
sz = size(os.T);
imax = sz(1);
jmax = sz(2);
kmax = sz(3);

plotState(os, imax, jmax, kmax, depth, layerDepths);