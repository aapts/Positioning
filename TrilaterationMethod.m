function roverCalcPosition = TrilaterationMethod(params,beacons,distances)
%Trilateration method of determinig the position of the POI. Uses points and
%distances
%the most frequent intersection point is assumed to be the POI
%
%for each three beacons, the method applies linear transformation of the cartesian coordinates in such a way,
%that one beacon becomes (0,0,0) of the new coordinate system, and the second beacon  lies on an X axis.
%then, the position of the POI is calculated according to formulas provided here: https://en.wikipedia.org/wiki/True_range_multilateration
%the final step is inverse transformation, to return to the original coordinate system.
%https://en.wikipedia.org/wiki/True_range_multilateration#Three_Cartesian_dimensions,_three_measured_slant_ranges
%% allocating memory for variables
l = 0;
trilat.x = 0;
trilat.y = 0;
trilat.z = 0;
len = length(beacons);
trilat.Points = zeros(3,sum(linspace(1,len-2,len-2).*linspace(len-2,1,len-2)));
%% body:searching for the point
for i = 1:length(beacons)
    for j = i+1:length(beacons)
        for k = j+1:length(beacons)
            l = l + 1;
            [P1, P2, P3] = TrilatInit(i,j,k,beacons);
            trilat.Points(:,l) = TrilatResults(distances(i),...
                                               distances(j),...
                                               distances(k),...
                                               P1, P2, P3, params); 
        end
    end
end
trilat.Points = rmmissing(trilat.Points,2);
roverCalcPosition.x = mode(trilat.Points(1,:));
roverCalcPosition.y = mode(trilat.Points(2,:));
roverCalcPosition.z = mode(trilat.Points(3,:));
%% Method 2 Functions
function [P1, P2, P3] = TrilatInit(i,j,k, beacon)
%settup of the matrix of three beacons
        xI = beacon(i,1);
        yI = beacon(i,2);
        zI = beacon(i,3);

        xJ = beacon(j,1);
        yJ = beacon(j,2);
        zJ = beacon(j,3);
        
        xK = beacon(k,1);
        yK = beacon(k,2);
        zK = beacon(k,3);
        
        P1 = [xI; yI; zI];
        P2 = [xJ; yJ; zJ];
        P3 = [xK; yK; zK];
end

function [U, Vx, Vy, ex, ey, ez] = LineMap(P1,P2,P3)
%linear transformation: moving 0 of cartesian coordinates to the 1st beacon,
%putting the 2nd beacon on an Ox axis
%beacon1 (0,0,0)
%beacon2 (U,0,0)
%beacon3 (Vx,Vy,0)
        U  = norm(P2 - P1);        
        ex = (P2 - P1) / (norm(P2 - P1));
        Vx  = dot(ex, (P3 - P1));
        ey = (P3 - P1 - Vx*ex) / (norm(P3 - P1 - Vx*ex));
        ez = cross(ex, ey);        
        Vy  = dot(ey, (P3 - P1));
end

function buf = TrilatResults(dist1, dist2, dist3, P1, P2, P3, params) 
%https://en.wikipedia.org/wiki/True_range_multilateration
    [U, Vx, Vy, ex, ey, ez] = LineMap(P1, P2, P3);

    x = ((dist1^2) - (dist2^2) + (U^2))...
               /...
               (2*U);
    y = (((dist1^2) - (dist3^2) + (Vx^2)...
               +...
               (Vy^2) - 2*Vx)/(2*Vy))...
               - ...
               ((Vx/Vy)*x);  
    z = sqrt(dist1^2 - x^2 - y^2);
    buf = P1 + x * ex + y * ey + z* ez; %inverse transformation
    if      or((buf>max(params.space.x)),...
               (buf<min(params.space.x))) 
        buf(1)=NaN;
        buf(2)=NaN;
        buf(3)=NaN;
    elseif  or((buf(2)>max(params.space.x)),...
               (buf(2)<min(params.space.x))) 
        buf(1)=NaN;
        buf(2)=NaN;
        buf(3)=NaN;          
    end
end

end