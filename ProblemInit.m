params.anchorQuantity = 5;
params.problemDim = 2;
params.spaceFineness = 1500;

space.x = linspace(-10, 10, params.spaceFineness);
space.y = linspace(-10, 10, params.spaceFineness);
space.z = linspace(-10, 10, params.spaceFineness);

roverInitPosition.x = space.x(randi(size(space.x)));
roverInitPosition.y = space.y(randi(size(space.y)));
roverInitPosition.z = space.z(randi(size(space.z)));
distToRover = zeros(1,params.anchorQuantity);
beacon = zeros(params.anchorQuantity,params.problemDim);

if params.problemDim == 2
    for i = 1:params.anchorQuantity
        beacon(i,1) = space.x(randi(size(space.x)));
        beacon(i,2) = space.y(randi(size(space.y)));
    end
    beacon(1,1) = min(space.x);
    beacon(1,2) = min(space.y);

    beacon(2,1) = min(space.x);
    beacon(2,2) = max(space.y);

    beacon(3,1) = max(space.x);
    beacon(3,2) = max(space.y);

    beacon(4,1) = max(space.x);
    beacon(4,2) = min(space.y);
    for i = 1:params.anchorQuantity
        distToRover(i) = norm ([roverInitPosition.x; roverInitPosition.y] - ...
                               [beacon(i,1); beacon(i,2)]);
    end
elseif params.problemDim == 3
    for i = 1:params.anchorQuantity
        beacon(i,1) = space.x(randi(size(space.x)));
        beacon(i,2) = space.y(randi(size(space.y)));
        beacon(i,3) = space.z(randi(size(space.z)));
    end
    beacon(1,1) = min(space.x);
    beacon(1,2) = min(space.y);
    beacon(1,3) = min(space.z);
    
    beacon(2,1) = min(space.x);
    beacon(2,2) = max(space.y);
    beacon(2,3) = min(space.z);
    
    beacon(3,1) = max(space.x);
    beacon(3,2) = max(space.y);
    beacon(3,3) = min(space.z);
    
    beacon(4,1) = max(space.x);
    beacon(4,2) = min(space.y);
    beacon(4,3) = min(space.z);
    for i = 1:params.anchorQuantity
        distToRover(i) = norm ([roverInitPosition.x;roverInitPosition.y;roverInitPosition.z] - ...
                               [beacon(i,1);beacon(i,2);beacon(i,3)]);
    end
else error('Error. Set the dimension of a problem at 2 or 3.');
end
clear i