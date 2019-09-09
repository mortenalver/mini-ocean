os = os.updateCellHeights(kmm, dzz, sp);

ilim = [15 25]; jlim = [40 jmax-1]; klim = [2 4];

meanVEdges = zeros(6,1);
netFlow = zeros(6,1);

% Left and right edges:
nf1=0; nf2=0;
spd1=0; spd2=0;
count = 0;
for j=jlim(1):jlim(2)
    for k=klim(1):klim(2)
        count = count+1;
        i = ilim(1);
        spd1 = spd1 + os.U(i-1,j,k);
        vsize = 0.5*(os.cellHeights(i-1,j,k)+os.cellHeights(i,j,k));           
        nf1 = nf1 + sp.dx*vsize*os.U(i-1,j,k);
        i = ilim(2);
        spd2 = spd2 + os.U(i,j,k);
        vsize = 0.5*(os.cellHeights(i,j,k)+os.cellHeights(i+1,j,k));
        nf2 = nf2 - sp.dx*vsize*os.U(i,j,k);
    end
end
west = nf1
east = nf2
netFlow(1:2) = [nf1; nf2];
meanVEdges(1:2) = [spd1; spd2];
% Upper and lower edges (horizontally):
nf1=0; nf2=0;
spd1=0; spd2=0;
count = 0;
for i=ilim(1):ilim(2)
    for k=klim(1):klim(2)
        count = count+1;
        j = jlim(1);
        spd1 = spd1 + os.V(i,j-1,k);
        vsize = 0.5*(os.cellHeights(i,j-1,k)+os.cellHeights(i,j,k));           
        nf1 = nf1 + sp.dx*vsize*os.V(i,j-1,k);
        j = jlim(2);
        spd2 = spd2 + os.V(i,j,k);
        vsize = 0.5*(os.cellHeights(i,j,k)+os.cellHeights(i,j+1,k));
        nf2 = nf2 - sp.dx*vsize*os.V(i,j,k);
    end
end
south = nf1
north = nf2
netFlow(3:4) = [nf1; nf2];
meanVEdges(3:4) = [spd1; spd2];
% Upper and lower edges (vertically):
nf1=0; nf2=0;
spd1=0; spd2=0;
count = 0;
for i=ilim(1):ilim(2)
    for j=jlim(1):jlim(2)
        count = count+1;
        k = klim(2);
        spd1 = spd1 + os.W(i,j,k+1);
        nf1 = nf1 + sp.dx^2*os.W(i,j,k+1);
        k = klim(1);
        spd2 = spd2 + os.W(i,j,k);
        nf2 = nf2 - sp.dx^2*os.W(i,j,k);
    end
end
below = nf1
above = nf2
netFlow(5:6) = [nf1; nf2];
meanVEdges(5:6) = [spd1; spd2];

balance = sum(netFlow)
meanVEdges