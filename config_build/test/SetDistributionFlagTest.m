classdef SetDistributionFlagTest < matlab.unittest.TestCase
     
    methods(TestMethodSetup)
        function setup(testCase)
            addpath(genpath('../src'));
            rng(5);
        end
    end
    
    methods (Test)
        
        function testAllDistributionsAvailable(testCase)
            distributionFlag = 1;
            nUserDefinedDistribution = 0;
            [nAvDist,indexAvDist] = setDistributionFlag(distributionFlag, nUserDefinedDistribution);
            testCase.verifyEqual(nAvDist, 6, "Number of available distributions is wrong");
            testCase.verifyEqual(indexAvDist, [1, 2, 3, 4, 5, 6], "Indices of available distributions are wrong");
        end
        
        function testAllDistributionsUnavailableResultsInAllAvailable(testCase)
            distributionFlag = 0;
            nUserDefinedDistribution = 0;
            [nAvDist,indexAvDist] = setDistributionFlag(distributionFlag, nUserDefinedDistribution);
            testCase.verifyEqual(nAvDist, 6, "Number of available distributions is wrong");
            testCase.verifyEqual(indexAvDist, [1, 2, 3, 4, 5, 6], "Indices of available distributions are wrong");
        end
        
        function testSomeDistributionsAvailable(testCase)
            distributionFlag = [1,0,1,1,1,0];
            nUserDefinedDistribution = 0;
            [nAvDist,indexAvDist] = setDistributionFlag(distributionFlag, nUserDefinedDistribution);
            testCase.verifyEqual(nAvDist, 4, "Number of available distributions is wrong");
            testCase.verifyEqual(indexAvDist, [1, 3, 4, 5], "Indices of available distributions are wrong");
        end
        
        function testUserDefinedDistributions(testCase)
            distributionFlag = 1;
            nUserDefinedDistribution = 2;
            [nAvDist,indexAvDist] = setDistributionFlag(distributionFlag, nUserDefinedDistribution);
            testCase.verifyEqual(nAvDist, 8, "Number of available distributions is wrong");
            testCase.verifyEqual(indexAvDist, [1,2,3,4,5,6,7,8], "Indices of available distributions are wrong");
        end
           
        function testErrorThrownOnWrongLengthOfDistributionFlagArray(testCase)
            testCase.verifyError(@()setDistributionFlag([1, 0, 1], 1),'setDistributionFlag:ConfigurationError');       
        end
        
        function testErrorThrownOnNegativeFlagEntry(testCase)
            testCase.verifyError(@()setDistributionFlag([-1, 0, 1,0,0,0], 1),'setDistributionFlag:ConfigurationError');       
        end
        
        function testErrorThrownOnFlagLargerThanOne(testCase)
            testCase.verifyError(@()setDistributionFlag([5, 0, 1,0,0,0], 1),'setDistributionFlag:ConfigurationError');       
        end
    end
end

