clear 
close all 
ProblemInit;

distNoise = addnoise(distToRover, space, 100);

syms chi phi 
for i = 1:params.anchorQuantity
    rad(i) = (beacon(i,1)-chi)^2 + (beacon(i,2)-phi)^2 == distToRover(i)^2;
end

plotSpace(beacon, rad, roverInitPosition,space);
solut = zeros(numel(rad));

for i = 1:numel(rad)
  if i<numel(rad)
    for j = i:numel(rad)
        slv = solve([rad(i) rad(j)],[phi chi]);
        solut(i,1) = double(slv.chi);
        solut(i,2) = double(slv.phi);
    end    
  else
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
    noised = dist+ 1 * max(space.x)/numel(space.x) + randn / fineness;
end