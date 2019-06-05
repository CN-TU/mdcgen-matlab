classdef CalculateCorrelationMatrixTest < matlab.unittest.TestCase

    
    methods(TestMethodSetup)
        function setup(testCase)
            addpath(genpath('../src'));
            addpath(genpath('../../extra_tools'));
            rng(18);
        end
    end  
    
    methods (Test)
        function testCalculateCorrelationMatrix_A(testCase)
            if exist('../../extra_tools/nearesSPD.m') == 0
                testCase.assumeTrue(false, "Test skipped. Nearest SPD required for correlation feature and is not istalled." + newline ...
                    + "You can download nearest SPD for free from: https://de.mathworks.com/matlabcentral/fileexchange/42885-nearestspd ");
            end
            nDimensions = 2;
            correlation = [0.674, 0,123];
            clusterNumber = 2;
            [T, p] = calculateCorrelationMatrix(nDimensions, correlation, clusterNumber);
            testCase.verifyEqual(p, 0, "p is not set correctly");
            testCase.verifyEqual(T, [1, 0; 0, 1], "T is not set correctly");
        end
        
        function testCalculateCorrelationMatrix_B(testCase)
            if exist('../../extra_tools/nearestPD.m') == 0
                testCase.assumeTrue(false, "Test skipped. Nearest SPD required for correlation feature and is not istalled." + newline ...
                    + "You can download nearest SPD for free from: https://de.mathworks.com/matlabcentral/fileexchange/42885-nearestspd ");
            end
            nDimensions = 2;
            correlation = [0.674, -0,123];
            clusterNumber = 1;
            [T, p] = calculateCorrelationMatrix(nDimensions, correlation, clusterNumber);
            testCase.verifyEqual(p, 0, "p is not set correctly");
            
            testCase.verifyEqual(T, [1, 0.51; 0, 0.85], 'RelTol', 0.1, "T position is wrong");
        end
    end
end

