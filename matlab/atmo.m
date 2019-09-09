% Update wind forcing, if active.

% Return if wind is disabled:
if sp.atmoOn <= 0
   return;    
end

% Set wind, if there are instructions for the current scenario:
switch sp.scenario
    case 'channel'
        if ~exist('wCorners')
            wCorners = zeros(4,2);
            coords = [1 1; 1 sp.jmax; sp.imax 1; sp.imax sp.jmax]; 
            [mshX,mshY] = meshgrid(1:sp.jmax, 1:sp.imax);
        end
        wC = normrnd(0,8,4,2)
        updFac = 0.15;
        wCorners = updFac*wC + (1-updFac)*wCorners;
        Fu = scatteredInterpolant(coords, wCorners(:,1));
        Fv = scatteredInterpolant(coords, wCorners(:,2));
        os.windU = Fu(mshX, mshY);
        os.windV = Fv(mshX, mshY);
    case 'real' 
        if ~exist('wCorners','var')
            wCorners = zeros(5,2);
            coords = [1 1; 1 sp.jmax; sp.imax 1; sp.imax sp.jmax; sp.imax/2 sp.jmax/2]; 
            [mshX,mshY] = meshgrid(1:sp.jmax, 1:sp.imax);
        end
        wC = normrnd(0,12,size(coords,1),2)
        updFac = 0.15;
        wCorners = updFac*wC + (1-updFac)*wCorners;
        Fu = scatteredInterpolant(coords, wCorners(:,1));
        Fv = scatteredInterpolant(coords, wCorners(:,2));
        os.windU = Fu(mshX, mshY);
        os.windV = Fv(mshX, mshY);
    case 'turbChannel' 
        if ~exist('wCorners','var')
            wCorners = zeros(5,2);
            coords = [1 1; 1 sp.jmax; sp.imax 1; sp.imax sp.jmax; sp.imax/2 sp.jmax/2]; 
            [mshX,mshY] = meshgrid(1:sp.jmax, 1:sp.imax);
        end
        wC = normrnd(0,12,size(coords,1),2)
        updFac = 0.15;
        wCorners = updFac*wC + (1-updFac)*wCorners;
        Fu = scatteredInterpolant(coords, wCorners(:,1));
        Fv = scatteredInterpolant(coords, wCorners(:,2));
        os.windU = Fu(mshX, mshY);
        os.windV = Fv(mshX, mshY);
    case 'upwelling'
        os.windU = 0*os.windU + 10;
        os.windV = 0*os.windV;
end

% Set wind stress as function of wind speed:
sp.windStressU = 0.0002*os.windU;
sp.windStressV = 0.0002*os.windV;
