%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
% [ result ] = insertClusterPoints( config, centroids )
%
% Description: inserts cluster data points to the dataset
%
% Inputs:
%   configIn.
%       nDatapoints:        number of samples
%       nDimensions:        number of dimensions/features
%       nOutliers:          number of outliers
%       pointsPerCluster:   number of points per cluster
%       distribution:       type of distribution
%       nClusters:          number of clusters
%       multivariate:       multivariate distributions or distributions 
%                           defining intra-distances
%       compactness:        compactness factor (relative to the total 
%                           space [0,...,1])
%       rotation:           cluster rotation
%       nIntersections:     number of intersections per dimension
%       noise:              the configured noise
%       noiseType:          whether noise is an array or a matrix
%       correlation:        correlated variables (degree)
%       nAvailableDistributions: number of available distributions
%       indicesAvailableDistributions: indices of the available
%                                      distributions
%       validity:           type of validity indices 'all', 'Silhouette', 
%                           'G-indices'
%       centroids:          array with the centroid coordinates
%       intersectionIndex:  array of indices of intersections to locate
%                           clustes/outliers
%       dimensionIndex:     index of main dimensions (other dimensions are 
%                           assigned randomly)
%   
%
% Outputs:
%   result 
%       .dataPoints         output matrix containing data points         
%       .label              array containing the labels of the data points
%       .perf               performance    
%           .Gstr:          strict global overlap index    
%           .Grex:          relaxed global overlap index 
%           .Gmin:          minimum global overlap index
%           .oi_st:         strict individual overlap index (cluster)
%           .oi_rx:         relaxed individual overlap index (cluster)
%           .oi_mn:         minimum individual overlap index (cluster)
%
% Author:     Denis Ojdanic <denis.ojdanic@yahoo.com>
% Supervisor: Félix Iglesias Vázquez <felix.iglesias@nt.tuwien.ac.at>
% Date: 07.03.2019
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 


function [ result, dataPoints, dataPointsLabel ] = insertClusterPoints( config, centroids )

nDimensions      = config.nDimensions;
pointsPerCluster = config.pointsPerCluster;
distribution     = config.distribution;
nClusters        = config.nClusters;
multivariate     = config.multivariate;
correlation      = config.correlation;
compactness      = config.compactness;
rotation         = config.rotation;
noise            = config.noise;
noiseType        = config.noiseType;

nAvailableDistributions = config.nAvailableDistributions;
indicesAvailableDistributions = config.indicesAvailableDistributions;

userDistributions = config.userDistributions;

dataPoints = [];
dataPointsLabel = []; 
clusterLabel = 1; 

medianStatistic = zeros(1, nClusters);
meanStatistic = zeros(1, nClusters);
standardDeviationStatistic = zeros(1, nClusters);

for iCluster = 1 : nClusters
    
    if multivariate(iCluster) == 0 % multivariate or radial, choose randomly
        multivariate(iCluster) = sign(rand()-0.5);
    end     
    
    if multivariate(iCluster) > 0 % distributions define feature values (multivariate)
       
        for jDimension = 1 : nDimensions 
            if distribution(jDimension, iCluster) == 0
                distribution(jDimension, iCluster) = indicesAvailableDistributions( 1 + floor(nAvailableDistributions * rand()) );
            end
        end
        clusterPoints = multivariateDistribution(iCluster,pointsPerCluster(iCluster), nDimensions, distribution, compactness(iCluster), userDistributions);
        
    else %mv(i)==-1                           %  distributions define intra-distances         
        if distribution(1, iCluster) == 0
            distribution(:,iCluster) = indicesAvailableDistributions( 1 + floor(nAvailableDistributions * rand()));
        end
        clusterPoints = radialBasedDistribution(iCluster,distribution, pointsPerCluster(iCluster), nDimensions, compactness(iCluster), userDistributions);
    end
   
    % -------------- Calculating covariance matrix for cluster 'i'

    if correlation(iCluster) ~= 0
        [T, p] = calculateCorrelationMatrix(nDimensions,correlation, iCluster);

        if p == 0
            clusterPoints = clusterPoints * T;
        end
    end
    
    % -------------- Calculating rotation matrix for cluster 'i'
    if (rotation(iCluster)) %random rotation
        rotationMatrix = 2 * (rand(nDimensions) - 0.5);
        rotationMatrix = orth(rotationMatrix);
        [m,n] = size(rotationMatrix);
        if m == n && n == nDimensions % 'rotM' keeps NxN dimensions
            clusterPoints = clusterPoints * rotationMatrix;
        end
    end
    
    % -------------- Adding noisy variables
    if strcmp(noiseType,'matrix') 
        [m,~] = size(noise);
        for jDimension = 1 : m
            probabilityDistribution = makedist('Uniform','Lower',0,'Upper',1); 
            noisePoints = random(probabilityDistribution, pointsPerCluster(iCluster), 1);
            if (noise(jDimension, iCluster) > 0) 
                clusterPoints(:, noise(jDimension,iCluster)) = noisePoints; 
            end
        end
    end
    
    % -------------- Placing clusters in the output space
    clusterPoints = bsxfun(@plus, clusterPoints,centroids(iCluster,:)); 
    dataPoints = [dataPoints; clusterPoints];
    
    % -------------- Updating labels
    iClusterLabel = ones(pointsPerCluster(iCluster), 1) * clusterLabel;
    dataPointsLabel = [dataPointsLabel; iClusterLabel];
    clusterLabel = clusterLabel + 1;
    
    % -------------- Saving intra-clust dist statistics
    medianStatistic(iCluster) = median( pdist2(clusterPoints, centroids(iCluster,:)) );    
    meanStatistic(iCluster) = mean( pdist2(clusterPoints, centroids(iCluster,:)) );  
    standardDeviationStatistic(iCluster) = std( pdist2(clusterPoints, centroids(iCluster,:)) );  
end

interClusterDistance = dist(centroids');

% validation
result = [];
if (config.validity.Gindices)
    addpath(genpath('../../extra_tools'));
    result.perf = Gvalidity(nClusters, interClusterDistance, medianStatistic, meanStatistic, standardDeviationStatistic, pointsPerCluster); 
end


end


