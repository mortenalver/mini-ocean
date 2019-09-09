function X = addPassiveTracer(X,os,kmm,sp);

switch sp.scenario
    case 'load depths'
        point = [5 floor(sp.jmax/2)];
        for k=1:kmm(point(1), point(2))
            X(point(1), point(2), k) = X(point(1), point(2), k) + (1/3600)*sp.dt;
        end
    case 'channel'
        point = [2 floor(sp.jmax/2)];
        for k=1:kmm(point(1), point(2))
            X(point(1), point(2), k) = X(point(1), point(2), k) + (1/3600)*sp.dt;
        end       
end