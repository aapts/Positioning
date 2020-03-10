ProblemInit;

plotSpace(beacon, roverInitPosition);
distNoise = addnoise(distToRover, space, 100);

syms xi phi 
for i = 1:params.anchorQuantity
    circle(i,1) = (beacon(i,1)-xi)^2 + (beacon(i,2)-phi)^2 == distToRover(i)^2;
    hold on 
    fplot(circle(i,1));
end
function plotSpace(beacons,rover)
    scatter(beacons(:,1),beacons(:,2),'x','magenta');
    hold on
    scatter(rover.x,rover.y,...
          'diamond','black','filled');
    title('Initial Space')
    xlabel('X axis');
    ylabel('Y axis')
    hold off
end

function err = calcError(roverInit, roverAcq)
    err = norm([roverInit.x; roverInit.y] - ...
               [roverAcq.x;  roverAcq.y]);
end

function noised = addnoise(dist, space, fineness)
    noised = dist+ 1 * max(space.x)/numel(space.x) + randn / fineness;
end