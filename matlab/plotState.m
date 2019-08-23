function plotState(os, imax, jmax, kmax, depth, layerDepths);

global h1 h2;

figure(h1);
inds = depth==0;
imid = floor(imax/2);
jmid = floor(jmax/2);
xval = 1:imax;
yval = 1:jmax;
snitt = permute(os.T(imid,:,:),[3 2 1]);
subplot(2,3,1), pcolor(yval, layerDepths, snitt), colorbar, shading flat
set(gca,'YDir','reverse');
title('Temperature');
snitt = permute(os.S(imid,:,:),[3 2 1]);
subplot(2,3,2), pcolor(yval, layerDepths, snitt), colorbar, shading flat
set(gca,'YDir','reverse');
title('Salinity');
pad = 1;
inds2 = depth(1+pad:end-pad,1+pad:end-pad)==0;
snitt = permute(os.T(1+pad:end-pad,1+pad:end-pad,1),[2 1 3]);
snitt(inds2) = NaN;
subplot(2,3,4), pcolor(snitt), colorbar, shading flat
%set(gca,'YDir','reverse');
title('Temperature');
snitt = permute(os.S(1+pad:end-pad,1+pad:end-pad,1),[2 1 3]);
snitt(inds2') = NaN;
subplot(2,3,5), pcolor(snitt), colorbar, shading flat
%set(gca,'YDir','reverse');
title('Salinity');
snitt = permute(os.S(1+pad:end-pad,1+pad:end-pad,2),[2 1 3]);
snitt(inds2') = NaN;
subplot(2,3,6), pcolor(snitt), colorbar, shading flat
%set(gca,'YDir','reverse');
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
figure(h2);
subs = 2;
kval = [1 2 3 4 5 6 7 8 9 10];
for i=1:10
    k = kval(i);
    subplot(3,4,i);
    [uu,vv, t1, t2] = interpolateUV(os.U(:,:,k), os.V(:,:,k), subs);
    inds = uu==0 & vv==0;
    uu(inds) = NaN;
    vv(inds) = NaN;
    hold off;
    pcolor(t1', t2', sqrt(uu.^2 + vv.^2)'), shading flat, colorbar
    hold on, quiver(t1'+subs*0.5,t2'+subs*0.5, uu',vv','k'); %mesh(U(:,:,1)');
    title(['Current k=' num2str(k)]);
end
