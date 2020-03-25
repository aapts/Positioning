function [beacon, distToRover, params, roverInitPosition] = ...
          ProblemInit(anchQty, probDim, gridDensity)
%ProblemInit sets up the problem of a point(rover) in a probDim space.
%The given parameters are a set of anchors with their coordinates and distances
%to said anchors. Anchors are palced on a grid with coordinates -10...10 with a
%variance of 1/gridDensity between the two closest possible positions
%   beacon - an array of coordinates of anchors. Beacons are placed randomly on
%   the grid
%       [1, 1] [1, 2] [1, 3] - set of coordinates of the 1st anchor
%       the first 4 beacons are placed in corners of the grid
%   
%   distToRover - an array of distances between every anchor and the point of
%   interest
%   
%   params - struct with parameters of the problem. Contains the dimension, 
%   the grid density, the quantity of anchors and the grid,  where all the
%   anchors and the point are positioned. 
%   
%   roverInitPosition - an original position of a point of interest.


%%     
params.anchorQuantity = anchQty;
params.problemDim = probDim;
params.spaceFineness = gridDensity;

params.space.x = linspace(-10, 10, params.spaceFineness);
params.space.y = linspace(-10, 10, params.spaceFineness);
params.space.z = linspace(-10, 10, params.spaceFineness);

roverInitPosition.x = params.space.x(randi(size(params.space.x)));
roverInitPosition.y = params.space.y(randi(size(params.space.y)));
roverInitPosition.z = 0;
distToRover = zeros(1,params.anchorQuantity);
beacon = zeros(params.anchorQuantity,params.problemDim);

if params.problemDim == 2
    for i = 1:params.anchorQuantity
        beacon(i,1) = params.space.x(randi(size(params.space.x)));
        beacon(i,2) = params.space.y(randi(size(params.space.y)));
    end
    beacon(1,1) = min(params.space.x);
    beacon(1,2) = min(params.space.y);

    beacon(2,1) = min(params.space.x);
    beacon(2,2) = max(params.space.y);

    beacon(3,1) = max(params.space.x);
    beacon(3,2) = max(params.space.y);

    beacon(4,1) = max(params.space.x);
    beacon(4,2) = min(params.space.y);
    for i = 1:params.anchorQuantity
        distToRover(i) = norm ([roverInitPosition.x; roverInitPosition.y] - ...
                               [beacon(i,1); beacon(i,2)]);
    end
elseif params.problemDim == 3
    for i = 1:params.anchorQuantity
        beacon(i,1) = params.space.x(randi(size(params.space.x)));
        beacon(i,2) = params.space.y(randi(size(params.space.y)));
        beacon(i,3) = params.space.z(randi(size(params.space.y)));
    end
    beacon(1,1) = min(params.space.x);
    beacon(1,2) = min(params.space.y);
    beacon(1,3) = min(params.space.z);
    beacon(2,1) = min(params.space.x);
    beacon(2,2) = max(params.space.y);
    beacon(2,3) = min(params.space.z);
    beacon(3,1) = max(params.space.x);
    beacon(3,2) = max(params.space.y);
    beacon(3,3) = min(params.space.z);    
    beacon(4,1) = max(params.space.x);
    beacon(4,2) = min(params.space.y);
    beacon(4,3) = min(params.space.z);

    for i = 1:params.anchorQuantity
        distToRover(i) = norm ([roverInitPosition.x;roverInitPosition.y;roverInitPosition.z] - ...
                               [beacon(i,1);beacon(i,2);beacon(i,3)]);
    end
else
    error('Error. Set the dimension of a problem at 2 or 3.');
end
end