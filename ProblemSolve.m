clear 
close all 
ProblemInit;
%% Method 1: analytical intersections of circles
distNoise = addnoise(distToRover, 10);
[eqns,chi,phi] = analyticEqns(params,beacon,distNoise);
% plotSpace(beacon, eqns, roverInitPosition,space);

ptsIntersection = circleIntersections(eqns, chi, phi, space);
roverCalcPosition = intersecionMean(ptsIntersection);
err = calcError(roverInitPosition, roverCalcPosition);
finPlotSpace(beacon, 0, roverInitPosition, roverCalcPosition,space);
%% Method 2: 

%% Functions
function [rad,chi,phi] = analyticEqns(params,beacon,distToRover)
    syms chi phi 
    rad = sym(zeros(1,params.anchorQuantity));
    for i = 1:params.anchorQuantity
        rad(i) = (beacon(i,1)-chi)^2 + (beacon(i,2)-phi)^2 == distToRover(i)^2;
    end
end

function pts = circleIntersections(eqns, chi,phi, space)
    pts = cell(numel(eqns));
    for i = 1:numel(eqns)
        for j = i+1:numel(eqns)
            pts{i,j} = solve([eqns(i) eqns(j)],[chi phi]);
            pts{j,i}.phi = double(pts{i,j}.phi);
            pts{j,i}.chi = double(pts{i,j}.chi);
            pts{j,i}.sol1 = [pts{j,i}.chi(1) pts{j,i}.phi(1)];
            pts{j,i}.sol2 = [pts{j,i}.chi(2) pts{j,i}.phi(2)];
            
            if      pts{2,1}.sol1(1) < max(space.x) &&...
                    pts{2,1}.sol1(1) > min(space.x) &&...
                    pts{2,1}.sol1(2) < max(space.y) &&...
                    pts{2,1}.sol1(2) > min(space.y) &&...
                    norm(pts{2,1}.sol1 - pts{j,i}.sol1) < 2*mean(diff(space.x))
                        pts{i,j} = pts{j,i}.sol1;
            elseif  pts{2,1}.sol2(1) < max(space.x) &&...
                    pts{2,1}.sol2(1) > min(space.x) &&...
                    pts{2,1}.sol2(2) < max(space.y) &&...
                    pts{2,1}.sol2(2) > min(space.y) &&...
                    norm(pts{2,1}.sol2 - pts{j,i}.sol2) < 2*mean(diff(space.x))
                        pts{i,j} = pts{j,i}.sol2;
            elseif  pts{2,1}.sol1(1) < max(space.x) &&...
                    pts{2,1}.sol1(1) > min(space.x) &&...
                    pts{2,1}.sol1(2) < max(space.y) &&...
                    pts{2,1}.sol1(2) > min(space.y) &&...
                    norm(pts{2,1}.sol1 - pts{j,i}.sol2) < 2*mean(diff(space.x))
                        pts{i,j} = pts{j,i}.sol2;
            elseif  pts{2,1}.sol2(1) < max(space.x) &&...
                    pts{2,1}.sol2(1) > min(space.x) &&...
                    pts{2,1}.sol2(2) < max(space.y) &&...
                    pts{2,1}.sol2(2) > min(space.y) &&...
                    norm(pts{2,1}.sol2 - pts{j,i}.sol1) < 2*mean(diff(space.x))
                        pts{i,j} = pts{j,i}.sol1;
            end
        end
    end
end

function acquiredIntersecrionPoint = intersecionMean(pts)
    acquiredIntersecrionPoint.x = 0;
    acquiredIntersecrionPoint.y = 0;
    k = 0;
    for i = 1:size(pts)
        for j = i+1:size(pts)
            acquiredIntersecrionPoint.x = pts{i,j}(1) + acquiredIntersecrionPoint.x;
            acquiredIntersecrionPoint.y = pts{i,j}(2) + acquiredIntersecrionPoint.y;
            k = k + 1;
        end
    end
    acquiredIntersecrionPoint.x = acquiredIntersecrionPoint.x / k;
    acquiredIntersecrionPoint.y = acquiredIntersecrionPoint.y / k;
end

function plotSpace(beacons,circles,roverInit,space)
    scatter(beacons(:,1),beacons(:,2),'x','magenta');
    hold on
    scatter(roverInit.x,roverInit.y,...
          'diamond','black','filled');
    title('Initial Space')
    xlabel('\chi');
    ylabel('\phi')
if circles == 0
    return
else
    fimplicit(circles(:), [min(space.x) max(space.x)]);
end
    hold off
    grid on
end

function finPlotSpace(beacons,circles,roverInit,roverCalc,space)
    hold on
    plotSpace(beacons,circles,roverInit,space)
    scatter(roverCalc.x,roverCalc.y,...
        'diamond','green');
    hold off
end

function noised = addnoise(dist, fineness)
    randoms = imag(ifft(randn(1,100500)));
    noised = dist + randoms(randi(numel(randoms)))./fineness;
end

function err = calcError(roverInit, roverAcq)
    err = norm([roverInit.x; roverInit.y] - ...
               [roverAcq.x;  roverAcq.y]);
end