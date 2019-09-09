function ro= dens(S,T)
% beregner tetthet ut fra den "eksakte" foemelen
% ro= dens(S,T);

if all(isnan(S))
   ro=NaN*ones(size(S));
   return
end

[M1 M2] = maxmin(T);
if M1 > 30 || M2 < -2
   error('dens: Temperature out of range')
end
[M1 M2] = maxmin(S);
if M1 > 50 || M2 < 0
   error('dens: Salinity out of range')
end

	T3 = T.*T.*T;
        ro = 999.842594 + 6.793952E-2 * T ...
     	     	 - 9.095290E-3 * T.*T    + 1.001685E-4 * T3 ...     
     		 - 1.120083E-6 * T3.*T   + 6.536332E-9 * T3.*T.*T...
     	         + 8.24493E-1 * S        - 4.0899E-3 * T.*S ...
     	         + 7.6438E-5 * T.*T.*S   - 8.2467E-7 * T3.*S ... 
     	         + 5.3875E-9 * T3.*T.*S  - 5.72466E-3 * (S.^1.5) ...
     	         + 1.0227E-4 * T.*(S.^1.5) - 1.6546E-6*T.*T.*(S.^1.5) ...
     	         + 4.8314E-4 * S.*S ;
ro=real(ro);

