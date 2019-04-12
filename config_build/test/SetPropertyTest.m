classdef SetPropertyTest < matlab.unittest.TestCase

    methods(TestMethodSetup)
        function setup(testCase)
            addpath(genpath('../src'));
        end
    end
    
    methods (Test)
        function testPropertyIsSetForEveryValue(testCase)
            propertyIn = 0.7;
            value = 3;
            property = setProperty(propertyIn, "property", value, "value");
            testCase.verifyEqual(property, [0.7, 0.7, 0.7], "Property is not set correctly");
        end
        
        function testPropertyIsSetPerValue(testCase)
            propertyIn = [4, 2, 4];
            value = 3;
            property = setProperty(propertyIn, "property", value, "value");
            testCase.verifyEqual(property, [4, 2, 4], "Property is not set correctly");
        end
        
        function testErrorThrownOnWrongNumberOfProperties(testCase)
            testCase.verifyError(@()setProperty([1, 3],"property", 3, "value"),'setProperty:ConfigurationError');       
        end
    end
end
