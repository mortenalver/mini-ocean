function plotState(os, imax, jmax, kmax, depth, layerDepths);
figure(gcf);
inds = depth==0;
jmid = floor(jmax/2);
xval = 1:imax;
snitt = permute(os.T(:,jmid,:),[3 1 2]);
subplot(2,3,1), pcolor(xval, layerDepths, snitt), colorbar, shading flat
set(gca,'YDir','reverse');
title('Temperature');
snitt = permute(os.S(:,jmid,:),[3 1 2]);
subplot(2,3,2), pcolor(xval, layerDepths, snitt), colorbar, shading flat
set(gca,'YDir','reverse');
title('Salinity');
snitt = permute(os.T(:,:,1),[2 1 3]);
snitt(inds') = NaN;
subplot(2,3,4), pcolor(snitt), colorbar, shading flat
set(gca,'YDir','reverse');
title('Temperature');
snitt = permute(os.S(:,:,1),[2 1 3]);
snitt(inds') = NaN;
subplot(2,3,5), pcolor(snitt), colorbar, shading flat
set(gca,'YDir','reverse');
title('Salinity');
subplot(2,3,3),
% snitt = permute(os.U(:,jmid,:),[3 1 2]);
% pcolor(xval(1:end-1), layerDepths, snitt), colorbar, shading flat
% set(gca,'YDir','reverse');
% title('U current');
% ca = caxis;
% caxis([-max(abs(ca)) max(abs(ca))]);
snitt = os.E';
snitt(inds') = NaN;
pcolor(snitt), colorbar, shading flat;
title('Elevation');
subplot(2,3,6), 
subs = 1;
[uu,vv, t1, t2] = interpolateUV(os.U(:,:,1), os.V(:,:,1), subs);
uu(inds) = NaN;
vv(inds) = NaN;
pcolor(t1', t2', sqrt(uu.^2 + vv.^2)'), shading flat, colorbar
hold on, quiver(t1'+subs*0.5,t2'+subs*0.5, uu',vv','k'); %mesh(U(:,:,1)');
title('Current');
