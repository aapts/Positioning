[params, beacons, dTR, dTRnoised, roverInitPosition, sd] = ...
          ProblemInit(15, 2, 1500, 10); 
% PlotSpace(beacons,0,roverInitPosition,params) %uncomment to plot the original space
%% Method 1: an analytical solution, mean of coordinates of intersections of pairs of circles      
disp('      !!Analytical imtersectioins method')
tic
roverAnalyAcq  = AnalyticalMetod(params,beacons,dTRnoised);
toc 
errAnaly = CalcError(roverInitPosition, roverAnalyAcq);
disp(['distance between acquired and original = ' num2str(errAnaly)])

figure
FinPlotSpace(beacons, 0, roverInitPosition, roverAnalyAcq, params)
title('Method of Analytical Intersections')

%% Method 2: Trilaterating the position of the POI
disp('      !!Trilateration method')
tic
roverTrilatAcq  = TrilaterationMethod(params,beacons,dTRnoised);
toc
errTrilat = CalcError(roverInitPosition, roverTrilatAcq);
disp(['distance between acquired and original = ' num2str(errTrilat)])

figure
FinPlotSpace(beacons, 0, roverInitPosition, roverTrilatAcq, params)
title('Trilateration Method')

%% Method 3: fmincon. Approaching the solution with the gradient descent
disp('      !!fmincon method')
tic
roverFmincon  = GDescFmincon(params,beacons,dTRnoised);
toc
errGDesc = CalcError(roverInitPosition, roverFmincon);
disp(['distance between acquired and original = ' num2str(errGDesc)])

figure
FinPlotSpace(beacons, 0, roverInitPosition, roverFmincon, params)
title('Gradient Descent Method')
%% GP Functions
function FinPlotSpace(beacons,circles,roverInit,roverCalc,params)
%plots the original POI and calculated one.
    PlotSpace(beacons,circles,roverInit,params)
    hold on
    scatter(roverCalc.x,roverCalc.y,...
        'diamond','green');
    hold off
end

function PlotSpace(beacons,circles,roverInit,params)
%plots the space with beacons and the POI placed. if circles == equations of 
%circles around each beacon, plots the outline of the circles. if circles ==0, 
%plots only the beacons and the POI
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

function err = CalcError(roverInit, roverAcq)
%calculates the difference between the initial position and the acquired one
    err = norm([roverInit.x; roverInit.y] - ...
               [roverAcq.x;  roverAcq.y]);
end