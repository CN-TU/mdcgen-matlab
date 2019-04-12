classdef SetAlphaTest < matlab.unittest.TestCase

    methods(TestMethodSetup)
        function setup(testCase)
            addpath(genpath('../src'));
        end
    end
    
    methods (Test)
             
        function testErrorWhenAlphaLengthDoesNotMatchNDimensions(testCase)
            alpha = [3, 2, 12];
            alphaFactor = [];
            nDimensions = 2;
            testCase.verifyError(@()setAlpha(alpha,alphaFactor,nDimensions),'setAlpha:ConfigurationError');
        end
        
        function testErrorWhenAlphaFactorLengthDoesNotMatchNDimensions(testCase)
            alpha = [];
            alphaFactor = [3,3,12];
            nDimensions = 2;
            testCase.verifyError(@()setAlpha(alpha,alphaFactor,nDimensions),'setAlpha:ConfigurationError');
        end
        
        function testErrorIfAlphaAndAlphaFactorDoNotMatchNDimensions(testCase)
            alpha = 4;
            alphaFactor = [1, 12, 0.4];
            nDimensions = 3;
            
            testCase.verifyError(@()setAlpha(alpha,alphaFactor,nDimensions),'setAlpha:ConfigurationError');
        end
        
        function testAlphaAsScalar(testCase)
            alpha = 3;
            alphaFactor = [];
            nDimensions = 3;
            [alpha, alphaFactor] = setAlpha(alpha, alphaFactor, nDimensions);
            testCase.verifyEqual(alpha, [3, 3, 3], "alpha is not set correctly");
            testCase.verifyEqual(alphaFactor, [], "alphaFactor is not set correctly");
        end
        
        function testAlpha(testCase)
            alpha = [3, 2, 12];
            alphaFactor = [];
            nDimensions = 3;
            [alpha, alphaFactor] = setAlpha(alpha, alphaFactor, nDimensions);
            testCase.verifyEqual(alpha, [3, 2, 12], "alpha is not set correctly");
            testCase.verifyEqual(alphaFactor, [], "alphaFactor is not set correctly");
        end
        
        function testAlphaFactor(testCase)
            alpha = [];
            alphaFactor = [1, 12, 0.4];
            nDimensions = 3;
            [alpha, alphaFactor] = setAlpha(alpha, alphaFactor, nDimensions);
            testCase.verifyEqual(alpha, [0, 0, 0], "alpha is not set correctly");
            testCase.verifyEqual(alphaFactor, [1, 12, 0.4], "alphaFactor is not set correctly");
        end
        
        function testAlphaFactorAsScalar(testCase)
            alpha = [];
            alphaFactor = 7;
            nDimensions = 3;
            [alpha, alphaFactor] = setAlpha(alpha, alphaFactor, nDimensions);
            testCase.verifyEqual(alpha, [0, 0, 0], "alpha is not set correctly");
            testCase.verifyEqual(alphaFactor, [7,7,7], "alphaFactor is not set correctly");
        end
        
        function testAlphaFactorAndAlpha(testCase)
            alpha = [3, 12, 3];
            alphaFactor = [7, 7, 7];
            nDimensions = 3;
            [alpha, alphaFactor] = setAlpha(alpha, alphaFactor, nDimensions);
            testCase.verifyEqual(alpha, [3, 12, 3], "alpha is not set correctly");
            testCase.verifyEqual(alphaFactor, [7,7,7], "alphaFactor is not set correctly");
        end
    end
end
