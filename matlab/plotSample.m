function plotSample(filename, sample);

[os, layerDepths] = loadState(filename, sample);
sz = size(os.T);
imax = sz(1);
jmax = sz(2);
kmax = sz(3);
jmid = floor(jmax/2);
xval = 1:imax;
figure 
snitt = permute(os.T(:,jmid,:),[3 1 2]);
subplot(2,2,1), pcolor(xval, layerDepths, snitt), colorbar, shading flat
set(gca,'YDir','reverse');
title('Temperature');
snitt = permute(os.S(:,jmid,:),[3 1 2]);
subplot(2,2,2), pcolor(xval, layerDepths, snitt), colorbar, shading flat
set(gca,'YDir','reverse');
title('Salinity');
snitt = permute(os.U(:,jmid,:),[3 1 2]);
subplot(2,2,3), pcolor(xval(1:end-1), layerDepths, snitt), colorbar, shading flat
set(gca,'YDir','reverse');
title('U current');