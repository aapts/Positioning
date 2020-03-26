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
         
          function roverCalcPosition = TrilaterationMethod(params,beacons,distances)
          %the most frequent intersection point is assumed to be the POI
