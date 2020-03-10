anchorQuantity = 150;
problemDim = 2;

space.x = linspace(0, 10, 1500);
space.y = linspace(0, 10, 1500);
space.z = linspace(0, 10, 1500);

roverInitPosition.x = space.x(randi(size(space.x)));
roverInitPosition.y = space.y(randi(size(space.y)));
roverInitPosition.z = space.z(randi(size(space.z)));

anchors = zeros(problemDim, anchorQuantity);