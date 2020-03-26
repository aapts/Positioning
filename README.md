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
                   beacon - an array anchQty*3 of beacon coordinates (x,y,z). if probDim = 2, z =0,
                   distToRover - an aray of distances between the POI and each beacon,
                   noisedDistToRover - distToRover with added noise,
                   roverInitPosition - initial position of the POI
                   
                   
                   
