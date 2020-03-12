clear 
close all 
% 
ProblemInit;
distNoise = addnoise(distToRover, 10);
[eqns, phi,chi] = numericEqns(params,beacon,distNoise);

plotSpace(beacon, eqns, roverInitPosition,space);

solut = circleIntersect(eqns, phi, chi);

function [rad,phi,chi] = numericEqns(params,beacon,distToRover)
    syms chi phi 
    for i = 1:params.anchorQuantity
        rad(i) = (beacon(i,1)-chi)^2 + (beacon(i,2)-phi)^2 == distToRover(i)^2;
    end
end

function pts = circleIntersect(eqns, phi,chi)
pts = cell(numel(eqns));
for i = 1:numel(eqns)
    for j = i+1:numel(eqns)
        pts{j,i} = solve([eqns(i) eqns(j)],[chi phi]);
        pts{i,j}.phi = double(pts{j,i}.phi);
        pts{i,j}.chi = double(pts{j,i}.chi);
        pts{i,j}.sol1 = [pts{i,j}.chi(1) pts{i,j}.phi(1)];
        pts{i,j}.sol2 = [pts{i,j}.chi(2) pts{i,j}.phi(2)];
    end
end
end

function plotSpace(beacons,circles,rover,space)
    scatter(beacons(:,1),beacons(:,2),'x','magenta');
    hold on
    scatter(rover.x,rover.y,...
          'diamond','black','filled');
    title('Initial Space')
    xlabel('\chi');
    ylabel('\phi')
    fimplicit(circles(:), [min(space.x) max(space.x)]);
    hold off
    grid on
end

function err = calcError(roverInit, roverAcq)
    err = norm([roverInit.x; roverInit.y] - ...
               [roverAcq.x;  roverAcq.y]);
end

function noised = addnoise(dist, fineness)
    randoms = imag(ifft(randn(1,100500)));
    noised = dist + randoms(randi(numel(randoms)))./fineness;
end