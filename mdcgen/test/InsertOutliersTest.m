classdef InsertOutliersTest < matlab.unittest.TestCase
    
    properties
        nClusters;
        dimensionIndex;
        intersectionIndex;  
    end
    
    methods (TestMethodSetup)
        function setup(test)
            addpath(genpath('../src'));
            rng(10);
            test.nClusters = 2;
            test.dimensionIndex = 2;
            test.intersectionIndex = [7, 3, 5];
        end
    end
    
    methods (Test)
        function testInsertOutlier(test)
            nIntersections = [9, 3];
            nOutliers = 1;
            nDimensions = 2;
            
            [outliers] = insertOutliers(test.intersectionIndex, test.dimensionIndex, nIntersections, test.nClusters, nOutliers, nDimensions);
            
            test.verifyEqual(outliers, [0.63, 0.21], 'RelTol', 0.1, "Outliers position is wrong");
        end
        
        function testCalculateCentroidsOneCluster(test)
            nIntersections = [9, 3];
            nOutliers = 2;
            nDimensions = 2;
            
            [outliers] = insertOutliers(test.intersectionIndex, test.dimensionIndex, nIntersections, test.nClusters, nOutliers, nDimensions);
            
            test.verifyEqual(outliers, [0.63, 0.21; 0.62 , 0.28], 'RelTol', 0.1, "Outliers position is wrong");
        end
        
        function testFillingRemainingDimensions(test)
            nIntersections = [9, 3, 3, 7, 12];
            nOutliers = 1;
            nDimensions = 4;
            
            [outliers] = insertOutliers(test.intersectionIndex, test.dimensionIndex, nIntersections, test.nClusters, nOutliers, nDimensions);
            
            test.verifyEqual(outliers, [0.63, 0.21, 0.55 , 0.49], 'RelTol', 0.1, "Outliers position is wrong");
        end
    end
end

