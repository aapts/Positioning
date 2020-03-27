[params, beacons, dTR, dTRnoised, roverInitPosition, sd] = ...
          ProblemInit(20, 2, 1500, 0); 
for i = 1:50
% disp('#################################################################')
% disp('      !!Analytical imtersectioins method')
tic
roverAnalyAcq  = AnalyticalMetod(params,beacons,dTRnoised);
rs.analyt.noise0.twty.t(i) = toc; 
rs.analyt.noise0.twty.err(i) = CalcError(roverInitPosition, roverAnalyAcq);
% disp(['distance between acquired and original = ' num2str(errAnaly)])
% disp('#################################################################')
%% Method 2: Trilaterating the position of the POI
% disp('      !!Trilateration method')
tic
roverTrilatAcq  = TrilaterationMethod(params,beacons,dTRnoised);
rs.trilat.noise0.twty.t(i) = toc;
rs.trilat.noise0.twty.err(i) = CalcError(roverInitPosition, roverTrilatAcq);
% disp(['distance between acquired and original = ' num2str(errTrilat)])
% disp('#################################################################')

%% Method 3: fmincon. Approaching the solution with the gradient descent
% disp('      !!fmincon method')
tic
roverFmincon  = GDescFmincon(params,beacons,dTRnoised);
rs.fmc.noise0.twty.t(i) = toc;
rs.fmc.noise0.twty.err(i) = CalcError(roverInitPosition, roverFmincon);
% disp(['distance between acquired and original = ' num2str(errGDesc)])
i
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear params beacons dTR dTRnoised roverInitPosition sd
[params, beacons, dTR, dTRnoised, roverInitPosition, sd] = ...
          ProblemInit(5, 2, 1500, 100); 
rs.noise10.five.dTR = dTR;
rs.noise10.five.noised = dTRnoised;
for i = 1:50
% disp('#################################################################')
% disp('      !!Analytical imtersectioins method')
tic
roverAnalyAcq  = AnalyticalMetod(params,beacons,dTRnoised);
rs.analyt.noise10.five.t(i) = toc; 
rs.analyt.noise10.five.err(i) = CalcError(roverInitPosition, roverAnalyAcq);
% disp(['distance between acquired and original = ' num2str(errAnaly)])
% disp('#################################################################')
%% Method 2: Trilaterating the position of the POI
% disp('      !!Trilateration method')
tic
roverTrilatAcq  = TrilaterationMethod(params,beacons,dTRnoised);
rs.trilat.noise10.five.t(i) = toc;
rs.trilat.noise10.five.err(i) = CalcError(roverInitPosition, roverTrilatAcq);
% disp(['distance between acquired and original = ' num2str(errTrilat)])
% disp('#################################################################')

%% Method 3: fmincon. Approaching the solution with the gradient descent
% disp('      !!fmincon method')
tic
roverFmincon  = GDescFmincon(params,beacons,dTRnoised);
rs.fmc.noise10.five.t(i) = toc;
rs.fmc.noise10.five.err(i) = CalcError(roverInitPosition, roverFmincon);
% disp(['distance between acquired and original = ' num2str(errGDesc)])
i
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear params beacons dTR dTRnoised roverInitPosition sd
[params, beacons, dTR, dTRnoised, roverInitPosition, sd] = ...
          ProblemInit(10, 2, 1500, 100); 
rs.noise10.ten.dTR = dTR;
rs.noise10.ten.noised = dTRnoised;
for i = 1:50
% disp('#################################################################')
% disp('      !!Analytical imtersectioins method')
tic
roverAnalyAcq  = AnalyticalMetod(params,beacons,dTRnoised);
rs.analyt.noise10.ten.t(i) = toc; 
rs.analyt.noise10.ten.err(i) = CalcError(roverInitPosition, roverAnalyAcq);
% disp(['distance between acquired and original = ' num2str(errAnaly)])
% disp('#################################################################')
%% Method 2: Trilaterating the position of the POI
% disp('      !!Trilateration method')
tic
roverTrilatAcq  = TrilaterationMethod(params,beacons,dTRnoised);
rs.trilat.noise10.ten.t(i) = toc;
rs.trilat.noise10.ten.err(i) = CalcError(roverInitPosition, roverTrilatAcq);
% disp(['distance between acquired and original = ' num2str(errTrilat)])
% disp('#################################################################')

%% Method 3: fmincon. Approaching the solution with the gradient descent
% disp('      !!fmincon method')
tic
roverFmincon  = GDescFmincon(params,beacons,dTRnoised);
rs.fmc.noise10.ten.t(i) = toc;
rs.fmc.noise10.ten.err(i) = CalcError(roverInitPosition, roverFmincon);
% disp(['distance between acquired and original = ' num2str(errGDesc)])
i
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear params beacons dTR dTRnoised roverInitPosition sd
[params, beacons, dTR, dTRnoised, roverInitPosition, sd] = ...
          ProblemInit(15, 2, 1500, 100); 
rs.noise10.fteen.dTR = dTR;
rs.noise10.fteen.noised = dTRnoised;
for i = 1:50
% disp('#################################################################')
% disp('      !!Analytical imtersectioins method')
tic
roverAnalyAcq  = AnalyticalMetod(params,beacons,dTRnoised);
rs.analyt.noise10.fteen.t(i) = toc; 
rs.analyt.noise10.fteen.err(i) = CalcError(roverInitPosition, roverAnalyAcq);
% disp(['distance between acquired and original = ' num2str(errAnaly)])
% disp('#################################################################')
%% Method 2: Trilaterating the position of the POI
% disp('      !!Trilateration method')
tic
roverTrilatAcq  = TrilaterationMethod(params,beacons,dTRnoised);
rs.trilat.noise10.fteen.t(i) = toc;
rs.trilat.noise10.fteen.err(i) = CalcError(roverInitPosition, roverTrilatAcq);
% disp(['distance between acquired and original = ' num2str(errTrilat)])
% disp('#################################################################')

%% Method 3: fmincon. Approaching the solution with the gradient descent
% disp('      !!fmincon method')
tic
roverFmincon  = GDescFmincon(params,beacons,dTRnoised);
rs.fmc.noise10.fteen.t(i) = toc;
rs.fmc.noise10.fteen.err(i) = CalcError(roverInitPosition, roverFmincon);
% disp(['distance between acquired and original = ' num2str(errGDesc)])
i
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear params beacons dTR dTRnoised roverInitPosition sd
[params, beacons, dTR, dTRnoised, roverInitPosition, sd] = ...
          ProblemInit(20, 2, 1500, 100); 
rs.noise10.twty.dTR = dTR;
rs.noise10.twty.noised = dTRnoised;
for i = 1:50
% disp('#################################################################')
% disp('      !!Analytical imtersectioins method')
tic
roverAnalyAcq  = AnalyticalMetod(params,beacons,dTRnoised);
rs.analyt.noise10.twty.t(i) = toc; 
rs.analyt.noise10.twty.err(i) = CalcError(roverInitPosition, roverAnalyAcq);
% disp(['distance between acquired and original = ' num2str(errAnaly)])
% disp('#################################################################')
%% Method 2: Trilaterating the position of the POI
% disp('      !!Trilateration method')
tic
roverTrilatAcq  = TrilaterationMethod(params,beacons,dTRnoised);
rs.trilat.noise10.twty.t(i) = toc;
rs.trilat.noise10.twty.err(i) = CalcError(roverInitPosition, roverTrilatAcq);
% disp(['distance between acquired and original = ' num2str(errTrilat)])
% disp('#################################################################')

%% Method 3: fmincon. Approaching the solution with the gradient descent
% disp('      !!fmincon method')
tic
roverFmincon  = GDescFmincon(params,beacons,dTRnoised);
rs.fmc.noise10.twty.t(i) = toc;
rs.fmc.noise10.twty.err(i) = CalcError(roverInitPosition, roverFmincon);
% disp(['distance between acquired and original = ' num2str(errGDesc)])
end


function err = CalcError(roverInit, roverAcq)
%calculates the difference between the initial position and the acquired one
    err = norm([roverInit.x; roverInit.y] - ...
               [roverAcq.x;  roverAcq.y]);
end