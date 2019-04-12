classdef CreateOwnDistributionTest < matlab.unittest.TestCase
   
    properties
       compactness; 
    end
    
    methods(TestMethodSetup)
        function setup(test)
            addpath(genpath('../src'));
            rng(10);
            test.compactness = 1;
        end
    end
    
    methods(Test)
        function testUserDefinedDistribution(test) 

            distributionIndex = 1;
            userDistribution.binProbability = [1, 0];
            userDistribution.edges = [0, 0.1, 1];
            nPoints = 40;
            
            distributedPoints = createOwnDistribution(distributionIndex, userDistribution, test.compactness, nPoints);
            
            test.verifyEmpty(distributedPoints(distributedPoints > 0.1), "Distributed points are positioned wrong");
        end
        
        function testUserDefinedMultipleDistributions(test)

            distributionIndex = 2;
            userDistribution(1).binProbability = [1, 0];
            userDistribution(1).edges = [0, 0.1, 1];
            userDistribution(2).binProbability = [0, 1];
            userDistribution(2).edges = [0, 0.9, 1];
            nPoints = 40;
            
            distributedPoints = createOwnDistribution(distributionIndex, userDistribution, test.compactness, nPoints);
            
            test.verifyEmpty(distributedPoints(distributedPoints < 0.9), "Distributed points are positioned wrong");
        end

    end
end

