classdef InsertCentroidsTest < matlab.unittest.TestCase
    
 
    methods (TestMethodSetup)
        function setup(testCase)
            addpath(genpath('../src'));
            rng(10);
        end
    end
    
    methods (Test)
        function testCalculateCentroids(testCase)
            nIntersections = [3, 3];
            dimensions = 2;
            nClusters = 2;
            nOutliers = 0;
            compactness = [1, 1];
            
            [centroids, ~, ~] = insertCentroids(nIntersections, dimensions, nClusters, nOutliers, compactness);
            
            testCase.verifyEqual(centroids, [0.19, 0.42; 0.75, -0.06], 'RelTol', 0.1, "Centroid position is wrong");
        end
        
        function testCalculateCentroidsOneCluster(testCase)
            nIntersections = [3, 3];
            dimensions = 2;
            nClusters = 1;
            nOutliers = 0;
            compactness = 1;
            
            [centroids, ~, ~] = insertCentroids(nIntersections, dimensions, nClusters, nOutliers, compactness);
            
            testCase.verifyEqual(centroids, [0.19, 0.42], 'RelTol', 0.1, "Centroid position is wrong");
        end
        
        function testFillingRemainingDimensions(testCase)
            nIntersections = [3, 3, 3 ,3];
            dimensions = 4;
            nClusters = 1;
            nOutliers = 0;
            compactness = 1;
            
            [centroids, ~, ~] = insertCentroids(nIntersections, dimensions, nClusters, nOutliers, compactness);
            
            testCase.verifyEqual(centroids, [0.19, 0.42, -0.18, 0.81], 'RelTol', 0.1, "Centroid position is wrong");
        end
    end

end

