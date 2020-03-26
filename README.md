# Positioning
A problem of positioning of a point based on n beacons and absolute distances from said beacons to the point of interest (POI).

The main script is PositioningScripts.m. It calls the initialization of a problem with a set of parameters,
calculates a position of the POI with 3 different methods,
plots the solutions, 
calculates the total error of the calculated position of POI's. 

          function [params, beacon, distToRover, noisedDistToRover, roverInitPosition] = ...
                    ProblemInit(anchQty, probDim, gridDensity, noiseAmp).
          
          inputs: anchQty - sets up the quantity of anchors,
                  probDim - sets up the dimention of the problem: 2 or 3,
                  gridDensity - 1/density is the minimal distance between 2 adjacent beacons,
                  noiseAmp - regulates the amplitude of noise.
          
          outputs: params - struct with anchor quantity, dimentions, grid density and grid itself stored there,
                   params.space - the box-field in wich we place all the beacons and the POI,
                   beacon - an array anchQty*3 of beacon coordinates (x,y,z). if probDim = 2, z = 0,
                   distToRover - an aray of distances between the POI and each beacon,
                   noisedDistToRover - distToRover with added noise,
                   roverInitPosition - initial position of the POI. if probDim = 2, z = 0.

There are 3 methods avaliable to solve the problem: Analytical Intersections, Trilateration, Gradient Descent. 
Method 1, analytical: 
Of all the methods, method 2 shows the slowest runtime.

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
          
Method 2, trilateration: 
This method is similar to analytical, except here the values of intersection points are calculated numerically.
Of all the methods, method 2 shows the quickest runtime.
         
          function roverCalcPosition = TrilaterationMethod(params,beacons,distances)
          %the most frequent intersection point is assumed to be the POI
          %
          %for each three beacons, the method applies linear transformation of the cartesian coordinates in such a way,
          %that one beacon becomes (0,0,0) of the new coordinate system, and the second beacon  lies on an X axis.
          %then, the position of the POI is calculated according to formulas provided here: https://en.wikipedia.org/wiki/True_range_multilateration
          %the final step is inverse transformation, to return to the original coordinate system.

Method 3, gradient descent using fmincon(): 
Method reiles on the convergense of an approacing point with the real solution.
Functional is set to be the norm of vector, composed of distances between the approaching point
and the real POI. 

          function calcPosition = GDescFmincon(params,beacons,distances, startPt)
          %Determining the position of POI with MATLAB's fmincon.m 
          %We search such a new point (xn yn), that the diff of sq distances between 
          %(xn yn) and every anchor would be as close as possible to the original known 
          %distances. To evaluate such a point, we create a functional vector with 
          %differences of distances between points and anchors. 
          %
          %functin accepts the struct of problem aprameters, 
          %an array of beacons and the array of 
          %original known distances. optional: 
          %define the start point of the minimizer search
 
