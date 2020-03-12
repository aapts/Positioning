clear 
close all 

ProblemInit;
distNoise = addnoise(distToRover, space, 100);
[rad, phi,chi] = numericEqns(params,beacon,distToRover);

plotSpace(beacon, rad, roverInitPosition,space);

solut = cell(numel(rad));
for i = 1:numel(rad)
    for j = i+1:numel(rad)
        solut{i,j} = solve([rad(i) rad(j)],[phi chi]);
        solut{j,i} = solut{i,j};
    end
end

function [rad,phi,chi] = numericEqns(params,beacon,distToRover)
    syms chi phi 
    for i = 1:params.anchorQuantity
        rad(i) = (beacon(i,1)-chi)^2 + (beacon(i,2)-phi)^2 == distToRover(i)^2;
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
end

function err = calcError(roverInit, roverAcq)
    err = norm([roverInit.x; roverInit.y] - ...
               [roverAcq.x;  roverAcq.y]);
end

function noised = addnoise(dist, space, fineness)
    noised = dist + randn / fineness;
    sigma = noised - dist
end