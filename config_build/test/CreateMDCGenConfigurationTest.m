classdef CreateMDCGenConfigurationTest < matlab.unittest.TestCase

    methods (TestMethodSetup)
        function setup(testCase)
            addpath(genpath('../src'));
            warning('off');
        end
    end
    
    methods (Test)
        function testNumberOfDimensions(testCase) 
             p.nDimensions = 5;
                
             config = createMDCGenConfiguration(p);
             testCase.verifyEqual(config.nDimensions, 5, "Number of dimensions does not match");
        end 
        
        function testDefaultNumberOfDimensions(testCase)
            loadDefaultConstants;
            config = createMDCGenConfiguration();
            testCase.verifyEqual(config.nDimensions, DEFAULT_N_DIMENSIONS, "Default number of dimensions do not match");
        end
        
        function testNumberOfDatapoints(testCase) 
             p.nDatapoints = 15;
                
             config = createMDCGenConfiguration(p);
             testCase.verifyEqual(config.nDatapoints, 15, "Number of datapoints does not match");
        end 
        
        function testDefaultNumberOfDatapoints(testCase)
            loadDefaultConstants;
            config = createMDCGenConfiguration();
            testCase.verifyEqual(config.nDatapoints, DEFAULT_N_DATAPOINTS, "Default number of datapoints do not match");
        end      
        
        function testSeed(testCase) 
             p.seed = 155;
                
             config = createMDCGenConfiguration(p);
             testCase.verifyEqual(config.pointsPerCluster, [527, 700, 139, 501, 133], "Seed does not work");
        end 
        
        function testDefaultSeed(testCase)
            loadDefaultConstants;
            config = createMDCGenConfiguration();
            testCase.verifyEqual(config.pointsPerCluster, [525, 776, 133, 381, 185], "Default seed does not match");
        end
        
        function testNumberOfOutliers(testCase) 
             p.nOutliers = 155;
                
             config = createMDCGenConfiguration(p);
             testCase.verifyEqual(config.nOutliers, 155, "nOutliers does not match");
        end 
        
        function testDefaultNumberOfOutliers(testCase)
            loadDefaultConstants;
            config = createMDCGenConfiguration();
            testCase.verifyEqual(config.nOutliers, DEFAULT_N_OUTLIERS, "Default number of outliers does not match");
        end
         
        function testNumberOfClusters(testCase) 
             p.nClusters = 12;
                
             config = createMDCGenConfiguration(p);
             testCase.verifyEqual(config.nClusters, 12, "nClusters does not match");
        end
        
        function testDefaultNumberOfClusters(testCase)
            loadDefaultConstants;
            config = createMDCGenConfiguration();
            testCase.verifyEqual(config.nClusters, DEFAULT_N_CLUSTERS, "Default number of clusters does not match");
        end
        
        function testClusterMass(testCase) 
             p.nDatapoints = 300;
             p.nClusters = 2;
             p.clusterMass = [100, 200];
                
             config = createMDCGenConfiguration(p);
             testCase.verifyEqual(config.pointsPerCluster, [100, 200], "clusterMass does not match");
        end
        
        function testMinimumClusterMass(testCase) 
             p.minimumClusterMass = 400;
                
             config = createMDCGenConfiguration(p);
             testCase.verifyEqual(config.pointsPerCluster, [400,400,400,400,400], "minimumClusterMass does not match");
        end 
        
        function testDefaultMinimumClusterMass(testCase)
            loadDefaultConstants;
            config = createMDCGenConfiguration();
            testCase.verifyEqual(config.pointsPerCluster, [525,776,133,381,185], "Default minimumClusterMass does not match");
        end
        
        function testDistribution(testCase) 
             p.distribution = 3;
             p.nClusters = 2;
                
             config = createMDCGenConfiguration(p);
             testCase.verifyEqual(config.distribution, [3,3;3,3], "distribution does not match");
        end 
        
        function testDefaultDistribution(testCase)
            loadDefaultConstants;
            p.nClusters = 2;
            config = createMDCGenConfiguration(p);
            testCase.verifyEqual(config.distribution, [0,0;0,0], "Default distribution does not match");
        end
        
        function testDistributionFlag(testCase) 
             p.distributionFlag = [1,1,0,0,1,1];
                
             config = createMDCGenConfiguration(p);
             
             testCase.verifyEqual(config.nAvailableDistributions, 4, "nAvailableDistributions not set correctly");
             testCase.verifyEqual(config.indicesAvailableDistributions, [1,2,5,6], "indicesAvailableDistributions not set correctly");
        end 
        
        function testDefaultDistributionFlag(testCase)
            loadDefaultConstants;
            config = createMDCGenConfiguration();
            testCase.verifyEqual(config.nAvailableDistributions, 6, "nAvailableDistributions not set correctly");
            testCase.verifyEqual(config.indicesAvailableDistributions, [1,2,3,4,5,6], "indicesAvailableDistributions not set correctly");
        end
        
        function testMultivariate(testCase)
            p.multivariate = 7;
            
            config = createMDCGenConfiguration(p);
            testCase.verifyEqual(config.multivariate, [7,7,7,7,7], "multivariate does not match");
        end
        
        function testDefaultMultivariate(testCase)
            loadDefaultConstants;
            config = createMDCGenConfiguration();
            testCase.verifyEqual(config.multivariate, [0,0,0,0,0], "Default multivariate does not match");
        end
        
        function testRotation(testCase)
            p.rotation = 8;
            
            config = createMDCGenConfiguration(p);
            testCase.verifyEqual(config.rotation, [8,8,8,8,8], "rotation does not match");
        end
        
        function testDefaultRotation(testCase)
            loadDefaultConstants;
            config = createMDCGenConfiguration();
            testCase.verifyEqual(config.rotation, [0,0,0,0,0], "Default rotation does not match");
        end
        
%TODO
%         function testCorrelation(testCase) 
%              p.correlation = 0.1;
%                 
%              config = createMDCGenConfiguration(p);
%              testCase.verifyEqual(config.correlation, [0.1,0.1,0.1,0.1,0.1], "correlation does not match");
%         end 

%         function testDefaultCorrelation(testCase)
%              loadDefaultConstants;
%              config = createMDCGenConfiguration();
%              testCase.verifyEqual(config.correlation, [0,0,0,0,0], "Default correlation does not match");
%         end 


        function testCompactness(testCase)
            p.compactness = 0.4;
            p.nClusters = 2;
            p.nOutliers = 0;
            config = createMDCGenConfiguration(p);
            testCase.verifyEqual(config.compactness, [0.13,0.13], 'RelTol', 0.1, "compactness does not match");
        end
        
        function testDefaultCompactness(testCase)
            loadDefaultConstants;
            p.nClusters = 2;
            p.nOutliers = 0;
            config = createMDCGenConfiguration(p);
            testCase.verifyEqual(config.compactness, [0.033, 0.033], 'RelTol', 0.1, "Default compactness does not match");
        end
        
        
        function testAlphaFactor(testCase)
            p.alphaFactor = 7;
            p.nOutliers = 0;            
            config = createMDCGenConfiguration(p);
            testCase.verifyEqual(config.nIntersections, [28,28], "alphaFactor does not match");
        end 
        
        function testAlpha(testCase)
            p.alpha = 12;
            
            config = createMDCGenConfiguration(p);
            testCase.verifyEqual(config.nIntersections, [12,12], "alphaFactor does not match");
        end 
        
        function testDefaultAlphaFactor(testCase)
            loadDefaultConstants;
            p.nOutliers = 0;
            config = createMDCGenConfiguration(p);
            testCase.verifyEqual(config.nIntersections, [4,4], "Default alpha does not match");
        end 
                
        function testScale(testCase) 
             p.scale = 6;
             p.nClusters = 2;
             p.nOutliers = 0;
                
             config = createMDCGenConfiguration(p);
             testCase.verifyEqual(config.compactness, [0.0333, 0.0333], 'RelTol', 0.01, "scale does not match");
        end 
        
        function testDefaultScale(testCase)
            loadDefaultConstants;
            p.nClusters = 2;
            p.nOutliers = 0;
            config = createMDCGenConfiguration(p);
            testCase.verifyEqual(config.compactness, [0.0333, 0.0333], 'RelTol', 0.01, "Default scale does not match");
        end
                
        function testNoise(testCase) 
             p.nNoise = 2;
                
             config = createMDCGenConfiguration(p);
             testCase.verifyEqual(config.noise, [2 1], "noise does not match");
             testCase.verifyTrue(strcmp(config.noiseType, 'array'), "noise does not match");
        end 
        
        function testDefaultNNoise(testCase)
            loadDefaultConstants;
            config = createMDCGenConfiguration();
            testCase.verifyEqual(config.noise, [], "Default noise does not match");
            testCase.verifyTrue(strcmp(config.noiseType, 'array'), "noise does not match");
        end
        
        function testValiditySilhouette(testCase) 
             p.validity.Silhouette = 3;
                
             config = createMDCGenConfiguration(p);
             testCase.verifyEqual(config.validity.Silhouette, 3, "validity.Silhouette does not match");
        end 
        
        function testDefaultValiditySilhouette(testCase)
            loadDefaultConstants;
            config = createMDCGenConfiguration();
            testCase.verifyEqual(config.validity.Silhouette, DEFAULT_VALIDITY_SILHOUETTE, "Default validity.Silhouette does not match");
        end
        
        function testValidityGindices(testCase) 
             p.validity.Gindices = 3;
                
             config = createMDCGenConfiguration(p);
             testCase.verifyEqual(config.validity.Gindices, 3, "validity.Gindices does not match");
        end 
     
        function testDefaultValidityGindices(testCase)
             loadDefaultConstants;
             config = createMDCGenConfiguration();
             testCase.verifyEqual(config.validity.Gindices, DEFAULT_VALIDITY_GINDICES, "Default validity.Gindices does not match");
        end 
        
        function testUserDistibutionsEmpty(testCase) 
             config = createMDCGenConfiguration();
             testCase.verifyEqual(config.userDistributions, [], "user distributions not empty");
        end 
        
        function testUserDistibutionsDefined(testCase)
            config = createMDCGenConfiguration();
            testCase.verifyEqual(config.userDistributions, [], "user distributions not empty");
        end
        
        function testMultipleUserDistibutionsDefined(testCase)
            userDistributions(1).binProbability = [0.1, 0.9];
            userDistributions(1).edges = [-1, 0, 1];
            userDistributions(2).binProbability = [0.2, 0.8];
            userDistributions(2).edges = [-1, 0, 1];

            config = createMDCGenConfiguration([], userDistributions);
            testCase.verifyEqual(config.nAvailableDistributions, 8, "user distributions not empty");
        end
        
        function testErrorThrownOnUserDistributionBinProbabilityNotSet_A(testCase)
            userDistributions.edges = [-1, 0, 1];
            testCase.verifyError(@()createMDCGenConfiguration([], userDistributions),'createMDCGenConfiguration:ConfigurationError');
        end
        
        function testErrorThrownOnUserDistributionBinProbabilityNotSet_B(testCase)
            userDistributions(1).edges = [-1, 0, 1];
            userDistributions(2).binProbability = [0.1, 0.9];
            userDistributions(2).edges = [-1, 0, 1];
            testCase.verifyError(@()createMDCGenConfiguration([], userDistributions),'createMDCGenConfiguration:ConfigurationError');
        end
        
        function testErrorThrownOnUserDistributionEdgesNotSet_A(testCase)
            userDistributions.binProbability = [0.1, 0.9];
            testCase.verifyError(@()createMDCGenConfiguration([], userDistributions),'createMDCGenConfiguration:ConfigurationError');
        end
        
        function testErrorThrownOnUserDistributionEdgesNotSet_B(testCase)
            userDistributions(1).binProbability = [-1, 0, 1];
            userDistributions(2).binProbability = [0.1, 0.9];
            userDistributions(2).edges = [-1, 0, 1];
            testCase.verifyError(@()createMDCGenConfiguration([], userDistributions),'createMDCGenConfiguration:ConfigurationError');
        end
        
        function testErrorThrownWhenSizeEdgesNotNumberBinProbabilitesPlusOne_A(testCase)
            userDistributions.binProbability = [0.1, 0.9];
            userDistributions.edges = 0.1;
            testCase.verifyError(@()createMDCGenConfiguration([], userDistributions),'createMDCGenConfiguration:ConfigurationError');
        end
        
        function testErrorThrownWhenSizeEdgesNotNumberBinProbabilitesPlusOne_B(testCase)
            userDistributions.binProbability = [0.1, 0.9];
            userDistributions.edges = [2, 1, 2, 4];
            testCase.verifyError(@()createMDCGenConfiguration([], userDistributions),'createMDCGenConfiguration:ConfigurationError');
        end
        
        function testErrorThrownWhenNEdgesNotGreaterThenNBinProbabilites_B(testCase)
            userDistributions(1).binProbability = [0.1, 0.9];
            userDistributions(1).edges = 1;
            userDistributions(2).binProbability = [0.1, 0.9];
            userDistributions(2).edges = [-1, 0, 1];
            testCase.verifyError(@()createMDCGenConfiguration([], userDistributions),'createMDCGenConfiguration:ConfigurationError');
        end
        
        function testErrorThrownWhenSumBinProbabilitiesNotOne(testCase)
            userDistributions.binProbability = [0.1, 0.8];
            userDistributions.edges = [-1, 0, 1];
            testCase.verifyError(@()createMDCGenConfiguration([], userDistributions),'createMDCGenConfiguration:ConfigurationError');
        end
    end
end

