%e_val = 1*cos(sample*dt/750);
e_val = 0.25;
% E(1,:) = 0.5*e_val*ones(jmax,1);
% E(end,:) = -0.5*e_val*ones(jmax,1);
% for i=1:imax-1
%     E(i,1) = e_val*(imax*0.5-i)/imax;
%     E(i,end) = e_val*(imax*0.5-i)/imax;
% end

E(1,:) = sin(1*sample*sp.dt*2*pi/(12*3600));
%E(1,1:8) = sin(1*sample*sp.dt*2*pi/(12*3600));
%E(1,9:end) = 0*E(1,9:end);

% E(1,:) = E(2,:);
% E(imax,:) = E(imax-1,:);
% E(:,1) = E(:,2);
% E(:,jmax) = E(:,jmax-1);

%U(1,:,:) = U(2,:,:);

% U(1,:,:) = 0.2*ones(size(U(1,:,:)));
% interv = floor(jmax/4):floor(3*jmax/4);
% U(1,interv,:) = 0.17*ones(size(U(1,interv,:)));
% U(imax-1,:,:) = 0.2*ones(size(U(imax-1,:,:)));
% U(:,1,:) = 0.2*ones(size(U(:,1,:)));
% U(:,jmax,:) = 0.2*ones(size(U(:,jmax,:)));
% 
% V(1,:,:) = 0*ones(size(V(1,:,:)));
% V(imax,:,:) = -0*.1*ones(size(V(imax,:,:)));
% for i=1:imax
%     V(i,1,:) = (0.15*i/imax)*ones(size(V(i,1,:)));
%     V(i,jmax-1,:) = -0*(0.1*i/imax)*ones(size(V(i,jmax-1,:)));
% end
% 
% for k=1:kmax
%     S(1,:,k) = s_int(k)*ones(size(S(1,:,k)));
%     S(imax,:,k) = s_int(k)*ones(size(S(imax,:,k)));
%     S(:,1,k) = (s_int(k)-2)*ones(size(S(:,1,k)));
%     S(:,jmax,k) = s_int(k)*ones(size(S(:,jmax,k)));
%     
%     %interv = floor(1.5*jmax/4):floor(2.5*jmax/4);
%     %S(1,interv,k) = (s_int(k)-1)*ones(size(S(1,interv,k)));
%     
%     T(1,:,k) = t_int(k)*ones(size(T(1,:,k)));
%     T(imax,:,k) = t_int(k)*ones(size(T(imax,:,k)));
%     T(:,1,k) = (t_int(k)-2)*ones(size(T(:,1,k)));
%     T(:,jmax,k) = t_int(k)*ones(size(T(:,jmax,k)));
% end