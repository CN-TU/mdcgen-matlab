classdef SetNoiseTest < matlab.unittest.TestCase

    methods(TestMethodSetup)
        function setup(testCase)
            addpath(genpath('../src'));
            rng(5);
        end
    end
    
    methods (Test)
        
        function testNoiseAsScalar_A(testCase)
            nNoise = 2;
            dimensions = 4;
            nClusters = 2;
            [noise, noiseType] = setNoise(nNoise, dimensions, nClusters);
            testCase.verifyEqual(noise, [4, 3], "Noise is not set correctly");
            testCase.verifyTrue(strcmp(noiseType, 'array'), "NoiseType is not set correctly");
        end
        
        function testNoiseAsScalar_B(testCase)
            nNoise = 4;
            dimensions = 4;
            nClusters = 2;
            [noise, noiseType] = setNoise(nNoise, dimensions, nClusters);
            testCase.verifyEqual(noise, [4, 3, 2, 1], "Noise is not set correctly");
            testCase.verifyTrue(strcmp(noiseType, 'array'), "NoiseType is not set correctly");
        end
        
        function testNoiseAsScalarThrowsErrorWhenNNoiseLargerThenDimensions(testCase)
            nNoise = 4;
            dimensions = 3;
            nClusters = 2;
            testCase.verifyError(@()setNoise(nNoise, dimensions, nClusters),'setNoise:ConfigurationError');
        end
        
        function testNoiseAsArray(testCase)
            nNoise = [2, 1];
            dimensions = 2;
            nClusters = 2;
            [noise, noiseType] = setNoise(nNoise, dimensions, nClusters);
            testCase.verifyEqual(noise, [2, 1], "Noise is not set correctly");
            testCase.verifyTrue(strcmp(noiseType, 'array'), "NoiseType is not set correctly");
        end
        
        function testNoiseAsArrayExeedsDimensions(testCase)
            nNoise = [2, 3];
            dimensions = 2;
            nClusters = 2;
            testCase.verifyError(@()setNoise(nNoise, dimensions, nClusters),'setNoise:ConfigurationError');
        end
        
        function testNoiseAsMatrix(testCase)
            nNoise = [2, 1; 1, 0];
            dimensions = 2;
            nClusters = 2;
            [noise, noiseType] = setNoise(nNoise, dimensions, nClusters);
            testCase.verifyEqual(noise, [2, 1; 1, 0], "Noise is not set correctly");
            testCase.verifyTrue(strcmp(noiseType, 'matrix'), "NoiseType is not set correctly");
        end
        
        function testNoiseAsMatrixExeedsDimensions(testCase)
            nNoise = [2, 3; 1, 1];
            dimensions = 2;
            nClusters = 2;
            testCase.verifyError(@()setNoise(nNoise, dimensions, nClusters),'setNoise:ConfigurationError');
        end
        
        function testErrorThrownOnWrongNoiseArraySize(testCase)
            testCase.verifyError(@()setNoise([1, 3, 3], 2, 2),'setNoise:ConfigurationError');
        end

              
        function testErrorThrownOnWrongNoiseMatrixSize(testCase)
            testCase.verifyError(@()setNoise([2, 3; 4, 4; 3, 4], 2, 2),'setNoise:ConfigurationError');
        end
    end
end

