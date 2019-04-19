%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
% function [config] = createMDCGenConfiguration( config )
%
% Description: 
%   The function createMDCGenConfiguration takes a struct as input
%   configuration and inilializes all elements that are not set with default
%   values. 
%
% Inputs:
%   configIn.
%       seed: seed for the generation of random values
%       nDatapoints: number of samples
%       nDimensions: number of dimensions/features
%       nClusters: number of clusters
%       minimumClusterMass: minimum cluster mass
%       distribution: type of distribution
%       distributionFlag: available distributions for randomizing
%       multivariate: multivariate distributions or distributions defining
%         intra-distances
%       correlation: correlated variables (degree)
%       compactness: compactness factor (relative to the total space [0,...,1])
%       alphaN: determines grid separation as a factor (positive) or an
%              absolute value (negative)
%       scale: optimizes cluster separation based on grid size
%       rotation: cluster rotation
%       nOutliers: number of outliers
%       nNoise: number of noisy dimensions.
%       validity: type of validity indices 'all', 'Silhouette', 'G-indices'
%
% Outputs:
%   config.
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
% Author:     Denis Ojdanic <denis.ojdanic@yahoo.com>
% Supervisor: Félix Iglesias Vázquez <felix.iglesias@nt.tuwien.ac.at>
% Date: 16.02.2019
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 


function [config] = createMDCGenConfiguration( configIn, userDistributionsIn )
    
    loadDefaultConstants;

    if ~exist('configIn') 
        configIn = [];
        warning('Using default values for the whole configuration');
    end
    
    if ~isfield(configIn,'seed')
        configIn.seed = DEFAULT_SEED; 
        warning('Using default value for seed = %d', DEFAULT_SEED);
    end
    
    if ~isfield(configIn,'nDatapoints')
        configIn.nDatapoints = DEFAULT_N_DATAPOINTS;
        warning('Using default value for nDatapoints = %d', DEFAULT_N_DATAPOINTS);
    end
    
    if ~isfield(configIn,'nDimensions')
        configIn.nDimensions= DEFAULT_N_DIMENSIONS;
        warning('Using default value for nDimensions = %d', DEFAULT_N_DIMENSIONS);
    end
    
    if ~isfield(configIn,'nClusters')
        configIn.nClusters = DEFAULT_N_CLUSTERS;
        warning('Using default value for nClusters = %d', DEFAULT_N_CLUSTERS);
    end
    
    if ~isfield(configIn,'clusterMass')
        configIn.clusterMass = DEFAULT_CLUSTER_MASS;
        warning('Using default value for clusterMass = []');
    end
    
    if ~isfield(configIn,'minimumClusterMass')
        configIn.minimumClusterMass = DEFAULT_MINIMUM_CLUSTER_MASS; 
        warning('Using default value for minimumClusterMass = %d', DEFAULT_MINIMUM_CLUSTER_MASS);
    end
    
    if ~isfield(configIn,'distribution')
        configIn.distribution = DEFAULT_DISTRIBUTION;
        warning('Using default value for distribution = %d', DEFAULT_DISTRIBUTION);
    end
    
    if ~isfield(configIn,'distributionFlag') 
        configIn.distributionFlag = DEFAULT_DISTRIBUTION_FLAG;
        warning('Using default value for distributionFlag = %d', DEFAULT_DISTRIBUTION_FLAG);
    end
    
    if ~isfield(configIn,'multivariate') 
        configIn.multivariate= DEFAULT_MULTIVARIATE;
        warning('Using default value for multivariate = %d', DEFAULT_MULTIVARIATE);
    end
    
    if ~isfield(configIn,'correlation') 
        configIn.correlation = DEFAULT_CORRELATION;
        warning('Using default value for correlation = %d', DEFAULT_CORRELATION);
    end
    
    if ~isfield(configIn,'compactness') 
        configIn.compactness = DEFAULT_COMPACTNESS;
        warning('Using default value for compactness = %d', DEFAULT_COMPACTNESS);
    end
    
    if ~isfield(configIn,'alpha') && ~isfield(configIn,'alphaFactor') 
        configIn.alpha = [];
        warning('Using default value for alpha = []');
        configIn.alphaFactor = DEFAULT_ALPHA_FACTOR;
        warning('Using default value for alphaFactor = %d', DEFAULT_ALPHA_FACTOR);
    end
    
    if ~isfield(configIn,'alphaFactor') && isfield(configIn, 'alpha')
        configIn.alphaFactor = [];
        warning('Using default value for alphaFactor = []');
    end
    
    if ~isfield(configIn,'alpha') && isfield(configIn, 'alphaFactor')
        configIn.alpha = [];
        warning('Using default value for alpha = []');
    end
    
    if ~isfield(configIn,'scale') 
        configIn.scale = DEFAULT_SCALE; 
        warning('Using default value for scale = %d', DEFAULT_SCALE );
    end
    
    if ~isfield(configIn,'nOutliers') 
        configIn.nOutliers = DEFAULT_N_OUTLIERS; 
        warning('Using default value for nOutliers = %d', DEFAULT_N_OUTLIERS);
    end
    
    if ~isfield(configIn,'rotation') 
        configIn.rotation = DEFAULT_ROTATION; 
        warning('Using default value for rotation = %d', DEFAULT_ROTATION);
    end
    
    if ~isfield(configIn,'nNoise') 
        configIn.nNoise = DEFAULT_NOISE;
        warning('Using default value for nNoise = %d', DEFAULT_NOISE);
    end
    
    if ~isfield(configIn,'validity') 
        configIn.validity.Silhouette = DEFAULT_VALIDITY_SILHOUETTE;
        configIn.validity.Gindices = DEFAULT_VALIDITY_GINDICES;
        warning('Using default value for validity');
    end
    
    if ~isfield(configIn.validity,'Silhouette') 
        configIn.validity.Silhouette = DEFAULT_VALIDITY_SILHOUETTE; 
        warning('Using default value for Silhouette = %d', DEFAULT_VALIDITY_SILHOUETTE);
    end
    
    if ~isfield(configIn.validity,'Gindices') 
        configIn.validity.Gindices = DEFAULT_VALIDITY_GINDICES; 
        warning('Using default value for Gindices = %d', DEFAULT_VALIDITY_GINDICES);
    end 
    
    nUserDistributions = 0;    
    % User distributions
    if ~exist('userDistributionsIn') 
        userDistributions = [];
    else
        nUserDistributions = length(userDistributionsIn);
        
        for i = 1 : nUserDistributions
            
            if (~isfield(userDistributionsIn(i), 'binProbability') || isempty(userDistributionsIn(i).binProbability) )
                error('createMDCGenConfiguration:ConfigurationError', 'binProbability is not set.');
            elseif (~isfield(userDistributionsIn(i), 'edges') || isempty(userDistributionsIn(i).edges) )
                error('createMDCGenConfiguration:ConfigurationError', 'edges is not set.');
            else
                nEdges = numel(userDistributionsIn(i).edges);
                nBinProbability =  numel(userDistributionsIn(i).binProbability);
                if (nEdges - nBinProbability) ~= 1
                    error('createMDCGenConfiguration:ConfigurationError', 'Number of edges %d must be equal to number of binProbability %d plus 1.', nEdges, nBinProbability);
                end
                
                sumBinProbability = sum(userDistributionsIn(i).binProbability);
                if (sumBinProbability ~= 1)
                    error('createMDCGenConfiguration:ConfigurationError', 'Sum of binProbability %d != 1.', sumBinProbability);
                end
            end
        end
        userDistributions = userDistributionsIn;
    end
   
    
    

addpath(genpath('../../extra_tools'));
% -------------- Checking code from third parties
if (sum(configIn.correlation)>0 && exist('nearestSPD')==0)
    error('"nearestSPD" is required to implement feature correlations. Download it for free from: https://de.mathworks.com/matlabcentral/fileexchange/42885-nearestspd');
end


rng(configIn.seed); % Establishing random seed

% -------------- Checking consistency and normalizing config value
nClusters = configIn.nClusters;
[pointsPerCluster] = setClusterMass(nClusters, configIn.clusterMass, configIn.minimumClusterMass, configIn.nDatapoints);
distribution = setDistribution(configIn.distribution, configIn.nDimensions, nClusters);
multivariate = setProperty( configIn.multivariate, "multivariate", nClusters, "nClusters");
[alpha, alphaFactor] = setAlpha(configIn.alpha, configIn.alphaFactor, configIn.nDimensions);
scale = setProperty(configIn.scale, "scale", nClusters, "nClusters");
rotation = setProperty(configIn.rotation, 'rotation', nClusters, 'nClusters');
correlation = setCorrelation(configIn.correlation, nClusters);
[nAvailableDistributions,indicesAvailableDistributions] = setDistributionFlag(configIn.distributionFlag, nUserDistributions);
nIntersections = calculateNIntersections(nClusters, configIn.nOutliers, configIn.nDimensions, alpha, alphaFactor);
[noise, noiseType] = setNoise(configIn.nNoise, configIn.nDimensions, nClusters);
compactness = setProperty(configIn.compactness, "compactness", nClusters, "nClusters");

for iCluster = 1 : nClusters
    
    if scale(iCluster) > 0
        compactness(iCluster) = compactness(iCluster) / max(nIntersections);
    elseif scale(iCluster) < 0
        compactness(iCluster) = compactness(iCluster) / min(nIntersections);
    end
end

config.nDatapoints      = configIn.nDatapoints;
config.nDimensions      = configIn.nDimensions;
config.nOutliers        = configIn.nOutliers;
config.pointsPerCluster = pointsPerCluster;
config.distribution     = distribution;
config.nClusters        = nClusters;
config.multivariate     = multivariate;
config.correlation      = correlation;
config.compactness      = compactness;
config.rotation         = rotation;
config.nIntersections   = nIntersections;
config.noise            = noise;
config.noiseType        = noiseType;

config.nAvailableDistributions = nAvailableDistributions;
config.indicesAvailableDistributions = indicesAvailableDistributions;
config.validity.Silhouette = configIn.validity.Silhouette;
config.validity.Gindices = configIn.validity.Gindices;

config.userDistributions = userDistributions;
    
end