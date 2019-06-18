function [] = mdc_help( input )

if ~exist('input', 'var') || isempty(input)
  input = '';
end

switch input
    case 'example'
        fprintf('\n---------------------- configuration example --------------------\n\n');
        fprintf("%% Copy this example to a matlab script to get started              \n\n");
        fprintf('warning on                                                         \n');
        fprintf("warning('backtrace', 'off');                                     \n\n");
        fprintf("addpath(genpath('config_build/src/'));                             \n");
        fprintf("addpath(genpath('mdcgen/src'));                                  \n\n");
        fprintf("config.nDatapoints = 2000;                                         \n");
        fprintf("config.nDimensions = 2;                                            \n");
        fprintf("config.nClusters = 3;                                              \n");
        fprintf("config.nOutliers = 4;                                              \n");
        fprintf("config.distribution = [6 1 2];                                   \n\n");
        fprintf('[ result ] = mdcgen( config );                                   \n\n');
        fprintf("scatter(result.dataPoints(:,1),result.dataPoints(:,2),10,'fill');  \n");
        fprintf('axis([0 1 0 1])                                                    \n');
        fprintf('\n-------------------- configuration example end ------------------\n\n');
        

    case 'input'

        fprintf('--------------------- Configuration options ---------------------\n\n');
        fprintf('parameters                                                       \n');
        fprintf('  .seed:              [scalar] seed for random number generator \n\n');
        fprintf('  .nDimensions:       [scalar] number of dimensions \n\n');
        fprintf('  .nDatapoints:       [scalar] number of datapoints \n\n');
        fprintf('  .nOutliers:         [scalar] number of outliers \n\n');
        fprintf('  .nClusters:         [scalar] number of clusters \n\n');
        fprintf('  .clusterMass:       [array]  datapoints per cluster \n\n');
        fprintf('  .minimumClusterMass:[scalar] minimum datapoints per cluster\n\n');
        fprintf('  .alphaFactor:       [scalar, array (nDimensions)] factor for calculating nIntersecitons. \n\n');
        fprintf('  .alpha:             [scalar, array (nDimensions)] constant for calculating nIntersections \n\n');
        fprintf('  .scale:             [scalar, array (nClusters)] scales the cluster compactness \n\n');
        fprintf('  .distribution:      [scalar, array (nClusters), matrix (nClusters, nDimension)] defines distribution function to use \n');
        fprintf('                      (0) random     | (1) Uniform | (2) Gaussian |  (3) Logistic \n');
        fprintf('                      (4) Triangular | (5) Gamma   | (6) Gap or ring-shaped \n\n');
        fprintf('  .distributionFlag:  [array (available Distributions)] flag to enable or disable distributions \n\n');
        fprintf('  .multivariate:      [scalar, array (nClusters)] (1) multivariate | (-1) radial based | (0) random \n\n');
        fprintf('  .correlation:       [scalar, array (nClusters)] defines cluster correlation \n\n');
        fprintf('  .compactness:       [scalar, array (nClusters)] determines the variance component in the distribution functions \n\n');
        fprintf('  .rotation:          [scalar, array (nClusters)] flag to enable a random rotation \n\n');
        fprintf('  .nNoise:            [scalar, array, matrix] adds noise to the dataset \n');
        fprintf('                      scalar ...  replaces number of dimensions by noise \n');
        fprintf('                      array  ...  replaces configured dimensions by noise \n');
        fprintf('                      matrix ...  replaces configured dimensions per cluster by noise \n');
        fprintf('\n');
        fprintf('  .validity:          [scalar] enable validity check \n\n');
        fprintf('       .Silhouette:   [scalar] enable Shilouette validity check \n\n');
        fprintf('       .Gindices:     [scalar] enable Gindices validity check \n\n');
        fprintf('\n');
        fprintf('  .userDistribution:     add a user distribution \n\n');
        fprintf('       .binProbability:  [array] the probability that values are within a certain bin. Sum has to be equal to 1. \n\n');
        fprintf('       .edges:           [array (binProbability + 1)] the edges of the bins in a range from [-1 to 1] \n\n');
        fprintf('------------------- Configuration options end -------------------\n\n\n\n');
    
    case 'output'

    fprintf('---------------------------- Outputs ----------------------------\n\n');
    fprintf('result \n');
    fprintf('  .dataPoints   output matrix containing data points               \n');
    fprintf('  .label        array containing the labels of the data points     \n');
    fprintf('  .perf         performance    \n');
    fprintf('      .Silhouette: global Silhouette index   \n');
    fprintf('      .Gstr: strict global overlap index    \n');
    fprintf('      .Grex: relaxed global overlap index  \n');
    fprintf('      .Gmin: minimum global overlap index\n');
    fprintf('      .oi_st: strict individual overlap index (cluster)\n');
    fprintf('      .oi_rx: relaxed individual overlap index (cluster)\n');
    fprintf('      .oi_mn: minimum individual overlap index (cluster)\n\n');
    fprintf('-------------------------- Outputs end --------------------------\n\n');
    
    
    case 'seed'
        fprintf('\nExample on how to configure seed: \n\n');
        fprintf('parameters.seed = 18; \n');
        fprintf('config = createMDCGenConfiguration(parameters);     \n');
        fprintf('[ result ] = mdcgen( config );                     \n\n');
    
    case 'nDimensions'
        fprintf('\nExample on how to configure nDimensions: \n\n');
        fprintf('parameters.nDimensions = 3; \n');
        fprintf('config = createMDCGenConfiguration(parameters);     \n');
        fprintf('[ result ] = mdcgen( config );                     \n\n');
        
    case 'nDatapoints'
        fprintf('\nExample on how to configure nDatapoints: \n\n');
        fprintf('parameters.nDatapoints = 1000; \n');
        fprintf('config = createMDCGenConfiguration(parameters);     \n');
        fprintf('[ result ] = mdcgen( config );                     \n\n');
        
    case 'nOutliers'
        fprintf('\nExample on how to configure nOutliers: \n\n');
        fprintf('parameters.nOutliers = 12; \n');
        fprintf('config = createMDCGenConfiguration(parameters);     \n');
        fprintf('[ result ] = mdcgen( config );                     \n\n');
        
    case 'nClusters'
        fprintf('\nExample on how to configure nClusters: \n\n');
        fprintf('parameters.nClusters = 5; \n');
        fprintf('config = createMDCGenConfiguration(parameters);     \n');
        fprintf('[ result ] = mdcgen( config );                     \n\n');
        
    case 'clusterMass'
        fprintf('\nExample on how to configure clusterMass: \n\n');
        fprintf('parameters.nDatapoints = 150; \n');
        fprintf('parameters.nClusters = 3; \n\n');
        fprintf('%% clusterMass array has to have the length of nClusters and the sum of its elements have to be equal to nDatapoints. \n');
        fprintf('parameters.clusterMass = [50 50 50]; \n\n');
        fprintf('config = createMDCGenConfiguration(parameters);     \n');
        fprintf('[ result ] = mdcgen( config );                     \n\n');
        
    case 'minimumClusterMass'
        fprintf('\nExample on how to configure ddd: \n\n');
        fprintf('%% minimumClusterMass times nClusters may not exceed nDatapoints; \n');
        fprintf('parameters.minimumClusterMass = 30; \n\n');
        fprintf('config = createMDCGenConfiguration(parameters);     \n');
        fprintf('[ result ] = mdcgen( config );                     \n\n');

    case 'alphaFactor'
        fprintf('\nExample on how to configure alphaFactor: \n\n');
        fprintf('%% alphaFactor as scalar; \n');
        fprintf('parameters.alphaFactor = 3; \n\n');
        fprintf('%% OR \n\n');
        fprintf('%% alphaFactor as array. Length has to match nDimensions; \n');
        fprintf('parameters.nDimnesions = 2; \n');
        fprintf('parameters.alphaFactor = [2 4]; \n\n');
        fprintf('config = createMDCGenConfiguration(parameters);     \n');
        fprintf('[ result ] = mdcgen( config );                     \n\n');
       
    case 'alpha'
        fprintf('\nExample on how to configure alpha: \n\n');
        fprintf('%% alpha as scalar; \n');
        fprintf('parameters.alpha = 3; \n\n');
        fprintf('%% OR \n\n');
        fprintf('%% alpha as array. Length has to match nDimensions; \n');
        fprintf('parameters.nDimnesions = 2; \n');
        fprintf('parameters.alpha = [2 4]; \n\n');
        fprintf('config = createMDCGenConfiguration(parameters);     \n');
        fprintf('[ result ] = mdcgen( config );                     \n\n');
               
    case 'scale'
        fprintf('\nExample on how to configure scale: \n\n');
        fprintf('%% scale as scalar; \n');
        fprintf('parameters.scale = 1; \n\n');
        fprintf('%% OR \n\n');
        fprintf('%% scale as array. Length has to match nClusters; \n');
        fprintf('parameters.nClusters = 2; \n');
        fprintf('parameters.scale = [1 -1]; \n\n');
        fprintf('config = createMDCGenConfiguration(parameters);     \n');
        fprintf('[ result ] = mdcgen( config );                     \n\n');
        
    case 'distribution'
        fprintf('\nDistributions to select: \n\n');
        fprintf('  (0) random \n');
        fprintf('  (1) Uniform \n');
        fprintf('  (2) Gaussian \n');
        fprintf('  (3) Logistic \n');
        fprintf('  (4) Triangular \n');
        fprintf('  (5) Gamma \n');
        fprintf('  (6) Gap or ring-shaped \n');
        fprintf('  (0) At random \n');
        fprintf('\nExample on how to configure distribution: \n\n');
        fprintf('%% distribution as scalar; \n');
        fprintf('parameters.distribution = 1; \n\n');
        fprintf('%% OR \n\n');
        fprintf('%% distribution as array. Length has to match nClusters; \n');
        fprintf('parameters.nClusters = 2; \n');
        fprintf('parameters.distribution = [1 3]; \n\n');
        fprintf('%% OR \n\n');
        fprintf('%% distribution as matrix. matrix has to match nClusters and nDimensions; \n');
        fprintf('parameters.nClusters = 2; \n');
        fprintf('parameters.nDimensions = 2; \n');
        fprintf('parameters.distribution = [1 3; 2 5]; \n\n');        
        fprintf('config = createMDCGenConfiguration(parameters);     \n');
        fprintf('[ result ] = mdcgen( config );                     \n\n');
        
    case 'distributionFlag'
        fprintf('\nExample on how to configure distributionFlag: \n\n');
        fprintf('%% distributionFlag length has to match the number of available distributions (Default = 6) \n');
        fprintf('parameters.distribution = 0; \n');
        fprintf('parameters.distributionFlag = [1 0 0 1 1 0]; \n\n');
        fprintf('config = createMDCGenConfiguration(parameters);     \n');
        fprintf('[ result ] = mdcgen( config );                     \n\n');
        
    case 'multivariate'
        fprintf('\nExample on how to configure multivariate: \n\n');
        fprintf('%% multivariate as a scalar \n');
        fprintf('parameters.multivariate = -1; \n\n');
        fprintf('%% OR \n\n');
        fprintf('%% multivariate as array. Length has to match nClusters; \n');
        fprintf('parameters.nClusters = 2; \n');
        fprintf('parameters.multivariate = [1 -1]; \n\n');
        fprintf('config = createMDCGenConfiguration(parameters);     \n');
        fprintf('[ result ] = mdcgen( config );                     \n\n');
        
    case 'correlation'
        fprintf('\nExample on how to configure correlation: \n\n');
        fprintf('%% correlation as a scalar \n');
        fprintf('parameters.correlation = 0.9; \n\n');
        fprintf('%% OR \n\n');
        fprintf('%% correlation as array. Length has to match nClusters; \n');
        fprintf('parameters.nClusters = 2; \n');
        fprintf('parameters.correlation = [0.7 0.4]; \n\n');
        fprintf('config = createMDCGenConfiguration(parameters);     \n');
        fprintf('[ result ] = mdcgen( config );                     \n\n');
        
    case 'compactness'
        fprintf('\nExample on how to configure compactness: \n\n');
        fprintf('%% compactness as a scalar \n');
        fprintf('parameters.compactness = 0.9; \n\n');
        fprintf('%% OR \n\n');
        fprintf('%% compactness as array. Length has to match nClusters; \n');
        fprintf('parameters.nClusters = 2; \n');
        fprintf('parameters.compactness = [0.7 0.4]; \n\n');
        fprintf('config = createMDCGenConfiguration(parameters);     \n');
        fprintf('[ result ] = mdcgen( config );                     \n\n');
        
    case 'rotation'
        fprintf('\nExample on how to configure rotation: \n\n');
        fprintf('%% rotation as a scalar \n');
        fprintf('parameters.rotation = 1; \n\n');
        fprintf('%% OR \n\n');
        fprintf('%% rotation as array. Length has to match nClusters; \n');
        fprintf('parameters.nClusters = 2; \n');
        fprintf('parameters.rotation = [0 1]; \n\n');
        fprintf('config = createMDCGenConfiguration(parameters);     \n');
        fprintf('[ result ] = mdcgen( config );                     \n\n');
        
    case 'nNoise'
        fprintf('\nExample on how to configure nNoise: \n\n');
        fprintf('%% nNoise as a scalar \n');
        fprintf('parameters.nDimensions = 3; \n');
        fprintf('parameters.nNoise = 1; %% replaces one dimension with noise\n\n');  
        fprintf('%% OR \n\n');
        fprintf('%% nNoise as array. Length has to match nDimensions; \n');
        fprintf('parameters.nClusters = 2; \n');
        fprintf('parameters.nDimensions = 3; \n');
        fprintf('parameters.nNoise = [1 3]; %% replaces dimensions 1 and 3 with noise \n\n');
        fprintf('%% OR \n\n');
        fprintf('%% nNoise as matrix. Length has to match nClusters; \n');
        fprintf('parameters.nClusters = 2; \n');
        fprintf('parameters.nDimensions = 3; \n');
        fprintf('parameters.nNoise = [0 1; 2 0]; %% replace dimension (value) of cluster with noise \n\n');
        fprintf('config = createMDCGenConfiguration(parameters);     \n');
        fprintf('[ result ] = mdcgen( config );                     \n\n');
        
    case 'validity'
        fprintf('\nExample on how to configure validity: \n\n');
        fprintf('parameters.validity.Silhouette = 1; \n');
        fprintf('parameters.validity.Gindices = 1; \n\n');
        fprintf('config = createMDCGenConfiguration(parameters);     \n');
        fprintf('[ result ] = mdcgen( config );                     \n\n');
        
    case 'userDistribution'
        fprintf('\nExample on how to configure userDistribution: \n\n');
        fprintf('userDistribution(1).binProbability = [1 0]; \n');
        fprintf('userDistribution(1).edges = [-1 0 1]; \n\n');
        fprintf('config = createMDCGenConfiguration(userDistribution);     \n');
        fprintf('[ result ] = mdcgen( config );                     \n\n');
  

    otherwise
        fprintf('-------------------------- Usage --------------------------\n\n');
        fprintf('\nUsage: >> mdc_help [OPTION] \n\n');
        fprintf('Following values can be inserted for [OPTION]:  \n\n');
        fprintf("example ... to display a basic hello world example for MDCGen     \n");
        fprintf('input   ... to display all possible input config parameters     \n');
        fprintf('outut   ... to display MDCGen output parameters     \n\n');
        fprintf('To display examples for each configuration parameter enter for example:     \n');
        fprintf('>> mdc_help distribution     \n');
        fprintf('This shows examples for configuration options for each field     \n');
        fprintf('------------------------------------------------------------\n\n');


end

end
 







