
os.X = zeros(sp.imax, sp.jmax, sp.kmax);

switch sp.scenario
    case 'load depths'
        point = [5 floor(sp.jmax/2)];
        for k=1:kmm(point(1), point(2))
            os.X(point(1), point(2), k) = 1;
        end
end