function calcPosition = GDescFmincon(params,beacons,distances, startPt)
%Determining the position of POI with MATLAB's fmincon.m 
%We search such a new point (xn yn), that the diff of sq distances between 
%(xn yn) and every anchor would be as close as possible to the original known 
%distances. To evaluate such a point, we create a functional vector with 
%differences of distances between points and anchors. 
%
%function accepts the struct field of problem parameters, an array of beacons and the
%array of original known distances. 
%optional: define the start point of the minimizer search. 
%If not passed to the function, defaults to [0 0]

%minimizing the norm of the vector of differences of squared distances leads
%to the minimal distance between the true solution and the acquired one
toMinimize = @(x) erfun(beacons, distances, x);
A = [];     b = [];
Aeq = [];   beq= [];   
lowBound = [min(params.space.x), min(params.space.y), min(params.space.z)];
uppBound = [max(params.space.x), max(params.space.y), max(params.space.z)];
options = optimoptions('fmincon','Display','off');
if nargin == 3
    startPt = [0,0,0];
end
endPt = fmincon(toMinimize,startPt,A,b,Aeq,beq,lowBound,uppBound,[],options);

calcPosition.x = endPt(1);
calcPosition.y = endPt(2);
calcPosition.z = endPt(3);
end
function out = erfun(beacons, distances, x)
    bx = beacons(:,1);
    by = beacons(:,2);
    bz = beacons(:,3);
        
    dbx = bx - x(1);
    dby = by - x(2);
    dbz = bz - x(3);
    db = dbx.^2 + dby.^2 + dbz.^2;
    
    dst_sq = distances.^2;
    
    out(:) = norm(db(:) - dst_sq(:));
end