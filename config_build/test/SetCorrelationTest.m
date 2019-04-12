classdef SetCorrelationTest < matlab.unittest.TestCase

    methods(TestMethodSetup)
        function setup(testCase)
            addpath(genpath('../src'));
            rng(5);
        end
    end
    
    methods (Test)
        
        function testCorrelationDefinedForEveryCluster(testCase)
            correlationIn = [0.2,0.4,0.5];
            nClusters = 3;
            correlation = setCorrelation(correlationIn, nClusters);
            testCase.verifyEqual(correlation, [0.2,0.4,0.5], "Correlation is not set correctly");
        end
        
        function testSetCorrelationNotDefinedPerCluster(testCase)
            correlationIn = 0.7;
            nClusters = 3;
            correlation = setCorrelation(correlationIn, nClusters);
            testCase.verifyEqual(correlation, [-0.38, 0.51, -0.41], 'RelTol', 0.1, "Correlation is not set correctly");
        end
        
        function testCorrelationSetToZero(testCase)
            correlationIn = 0;
            nClusters = 3;
            correlation = setCorrelation(correlationIn, nClusters);
            testCase.verifyEqual(correlation, [0,0,0], "Correlation is not set correctly");
        end
        
        function testErrorThrownOnWrongCorrelationArrayLength(testCase)
            testCase.verifyError(@()setCorrelation([0.1, 0.3], 3),'setCorrelation:ConfigurationError');       
        end
        
        function testErrorThrownOnWrongTooLargeCorrelationValue(testCase)
            testCase.verifyError(@()setCorrelation([1, 3, 5], 3),'setCorrelation:ConfigurationError');       
        end
        
        function testErrorThrownOnWrongTooSmalleCorrelationValue(testCase)
            testCase.verifyError(@()setCorrelation([0.3, -3, 0.5], 3),'setCorrelation:ConfigurationError');       
        end
    end
end

