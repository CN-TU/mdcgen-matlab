classdef CalculateNIntersectionsTest < matlab.unittest.TestCase

    methods(TestMethodSetup)
        function setup(testCase)
            addpath(genpath('../src'));
        end
    end
    
    methods (Test)
        function testSetNIntersectionsForMultipleClusters(testCase)
            nClusters = 2;
            nOutliers = 1;
            dimensions = 2;
            alpha = [0, 0];
            alphaFactor = [2, 2];
            nIntersections = calculateNIntersections(nClusters, nOutliers, dimensions, alpha, alphaFactor);
            testCase.verifyEqual(nIntersections, [6, 6], "nIntersections is not set correctly");
        end
        
        function testSetNIntersectionsForMultipleClustersAndMultipleOutliers(testCase)
            nClusters = 2;
            nOutliers = 4;
            dimensions = 2;
            alpha = [0, 0];
            alphaFactor = [2, 2];
            nIntersections = calculateNIntersections(nClusters, nOutliers, dimensions, alpha, alphaFactor);
            testCase.verifyEqual(nIntersections, [12, 12], "nIntersections is not set correctly");
        end
        
        function testSetNIntersectionsxForSingleCluster_A(testCase)
            nClusters = 1;
            nOutliers = 3;
            dimensions = 2;
            alpha = [0, 0];
            alphaFactor = [2, 2];
            nIntersections = calculateNIntersections(nClusters, nOutliers, dimensions, alpha, alphaFactor);
            testCase.verifyEqual(nIntersections, [6, 6], "nIntersections is not set correctly");
        end
        
        function testSetNIntersectionsxForSingleCluster_B(testCase)
            nClusters = 1;
            nOutliers = 1;
            dimensions = 2;
            alpha = [0, 0];
            alphaFactor = [1, 1];
            nIntersections = calculateNIntersections(nClusters, nOutliers, dimensions, alpha, alphaFactor);
            testCase.verifyEqual(nIntersections, [3, 3], "nIntersections is not set correctly");
        end
        
        function testSetNIntersectionsWithAlpha_A(testCase)
            nClusters = 1;
            nOutliers = 3;
            dimensions = 2;
            alpha = [3, 2];
            alphaFactor = [0, 0];

            nIntersections = calculateNIntersections(nClusters, nOutliers, dimensions, alpha, alphaFactor);
            testCase.verifyEqual(nIntersections, [3, 2], "nIntersections is not set correctly");
        end   
        
        function testSetNIntersectionsWithAlpha_B(testCase)
            nClusters = 1;
            nOutliers = 3;
            dimensions = 4;
            alpha = [2, 0, 9, 0];
            alphaFactor = [0, 0.2, 0, 0.9];

            nIntersections = calculateNIntersections(nClusters, nOutliers, dimensions, alpha, alphaFactor);
            testCase.verifyEqual(nIntersections, [2, 1, 9, 3], "nIntersections is not set correctly");
        end  
        
        function testErrorIfNotEnoughIntersectionsForClusters(testCase)
            nClusters = 7;
            nOutliers = 0;
            dimensions = 2;
            alpha = [2, 2];
            alphaFactor = [];
            
            testCase.verifyError(@()calculateNIntersections(nClusters, nOutliers, dimensions, alpha, alphaFactor),'calculateNIntersections:ConfigurationError');
        end
    end
end

