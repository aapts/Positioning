clear 
close all
ProblemInit;
distNoise = addnoise(distToRover, 10);
%% Method 1: analytical intersections of circles
[eqns,chi,phi] = analyticEqns(params,beacon,distNoise);
% plotSpace(beacon, eqns, roverInitPosition,space);

ptsIntersection = circleIntersections(eqns, chi, phi, params);
roverCalcPosition = intersecionMean(ptsIntersection);
err = calcError(roverInitPosition, roverCalcPosition);
finPlotSpace(beacon, 0, roverInitPosition, roverCalcPosition, params);
clear chi phi eqns ptsIntersection 
%% Method 2: More fine trilateration
l = 0;
trilat.x = 0;
trilat.y = 0;
trilat.z = 0;
len = length(beacon);
trilat.Points = zeros(3,sum(linspace(1,len-2,len-2).*linspace(len-2,1,len-2)));

for i = 1:length(beacon)
    for j = i+1:length(beacon)
        for k = j+1:length(beacon)
            l = l + 1;
            [P1, P2, P3] = trilatInit(i,j,k,beacon);
            [U, Vx, Vy, ex, ey, ez] = lineMap(P1, P2, P3);
            trilat.Points(:,l) = trilatResults(distNoise(i),...
                                               distNoise(j),...
                                               distNoise(k),...
                                               U, Vx, Vy, ex, ey, P1, params); 
%             tmp.x = buf(1,l); tmp.y = buf(2,l);
%             finPlotSpace(beacon, 0, roverInitPosition, tmp, params);
%             hold on
        end
    end
end
trilat.Points = rmmissing(trilat.Points,2);
trilat.x = mode(trilat.Points(1,:));
trilat.y = mode(trilat.Points(2,:));

err = calcError(roverInitPosition, trilat);
finPlotSpace(beacon, 0, roverInitPosition, trilat, params);
clear i j k l eex ey ez P1 P2 P3 U Vx Vy
%% Method3: Perticle Filter with Robotic System Toolbox
pf = stateEstimatorPF;
pf.StateEstimationMethod = 'mean';
pf.ResamplingMethod
%% Method 2 Functions
function buf = trilatResults(dist1, dist2, dist3, U, Vx, Vy, ex, ey, P1, params) 
%https://en.wikipedia.org/wiki/True_range_multilateration

    x = ((dist1^2) - (dist2^2) + (U^2))...
               /...
               (2*U);
    y = (((dist1^2) - (dist3^2) + (Vx^2)...
               +...
               (Vy^2) - 2*Vx)/(2*Vy))...
               - ...
               ((Vx/Vy)*x);                   
    buf = P1 + x * ex + y * ey;
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

function [P1, P2, P3] = trilatInit(i,j,k, beacon)
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

function [U, Vx, Vy, ex, ey, ez] = lineMap(P1,P2,P3)
        U  = norm(P2 - P1);        
        ex = (P2 - P1) / (norm(P2 - P1));
        Vx  = dot(ex, (P3 - P1));
        ey = (P3 - P1 - Vx*ex) / (norm(P3 - P1 - Vx*ex));
        ez = cross(ex, ey);        
        Vy  = dot(ey, (P3 - P1));
end
%% Method 1 Functions
function [rad,chi,phi] = analyticEqns(params,beacon,distToRover)
    syms  chi phi  
    rad = sym(zeros(1,params.anchorQuantity));
    for i = 1:params.anchorQuantity
        rad(i) = (beacon(i,1)- chi)^2 + (beacon(i,2)-phi)^2 == distToRover(i)^2;
    end
end

function pts = circleIntersections(eqns, chi,phi, params)
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
            end
        end
    end
end

function acquiredIntersecrionPoint = intersecionMean(pts)
    acquiredIntersecrionPoint.x = 0;
    acquiredIntersecrionPoint.y = 0;
    k = 0;
    for i = 1:size(pts)
        for j = i+1:size(pts)
            acquiredIntersecrionPoint.x = pts{i,j}(1) + acquiredIntersecrionPoint.x;
            acquiredIntersecrionPoint.y = pts{i,j}(2) + acquiredIntersecrionPoint.y;
            k = k + 1;
        end
    end
    acquiredIntersecrionPoint.x = acquiredIntersecrionPoint.x / k;
    acquiredIntersecrionPoint.y = acquiredIntersecrionPoint.y / k;
end
%% GP Functions
function plotSpace(beacons,circles,roverInit,params)
    scatter(beacons(:,1),beacons(:,2),'x','magenta');
    hold on
    scatter(roverInit.x,roverInit.y,...
          'diamond','black','filled');
    title('Initial Space')
    xlabel('\chi');
    ylabel('\phi')
if circles == 0
    return
else
    fimplicit(circles(:), [min(params.space.x) max(params.space.x)]);
end
    hold off
    grid on
end

function finPlotSpace(beacons,circles,roverInit,roverCalc,space)
    hold on
    plotSpace(beacons,circles,roverInit,space)
    scatter(roverCalc.x,roverCalc.y,...
        'diamond','green');
    hold off
end

function noised = addnoise(dist, fineness)
    randoms = imag(ifft(randn(1,100500)));
    noised = dist + randoms(randi(numel(randoms)))./fineness;
end

function err = calcError(roverInit, roverAcq)
    err = norm([roverInit.x; roverInit.y] - ...
               [roverAcq.x;  roverAcq.y]);
end