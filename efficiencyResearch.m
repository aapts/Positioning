[params, beacons, dTR, dTRnoised, roverInitPosition, sd] = ...
          ProblemInit(5, 2, 1500, 0); 
      
%% Method 1: an analytical solution, mean of coordinates of intersections of pairs of circles      
disp('      !!Analytical imtersectioins method')
tic
roverAnalyAcq  = AnalyticalMetod(params,beacons,dTRnoised);
toc 
errAnaly = CalcError(roverInitPosition, roverAnalyAcq);
disp(['distance between acquired and original = ' num2str(errAnaly)])

%% Method 2: Trilaterating the position of the POI
disp('      !!Trilateration method')
tic
roverTrilatAcq  = TrilaterationMethod(params,beacons,dTRnoised);
toc
errTrilat = CalcError(roverInitPosition, roverTrilatAcq);
disp(['distance between acquired and original = ' num2str(errTrilat)])


%% Method 3: fmincon. Approaching the solution with the gradient descent
disp('      !!fmincon method')
tic
roverFmincon  = GDescFmincon(params,beacons,dTRnoised);
toc
errGDesc = CalcError(roverInitPosition, roverFmincon);
disp(['distance between acquired and original = ' num2str(errGDesc)])
>>>>>>> Stashed changes
