[params, beacons, dTR, dTRnoised, roverInitPosition, sd] = ...
          ProblemInit(5, 2, 1500, 0); 
%% Method 1: an analytical solution, mean of coordinates of intersections of pairs of circles  
for i = 1:100
% disp('#################################################################')
% disp('      !!Analytical imtersectioins method')
tic
roverAnalyAcq  = AnalyticalMetod(params,beacons,dTRnoised);
analytT(i)= toc; 
errAnaly(i) = CalcError(roverInitPosition, roverAnalyAcq);
% disp(['distance between acquired and original = ' num2str(errAnaly)])
% disp('#################################################################')
%% Method 2: Trilaterating the position of the POI
% disp('      !!Trilateration method')
tic
roverTrilatAcq(i)  = TrilaterationMethod(params,beacons,dTRnoised);
trilatT(i) = toc;
errTrilat(i) = CalcError(roverInitPosition, roverTrilatAcq);
% disp(['distance between acquired and original = ' num2str(errTrilat)])
% disp('#################################################################')

%% Method 3: fmincon. Approaching the solution with the gradient descent
% disp('      !!fmincon method')
tic
roverFmincon  = GDescFmincon(params,beacons,dTRnoised);
fminconT(i) = toc;
errGDesc(i) = CalcError(roverInitPosition, roverFmincon);
% disp(['distance between acquired and original = ' num2str(errGDesc)])
i
end

function err = CalcError(roverInit, roverAcq)
%calculates the difference between the initial position and the acquired one
    err = norm([roverInit.x; roverInit.y] - ...
               [roverAcq.x;  roverAcq.y]);
end