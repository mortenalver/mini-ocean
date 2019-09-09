
function compareStates(filename1, sample1, filename2, sample2);

[os1, nSamplesInFile, depth, layerDepths] = loadState(filename1, sample1);
[os2, nSamplesInFile, depth, layerDepths] = loadState(filename2, sample2);

sz = size(os1.T);
imax = sz(1);
jmax = sz(2);
kmax = sz(3);

figure;
subs = 1;
mult = 2;
dpt = depth(1:subs:end,1:subs:end);
kval = [1 6];
contourLevs = [200 500 1000 1500];
cols = 1+2*length(kval);
for i=1:length(kval)
    k = kval(i);
    [uu1,vv1, t1, t2] = interpolateUV(os1.U(:,:,k), os1.V(:,:,k), subs);
    [uu2,vv2, t1, t2] = interpolateUV(os2.U(:,:,k), os2.V(:,:,k), subs);
%     cc1 = curl(uu1,vv1);
%     cc2 = curl(uu2,vv2);
    
    inds = uu2==0 & vv2==0;
    uu1(inds) = NaN;
    vv1(inds) = NaN;
    uu2(inds) = NaN;
    vv2(inds) = NaN;
    
%     cc1(inds) = NaN;
%     cc2(inds) = NaN;
    subplot(3,cols,i);
    hold off;
    pcolor(t1', t2', sqrt(uu1.^2 + vv1.^2)'), shading flat, colorbar, hold on
    [contr, hh] = contour(dpt',contourLevs,'k');
    caxis([0.1 1]);
    quiver(t1'+subs*0.5,t2'+subs*0.5, uu1',vv1',mult,'k'); %mesh(U(:,:,1)');
    title(['State 1, k=' num2str(k)]);
    subplot(3,cols,length(kval)+i)
    pcolor(t1', t2', os1.S(1:subs:end,1:subs:end,1)'), shading flat, colorbar
    %caxis([-0.1 0.1]);
    title(['S 1, k=' num2str(k)]);
    subplot(3,cols,cols+i);
    hold off;
    pcolor(t1', t2', sqrt(uu2.^2 + vv2.^2)'), shading flat, colorbar, hold on
    [contr, hh] = contour(dpt',contourLevs,'k');
    caxis([0.1 1]);
    quiver(t1'+subs*0.5,t2'+subs*0.5, uu2',vv2',mult,'k'); %mesh(U(:,:,1)');
    title(['State 2, k=' num2str(k)]);
    subplot(3,cols,cols+length(kval)+i)
    pcolor(t1', t2', os2.S(1:subs:end,1:subs:end,1)'), shading flat, colorbar
    %caxis([-0.1 0.1]);
    title(['S 2, k=' num2str(k)]);
    subplot(3,cols,2*cols+i);
    hold off;
    diffield = sqrt((uu2-uu1).^2 + (vv2-vv1).^2)';
    pcolor(t1', t2', diffield), shading flat, colorbar, hold on
    [contr, hh] = contour(dpt',contourLevs,'k');
    caxis([min(diffield(:)) max(diffield(:))]);
    hold on, quiver(t1'+subs*0.5,t2'+subs*0.5, (uu2-uu1)',(vv2-vv1)',mult,'k'); %mesh(U(:,:,1)');
    title(['Difference k=' num2str(k)]);
    subplot(3,cols,2*cols+length(kval)+i)
    pcolor(t1', t2', (os2.S(1:subs:end,1:subs:end,1)'-os1.S(1:subs:end,1:subs:end,1)')), shading flat, colorbar
    %caxis([-0.02 0.02])
    title(['S k=' num2str(k)]);
end

subplot(3,cols,cols);
hold off;
pcolor(os1.E(2:end-1,2:end-1)'), shading flat, colorbar
title('State 1, elevation');
subplot(3,cols, 2*cols);
hold off;
pcolor(os2.E(2:end-1,2:end-1)'), shading flat, colorbar
title('State 2, elevation');
subplot(3,cols,3*cols);
pcolor((os2.E(2:end-1,2:end-1)-os1.E(2:end-1,2:end-1))'), shading flat, colorbar
title('Difference, elevation');