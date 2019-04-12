classdef SetClusterMassTest < matlab.unittest.TestCase
    
    methods (TestMethodSetup)
        function setup(testCase)
            addpath(genpath('../src'));
            rng(10);
        end
    end
    
    methods (Test)
        function testDataPointsPerClusterConfigured(testCase) 
             nDataPoints = 100;
             nClusters = 2;
             clusterMass = [30, 70];
             
             [pointsPerCluster] = setClusterMass(nClusters, clusterMass, 0, nDataPoints);
             
             testCase.verifyEqual(length(pointsPerCluster), 2, "Number of clusters does not match");
             testCase.verifyEqual(pointsPerCluster, [30, 70], "Number of clusters does not match");
        end 
        
        function testErrorWhenSumOfClusterPointsDoesNotMatchNumberOfDatapoints(testCase) 
            nDataPoints = 100;
            nClusters = 0;
            clusterMass = [30, 70];
            testCase.verifyError(@()setClusterMass(nClusters,clusterMass,'0', nDataPoints),'setClusterMass:ConfigurationError');       
        end 
        
        function testErrorWhenNClusterSetToZero(testCase) 
            nDataPoints = 100;
            nClusters = 1;
            clusterMass = [30, 7];
            testCase.verifyError(@()setClusterMass(nClusters,clusterMass,'0', nDataPoints),'setClusterMass:ConfigurationError');       
        end
        
        function testGenerateClusterMassForClusters(testCase) 
             nDataPoints = 100;
             nClusters = 4;
             clusterMass = [];
             
             [pointsPerCluster] = setClusterMass(nClusters, clusterMass, 0, nDataPoints);
             
             testCase.verifyEqual(length(pointsPerCluster), 4, "Number of clusters does not match");
             testCase.verifyEqual(pointsPerCluster, [29, 8, 29, 34], "Number of clusters does not match");
        end 
        
        function testMinimumClusterMassConfigured(testCase) 
             nDataPoints = 100;
             nClusters = 4;
             clusterMass = [];
             minClusterMass = 25;
             
             [pointsPerCluster] = setClusterMass(nClusters,clusterMass, minClusterMass, nDataPoints);
             
             testCase.verifyEqual(length(pointsPerCluster), 4, "Number of clusters does not match");
             testCase.verifyEqual(pointsPerCluster, [25, 25, 25, 25], "Number of clusters does not match");
        end 
        
        function testMinimumClusterMassConfiguredWrong(testCase) 
            testCase.verifyError(@()setClusterMass('100','[]','4', '26'),'setClusterMass:ConfigurationError');
        end 
        
        function testNClustersDoesNotMatchClusterMassElements(testCase) 
            nDataPoints = 30;
            nClusters = 2;
            clusterMass = [10, 10, 10];
            testCase.verifyError(@()setClusterMass(nClusters,clusterMass,'0', nDataPoints),'setClusterMass:ConfigurationError');
        end 
        
        function testMinimumClusterMassHasNoEffectIfClusterMassConfigured(testCase) 
             nDataPoints = 100;
             nClusters = 2;
             clusterMass = [30, 70];
             minClusterMass = 10;
             
             [pointsPerCluster] = setClusterMass(nClusters, clusterMass, minClusterMass, nDataPoints);
             
             testCase.verifyEqual(length(pointsPerCluster), 2, "Number of clusters does not match");
             testCase.verifyEqual(pointsPerCluster, [30, 70], "Number of clusters does not match");
        end 
        
    end
end

