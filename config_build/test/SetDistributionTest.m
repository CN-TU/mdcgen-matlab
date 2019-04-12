classdef SetDistributionTest < matlab.unittest.TestCase

    methods(TestMethodSetup)
        function setup(testCase)
            addpath(genpath('../src'));
        end
    end
    
    methods (Test)
        function testOneDistributionIsSetForEveryClusterAndEveryDimension(testCase)
            distributionIn = 3;
            nDimensions = 2;
            nClusters = 3;
            distribution = setDistribution(distributionIn, nDimensions, nClusters);
            testCase.verifyEqual(distribution, [3, 3, 3; 3, 3, 3], "Distribution is not set correctly");
        end
        
        function testDistributionIsSetPerClusterAndEveryDimension(testCase)
            distributionIn = [1, 3, 2];
            nDimensions = 2;
            nClusters = 3;
            distribution = setDistribution(distributionIn, nDimensions, nClusters);
            testCase.verifyEqual(distribution, [1, 3, 2; 1, 3, 2], "Distribution is not set correctly");
        end
        
        function testErrorThrownOnWrongNumberOfDistributionsPerCluster(testCase)
            testCase.verifyError(@()setDistribution([1, 3], 2, 3),'setDistribution:ConfigurationError');       
        end
        
        
        function testErrorThrownOnDistributionAsMatrix(testCase)
            testCase.verifyError(@()setDistribution([1, 3, 3; 3, 3, 2],2, 2),'setDistribution:ConfigurationError');       
        end
        
        function testDistributionIsSetPerClusterAndPerDimension(testCase)
            distributionIn = [1, 3, 3; 3, 4, 5];
            nDimensions = 2;
            nClusters = 3;
            distribution = setDistribution(distributionIn, nDimensions, nClusters);
            testCase.verifyEqual(distribution, distributionIn, "Distribution is not set correctly");
        end
    end
end

