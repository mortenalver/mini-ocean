function results = advectTempSalt(trc,os,kmm,sp,ilims);

%trc_next = trc;
% for part=1:npar
%     trc_next(ilims(part,1):ilims(part,2),:,:) = advectTempSalt(os.S,os,kmm,sp,ilims(part,:));
% end
npar = size(ilims,1);
%p = gcp();
% To request multiple evaluations, use a loop.
results = cell(4,1);
parfor idx = 1:npar
  results{idx} = advectTempSalt_part(trc,os,kmm,sp,ilims(idx,:)); 
end

% for idx = 1:npar
%     trc_next(ilims(idx,1):ilims(idx,2),:,:) = results{idx};
% end

