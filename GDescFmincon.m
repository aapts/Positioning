function calcPosition = GDescFmincon(params,beacons,distances, startPt)
%Determining the position of POI with MATLAB's fmincon.m 
%We search such a new point (xn yn), that the diff of sq distances between 
%(xn yn) and every anchor would be as close as possible to the original known 
%distances. To evaluate such a point, we create a functional vector with 
%differences of distances between points and anchors. 
%
%functin accepts the struct of problem aprameters, an array of beacons and the
%array of original known distances. optional: define the start point of the
%minimizer search. If not passed to the function, defaults to [0 0]

syms gfx(x,y) [1 params.anchorQuantity]
for i = 1:params.anchorQuantity
    %creating functional, the difference of squares of  distances
    bx = beacons(i,1);
    by = beacons(i,2);
    dst= distances(i);
    eval(['gfx', num2str(i), '(x,y) = (bx - x)^2 + (by - y)^2 - dst^2;']);
end

fun = subs(gfx);

%minimizing the norm of the vector of differences of squared distances leads
%to the minimal distance between the true solution and the acquired one
options = optimoptions('fmincon','Display','off');
toMinimize = @(x) norm(double(fun(x(1),x(2))));
A = [];     b = [];
Aeq = [];   beq= [];   
lowBound = [min(params.space.x), min(params.space.y) ];
uppBound = [max(params.space.x), max(params.space.y) ];

if nargin == 3
    startPt = [0,0];
end
endPt = fmincon(toMinimize,startPt,A,b,Aeq,beq,lowBound,uppBound,[],options);

calcPosition.x = endPt(1);
calcPosition.y = endPt(2);
end

