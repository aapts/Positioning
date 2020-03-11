params.anchorQuantity = 50;
params.problemDim = 2;
params.spaceFineness = 1500;

space.x = linspace(-10, 10, params.spaceFineness);
space.y = linspace(-10, 10, params.spaceFineness);
space.z = linspace(-10, 10, params.spaceFineness);

roverInitPosition.x = space.x(randi(size(space.x)));
roverInitPosition.y = space.y(randi(size(space.y)));
roverInitPosition.z = space.z(randi(size(space.z)));
distToRover = zeros(params.anchorQuantity,1);
beacon = zeros(params.anchorQuantity,params.problemDim);

if params.problemDim == 2
    for i = 1:params.anchorQuantity
        beacon(i,1) = space.x(randi(size(space.x)));
        beacon(i,2) = space.y(randi(size(space.y)));
        distToRover(i) = norm ([roverInitPosition.x; roverInitPosition.y] - ...
                               [beacon(i,1); beacon(i,2)]);
    end
elseif params.problemDim == 3
    for i = 1:params.anchorQuantity
        beacon(i,1) = space.x(randi(size(space.x)));
        beacon(i,2) = space.y(randi(size(space.y)));
        beacon(i,3) = space.z(randi(size(space.z)));
        distToRover(i) = norm ([roverInitPosition.x;roverInitPosition.y;roverInitPosition.z] - ...
                               [beacon(i,1);beacon(i,2);beacon(i,3)]);
    end 
else error('Error. Set the dimension of a problem at 2 or 3.');
end
clear i