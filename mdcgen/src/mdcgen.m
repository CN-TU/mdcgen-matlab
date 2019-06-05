%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
% [ result ] = mdcgen( config )
%
% Description: generates synthetic n-dimensional datasets for clustering
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
%   
%
% Outputs:
%   result 
%       .dataPoints         output matrix containing data points         
%       .label              array containing the labels of the data points
%       .perf               performance    
%           .Silhouette:    global Silhouette index 
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


function [ result ] = mdcgen( p )

% initialize mdcgen configuration
c = createMDCGenConfiguration(p);

nDatapoints      = c.nDatapoints;      
nDimensions      = c.nDimensions;
nOutliers        = c.nOutliers;
nClusters        = c.nClusters;
compactness      = c.compactness;
nIntersections   = c.nIntersections;
noise            = c.noise;
noiseType        = c.noiseType;

% insert cluster centroids
[centroids, intersectionIndex, dimensionIndex] = insertCentroids(nIntersections, nDimensions, nClusters, nOutliers, compactness);

% create and insert cluster points 
[ result, dataPoints, dataPointsLabel ] = insertClusterPoints( c, centroids );


% create and insert outliers
if nOutliers > 0
    outliers = insertOutliers(intersectionIndex, dimensionIndex, nIntersections, nClusters, nOutliers, nDimensions);
    dataPoints = [dataPoints; outliers];
    outliersLabel = zeros(nOutliers, 1);
    dataPointsLabel = [dataPointsLabel; outliersLabel];
end

% insert noise
if strcmp(noiseType,'array') %array
    [~,n]=size(noise);
    for iCluster = 1 : n
        probabilityDistribution = makedist('Uniform','Lower',0,'Upper',1); 
        noisePoints = random(probabilityDistribution, (nDatapoints + nOutliers), 1);
        dimension = noise(iCluster);
        if (dimension > 0)
            dataPoints(:,dimension) = noisePoints;
        end
    end
end

result.dataPoints = dataPoints;
result.label = dataPointsLabel;


% validation
if (c.validity.Silhouette)
    result.perf.Silhouette = mean( silhouette(dataPoints, dataPointsLabel,'Euclidean') ); 
end
end


