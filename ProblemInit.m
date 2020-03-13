params.anchorQuantity = 10;
params.problemDim = 3;
params.spaceFineness = 1500;

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
        distToRover(i) = norm ([roverInitPosition.x;roverInitPosition.y;roverInitPosition.z] - ...
                               [beacon(i,1);beacon(i,2);beacon(i,3)]);
    end
else
    error('Error. Set the dimension of a problem at 2 or 3.');
end
clear i