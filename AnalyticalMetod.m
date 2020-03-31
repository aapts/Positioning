function roverCalcPosition = AnalyticalMetod(params,beacons,distances)
%Analytical method of determinig the position of the POI. The equations of
%circles with a center at each beacon and a radius of the distance between every
%beacon and the POI are constructed. For each pair of circles the point of
%intersection inside the bound area is found. The final position is determined
%as a mean of all points of intersections.
%
%Redundant poits of intersection are discareded based on closeness to the
%intersection of circles around first two beacons (placed in the corners of the
%bound area)
%
%method works only if the dimension of a problem is == 2

if params.problemDim == 2
    [eqns,chi,phi] = AnalyticEqns(params,beacons,distances);

    ptsIntersection = CircleIntersections(eqns, chi, phi, params);
    roverCalcPosition = intersecionMean(ptsIntersection);
else
    disp('//!Error. The method can only be used with params.problemDim = 2');
    disp('//!Returning point [0 0 0]');
    roverCalcPosition.x = 0;
    roverCalcPosition.y = 0;
    roverCalcPosition.z = 0;
    return
end
end
%% Method 1 Functions
function [rad,chi,phi] = AnalyticEqns(params,beacon,distToRover)
%sets up analytical eqns of circles with a canter at each beacon, and with
%radius of a distance to the POI
    syms  chi phi  
    rad = sym(zeros(1,params.anchorQuantity));
    for i = 1:params.anchorQuantity
        rad(i) = (beacon(i,1)- chi)^2 + (beacon(i,2)-phi)^2 == distToRover(i)^2;
    end
end

function pts = CircleIntersections(eqns, chi,phi, params)
%searches for intersections of two circles inside the bound spacee
    pts = cell(numel(eqns));
    for i = 1:numel(eqns)
        for j = i+1:numel(eqns)
            pts{i,j} = solve([eqns(i) eqns(j)],[chi phi]);
            pts{j,i}.phi = double(pts{i,j}.phi);
            pts{j,i}.chi = double(pts{i,j}.chi);
            pts{j,i}.sol1 = [pts{j,i}.chi(1) pts{j,i}.phi(1)];
            pts{j,i}.sol2 = [pts{j,i}.chi(2) pts{j,i}.phi(2)];
            
            if      pts{2,1}.sol1(1) < max(params.space.x) &&...
                    pts{2,1}.sol1(1) > min(params.space.x) &&...
                    pts{2,1}.sol1(2) < max(params.space.y) &&...
                    pts{2,1}.sol1(2) > min(params.space.y) &&...
                    norm(pts{2,1}.sol1 - pts{j,i}.sol1) < 2*mean(diff(params.space.x))
                        pts{i,j} = pts{j,i}.sol1;
            elseif  pts{2,1}.sol2(1) < max(params.space.x) &&...
                    pts{2,1}.sol2(1) > min(params.space.x) &&...
                    pts{2,1}.sol2(2) < max(params.space.y) &&...
                    pts{2,1}.sol2(2) > min(params.space.y) &&...
                    norm(pts{2,1}.sol2 - pts{j,i}.sol2) < 2*mean(diff(params.space.x))
                        pts{i,j} = pts{j,i}.sol2;
            elseif  pts{2,1}.sol1(1) < max(params.space.x) &&...
                    pts{2,1}.sol1(1) > min(params.space.x) &&...
                    pts{2,1}.sol1(2) < max(params.space.y) &&...
                    pts{2,1}.sol1(2) > min(params.space.y) &&...
                    norm(pts{2,1}.sol1 - pts{j,i}.sol2) < 2*mean(diff(params.space.x))
                        pts{i,j} = pts{j,i}.sol2;
            elseif  pts{2,1}.sol2(1) < max(params.space.x) &&...
                    pts{2,1}.sol2(1) > min(params.space.x) &&...
                    pts{2,1}.sol2(2) < max(params.space.y) &&...
                    pts{2,1}.sol2(2) > min(params.space.y) &&...
                    norm(pts{2,1}.sol2 - pts{j,i}.sol1) < 2*mean(diff(params.space.x))
                        pts{i,j} = pts{j,i}.sol1;
            else
                        pts{i,j} = NaN;
            end
        end
    end
end

function AcquiredIntersecrionPoint = intersecionMean(pts)
%calculates the position of POI based on numbers of circle intersections
    AcquiredIntersecrionPoint.x = 0;
    AcquiredIntersecrionPoint.y = 0;
    k = 0;
    for i = 1:size(pts)
        for j = i+1:size(pts)
            if isnan(pts{i,j})
            else
                AcquiredIntersecrionPoint.x = AcquiredIntersecrionPoint.x + pts{i,j}(1);
                AcquiredIntersecrionPoint.y = AcquiredIntersecrionPoint.y + pts{i,j}(2);
                k = k + 1;
            end
        end
    end
    AcquiredIntersecrionPoint.x = AcquiredIntersecrionPoint.x / k;
    AcquiredIntersecrionPoint.y = AcquiredIntersecrionPoint.y / k;
end