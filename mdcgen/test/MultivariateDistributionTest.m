classdef MultivariateDistributionTest < matlab.unittest.TestCase

    
    properties
        compactness;
        nPoints;
        cluster;
        nDimensions;
        distribution;
        userDistributions;
        points;
    end
    
    methods(TestMethodSetup)
        function setup(this)
            addpath(genpath('../src'));
            this.cluster = 1;
            this.nPoints = 100000;
            this.nDimensions = 2;
            this.userDistributions.binProbability = 0;
            this.userDistributions.edges = 0;
            rng(18);
        end
    end
    
    methods (Test)
        
        %%% R010 %%%
        function testUniformDistribution(this)
            this.compactness = 1;
            givenDistributionIsSetTo(1, this);
            whenMultivariateDistributionIsCalled(this);
            thenDistributionIsUniform(this);
        end
        
        %%% R010 %%%
        function testNormalDistribution(this)
            this.compactness = 0.1;        
            givenDistributionIsSetTo(2, this);
            whenMultivariateDistributionIsCalled(this);
            thenDistributionIsNormalForDimension(1, this);
            thenDistributionIsNormalForDimension(2, this);
        end
        
        %%% R010 %%%
        function testLogisticDistribution(this)
            this.compactness = 0.1;        
            givenDistributionIsSetTo(3, this);
            whenMultivariateDistributionIsCalled(this);
            thenDistributionIsLogisticForDimension(1, this);
            thenDistributionIsLogisticForDimension(2, this);

        end
        
        %%% R010 %%%
        function testTriangularDistribution(this)
            this.compactness = 1;
            givenDistributionIsSetTo(4, this);          
            whenMultivariateDistributionIsCalled(this);
            thenDistributionIsTriangularForDimension(1, this);
            thenDistributionIsTriangularForDimension(2, this);
        end
        
        %%% R010 %%%
        function testGammaDistribution(this)
            this.nPoints = 10000;
            this.compactness = 1;
            givenDistributionIsSetTo(5, this);
            whenMultivariateDistributionIsCalled(this);
            thenPointsAreInGammaDistribution(this);
        end
        
        %%% R010 %%%
        function testRingDistribution(this)
            this.compactness = 0.1;
            givenDistributionIsSetTo(6, this);
            whenMultivariateDistributionIsCalled(this);
            thenPointsAreInRingDistribution(this);  
        end
        
        %%% R011 %%%
        function testUserDistribution(this)
           this.compactness = 0.9;
           this.userDistributions.binProbability = [1,0];
           this.userDistributions.edges = [0, 0.5, 1];
           givenDistributionIsSetTo(7, this);
           whenMultivariateDistributionIsCalled(this); 
        end
    end
    
    methods
        function givenDistributionIsSetTo(dist, this)
           this.distribution = [dist, dist; dist, dist]; 
        end
        
        function whenMultivariateDistributionIsCalled(this)
            this.points = multivariateDistribution(this.cluster, this.nPoints, this.nDimensions, this.distribution, this.compactness, this.userDistributions);
        end
        
        function thenDistributionIsUniform(this)
            rectangleA = getRect(0.2,0.2, 0.4, 0.4, this);
            rectangleB = this.points(this.points(:,2) < -0.3 & this.points(:,1) < -0.3 & this.points(:,2) > -0.5 & this.points(:,1) > -0.5, :);
            this.verifyEqual(size(rectangleA, 1), size(rectangleB, 1),'absTol', 20, "No Uniform distribution given");              
        end
        

        
        function thenDistributionIsNormalForDimension(dim, this)
            
            [ratioOuter, ratioInner] = extractInnerOuterRatio(dim, this);
            
            % 64 percent of data in between one compactness
            this.verifyEqual(ratioInner, 0.642,'RelTol', .15, "No Normal distribution given");
            this.verifyEqual(ratioOuter, 0.358,'RelTol', .15, "No Normal distribution given");
            
        end
        
        function thenDistributionIsLogisticForDimension(dim, this)
            
            [ratioOuter, ratioInner] = extractInnerOuterRatio(dim, this);
            
            this.verifyEqual(ratioInner, 0.463,'RelTol', .15, "No Logistic distribution given");
            this.verifyEqual(ratioOuter, 0.536,'RelTol', .15, "No Logistic distribution given");
            
        end
        
        function [ratioOuter, ratioInner] = extractInnerOuterRatio(dim, this)
            pointsWithinOnecompactness = this.points(this.points(:,dim) < this.compactness & this.points(:,dim) > -this.compactness, :);
            pointsOutsideFirstcompactness = this.points(this.points(:,dim) > this.compactness | this.points(:,dim) < -this.compactness, :);
            
            nInnerPointes = size(pointsWithinOnecompactness, 1);
            nOuterPointes = size(pointsOutsideFirstcompactness, 1);
            
            ratioOuter = nOuterPointes / this.nPoints;
            ratioInner = nInnerPointes / this.nPoints;
        end
        
        function thenDistributionIsTriangularForDimension(dim, this)
            
            cpHalf = this.compactness / 2;
            
            pointsWithinHalfcompacntess = this.points(this.points(:,dim) < cpHalf & this.points(:,dim) > -cpHalf, :);
            pointsOutsideHalfCompactness = this.points(this.points(:,dim) > cpHalf | this.points(:,dim) < -cpHalf, :);
            
            nInnerPointes = size(pointsWithinHalfcompacntess, 1);
            nOuterPointes = size(pointsOutsideHalfCompactness, 1);
            
            ratioOuter = nOuterPointes / this.nPoints;
            ratioInner = nInnerPointes / this.nPoints;
            
            % 64 percent of data in between one compactness
            this.verifyEqual(ratioInner, 0.75,'RelTol', .1, "No Triangular distribution given");
            this.verifyEqual(ratioOuter, 0.25,'RelTol', .1, "No Triangular distribution given");
            
        end
        
        function thenPointsAreInGammaDistribution(this)
            
            rectLeftDown = getRect(0.5,0.5, 1.5, 1.5, this);
            rectLeftUp = getRect(0.5,2.5, 1.5, 3.5, this);
            rectRightDown = getRect(2.5,0.5, 3.5, 1.5, this);
            rectRightUp = getRect(2.5,2.5, 3.5, 3.5, this);
            
            nRectLeftDown = size(rectLeftDown, 1);
            nRectLeftUp = size(rectLeftUp, 1);
            nRectRightDown = size(rectRightDown, 1);
            nRectRightUp = size(rectRightUp, 1);
            
            this.verifyEqual(nRectLeftUp, nRectRightDown,'absTol', 40, "No Gamma distribution given");
            this.verifyEqual(nRectLeftDown, 3700,'absTol', 20, "No Gamma distribution given");
            this.verifyEqual(nRectRightUp, 0,'absTol', 20, "No Gamma distribution given");
        end
        
        function thenPointsAreInRingDistribution(this)
            
            pointsInTheMiddleHorizontal = this.points(this.points(:,2) < 0.05 & this.points(:,2) > -0.05, :);
            pointsInTheMiddleVertical = this.points(this.points(:,1) < 0.05 & this.points(:,1) > -0.05, :);
            
            this.verifyEmpty(pointsInTheMiddleHorizontal, 'Middle section of Ring distribution is not empty');
            this.verifyEmpty(pointsInTheMiddleVertical, 'Middle section of Ring distribution is not empty');

            leftDown = this.points(this.points(:,2) < 0.05 & this.points(:,1) < -0.05, :);
            rightDown = this.points(this.points(:,2) < 0.05 & this.points(:,1) > -0.05, :);
            rightUp = this.points(this.points(:,2) > 0.05 & this.points(:,1) > -0.05, :);
            leftUp = this.points(this.points(:,2) > 0.05 & this. points(:,1) < -0.05, :);
            
            this.verifyEqual(size(leftDown, 1), size(rightDown, 1),'RelTol', 0.01, "No Ring distribution given");
            this.verifyEqual(size(rightUp, 1), size(leftUp, 1),'RelTol', 0.01, "No Ring distribution given");
            this.verifyEqual(size(leftDown, 1), size(leftUp, 1),'RelTol', 0.01, "No Ring distribution given");
        end
        
        function thenDistributionShouldBeUserDefined(this)
           rectangleA = getRect(0,0, 0.5, 0.5, this);
           rectangleB = getRect(0,0.51, 1, 1, this);
           rectangleC = getRect(0.51,0, 1, 1, this);
           
           this.verifyEqual(size(rectangleA, 1), 100000, "Wrong User defined distribution given"); 
           this.verifyEmpty(rectangleB, 'Wrong User defined distribution giveny');
           this.verifyEmpty(rectangleC, 'Wrong User defined distribution given');
        end
        
        function rect = getRect(x1, y1, x2, y2, this)
            rect = this.points(this.points(:,2) > y1 & this.points(:,1) > x1 & this.points(:,2) < y2 & this.points(:,1) < x2, :);
        end
    end
end



