
depth = 75*ones(imax,jmax);
dd = [0 8 20 40 65];

jinds = floor(jmax*0.45):ceil(jmax*0.55);
iinds = 1:floor(imax*0.2);
depth(1:iinds(end)-1,:) = 0*depth(1:iinds(end)-1,:);
for pad=1:length(dd)
   depth(iinds(end)-2+pad,pad:end-(pad-1)) = dd(pad);
   depth(end-(pad-1),pad:end-(pad-1)) = dd(pad);
   depth(iinds(end)-2+pad:end-(pad-1),pad) = dd(pad);
   depth(iinds(end)-2+pad:end-(pad-1),end-(pad-1)) = dd(pad);
end
depth(iinds,jinds) = 25*ones(size(depth(iinds,jinds)));
%figure,mesh(-depth')
