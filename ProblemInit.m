function [params, beacon, distToRover, noisedDistToRover, roverInitPosition] = ...
          ProblemInit(anchQty, probDim, gridDensity, noiseAmp)
%ProblemInit sets up the problem of a point(rover) in a probDim space.
%The given parameters are a set of anchors with their coordinates and distances
%to said anchors. Anchors are palced on a grid with coordinates -10...10 with a
%variance of 1/gridDensity between the two closest possible positions. 
%noiseAmp sets an order of magnitude for the noise in an array of noised
%distances.
%   params - struct with parameters of the problem. Contains the dimension, 
%   the grid density, the quantity of anchors and the grid,  where all the
%   anchors and the point are positioned.
%
%   beacon - an array of coordinates of anchors. Beacons are placed randomly on
%   the grid
%       [1, 1] [1, 2] [1, 3] - set of coordinates of the 1st anchor
%       the first 4 beacons are placed in corners of the grid
%   
%   distToRover - an array of distances between every anchor and the point of
%   interest
%   
%   noisedDistTiRover - an array of distances with an added noise.
%   
%   roverInitPosition - an original position of a point of interest.

%%   setting up the space and the initial POI position  
params.anchorQuantity = anchQty;
params.problemDim = probDim;
params.spaceFineness = gridDensity; %a density of the grid we place anchors and the POI on

params.space.x = linspace(-10, 10, params.spaceFineness);
params.space.y = linspace(-10, 10, params.spaceFineness);
params.space.z = linspace(-10, 10, params.spaceFineness);

roverInitPosition.x = params.space.x(randi(size(params.space.x)));
roverInitPosition.y = params.space.y(randi(size(params.space.y)));
if params.problemDim == 2
    roverInitPosition.z = 0;
elseif params.problemDim == 3
    roverInitPosition.z = params.space.z(randi(size(params.space.y)));
else
    error('Error. Set the dimension of a problem at 2 or 3.');
end
%% initializing the vital variables
distToRover = zeros(1,params.anchorQuantity);
noisedDistToRover = distToRover;
beacon = zeros(params.anchorQuantity,params.problemDim);
% to reproduce random values, seedNoise and rndms are ought to be exported from function's workspace
seedNoise = rng(1);
rndms = RandomSet(seedNoise);
%
%% setting up anchors, calculating the distance, adding noise
seedAnchs = rng('default');
if params.problemDim == 2
    for i = 1:params.anchorQuantity
        beacon(i,1) = params.space.x(randi(size(params.space.x)));
        beacon(i,2) = params.space.y(randi(size(params.space.y)));
        beacon(i,3) = 0;
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
        noisedDistToRover(i) = AddNoise(distToRover(i), rndms, noiseAmp);
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
        noisedDistToRover(i) = AddNoise(distToRover(i), rndms, noiseAmp);
    end
else
    error('Error. Set the dimension of a problem at 2 or 3.');
end
end

function noised = AddNoise(dist, randomSet, fineness)
%fineness regulates an amplitude of the noise. 10 would set an amplitude of a
%magnitude of 10^-4 ... 10^-3
    noised = dist + randomSet(randi(numel(randomSet)))./fineness;
end

function rndSet = RandomSet(seed)
    rng(seed);
    rndSet = imag(ifft(randn(1,3000)));
end

