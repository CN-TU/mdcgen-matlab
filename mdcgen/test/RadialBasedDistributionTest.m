classdef RadialBasedDistributionTest < matlab.unittest.TestCase

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
            rng(18);
            this.cluster = 1;
            this.compactness = 0.5;
            this.nPoints = 50000;
            this.userDistributions.binProbability = [0,1];
           this.userDistributions.edges = [0, 0.8, 1];
        end
    end
    
    methods (Test)
        
        %%% R010 %%%
        function testUniformDistribution(this)
            givenNDimensionsIsSetTo(4, this);
            givenDistributionIs(1,this);
            whenRadialBasedDistributionIsCalled(this);
            thenDistributionIsUniform(this);
        end
        
        %%% R010 %%%
        function testNormalDistribution(this)
            givenNDimensionsIsSetTo(4, this);
            givenDistributionIs(2,this);
            whenRadialBasedDistributionIsCalled(this);
            thenDistributionIsNormal(this);
        end
        
        %%% R010 %%%
        function testLogisticDistribution(this)
            givenNDimensionsIsSetTo(4, this);
            givenDistributionIs(3,this);
            whenRadialBasedDistributionIsCalled(this);
            thenDistributionIsLogistic(this);
        end
        
        %%% R010 %%%
        function testTriangularDistribution(this)
            givenNDimensionsIsSetTo(4, this);
            givenDistributionIs(4,this);
            whenRadialBasedDistributionIsCalled(this);
            thenDistributionIsTriangular(this);
        end
        
        %%% R010 %%%
        function testGammaDistribution(this)
            givenNDimensionsIsSetTo(2, this);
            givenDistributionIs(5,this);
            whenRadialBasedDistributionIsCalled(this);
            thenDistributionIsGamma(this);
        end
        
        %%% R010 %%%
        function testRingDistribution(this)
            givenDistributionIs(6,this);
            givenNDimensionsIsSetTo(2, this);
            whenRadialBasedDistributionIsCalled(this);
            thenDistributionIsRing(this);
        end
        
        %%% R011 %%%
        function testUserDistribution(this)
           givenCompactnessIsSetTo(0.9, this);
           givenNDimensionsIsSetTo(2, this);
           givenDistributionIs(7, this);
           whenRadialBasedDistributionIsCalled(this); 
           thenDistributionIsUserDefined(this);
        end

    end
    
    methods
        function givenNDimensionsIsSetTo(nDim, this)
            this.nDimensions = nDim;
        end
        
        function givenCompactnessIsSetTo(com, this)
           this.compactness = com;
        end
        
        function givenDistributionIs(dist, this)
             this.distribution = [dist, dist; dist, dist];
        end
        
        function whenRadialBasedDistributionIsCalled(this)
            this.points = radialBasedDistribution(this.cluster, this.distribution, this.nPoints, this.nDimensions, this.compactness, this.userDistributions);
        end
        
        function thenDistributionIsUniform(this)
            error = [];
            for i = 1 : this.nDimensions
                for j = i : this.nDimensions
                    if i ~=j
                        [ratioInner, ratioOuter] = getCirclePoints(this.compactness, this.points, i, j, this);
                        ratio = abs(ratioInner - ratioOuter);
                        if(ratio > 0.15)
                            error = [error; i, j, ratio];
                        end
                    end
                end
            end
            this.verifyEmpty(error, "No Uniform distribution given for dimensions" );
        end



        function thenDistributionIsNormal(this)
            verifyDistribution(0.642, 0.358, 2 * this.compactness, "Normal", this);
        end
        
        function thenDistributionIsLogistic(this)
            verifyDistribution(0.463, 0.536, 2 * this.compactness, "Logistic", this);
        end
        
        function thenDistributionIsTriangular(this)
            verifyDistribution(0.75, 0.25, this.compactness, "Triangular", this);
        end
        
        function thenDistributionIsGamma(this)
            innerCircle = this.points( insideCircle(0.2, 1, 2, this), : );
            nPointsInner = size(innerCircle, 1);
            ratioEmpty = nPointsInner / this.nPoints;
            this.verifyEqual(ratioEmpty, 0.005,'RelTol', 0.5, "No Gamma distribution given");       
        end
        
        function thenDistributionIsRing(this)
            innerCircle = this.points( insideCircle(0.5, 1, 2, this), : );
            nPointsInner = size(innerCircle, 1);
            ratioEmpty = nPointsInner / this.nPoints;
            this.verifyEqual(ratioEmpty, 0,'RelTol', 0.01, "No Ring distribution given");         
        end
        
        function thenDistributionIsUserDefined(this)          
            pointsCircle = this.points(pointsBetweenCircleRadia(1, 2, this), : );
            nPointsCircle = size(pointsCircle, 1);
            this.verifyEqual(nPointsCircle, this.nPoints, "No User Defined distribution given")
        end

        function [ratioInner, ratioOuter] = getCirclePoints(radius, pts, dimA, dimB, this)
            nPts = size(pts, 1);
            innerCircle = pts( insideCircle(radius, dimA, dimB,  this), : );
            pts( insideCircle(radius, dimA, dimB, this), : ) = [];
            
            nPointsInner = size(innerCircle, 1);
            nPointsOuter = size(pts, 1);
            
            ratioInner = nPointsInner / nPts;
            ratioOuter = nPointsOuter / nPts; 
        end
        
        function indices = pointsBetweenCircleRadia(innerRadius, outerRadius, this)
           indices = [];
           for i = 1 : size(this.points, 1)
               pointRadius = (this.points(i, 1) ^ 2 + this.points(i, 2) ^ 2);
               if (pointRadius > innerRadius^2 && pointRadius < outerRadius^2)
                   indices = [indices; i];
               end
            end
        end
        
        function indices = insideCircle(r, dimA, dimB,  this)
            indices = [];
            for i = 1 : size(this.points, 1)
                if ((this.points(i, dimA) ^ 2 + this.points(i, dimB) ^ 2) < r^2)
                    indices = [indices; i];
                end
            end
        end
        
        function verifyDistribution(innerThreshhold, outerThreshhold, radius, distro, this)
            errorIn = [];
            errorOut = [];
            for i = 1 : this.nDimensions
                for j = i : this.nDimensions
                    if i ~=j
                        [ratioInner, ratioOuter] = getCirclePoints(radius, this.points, i, j, this);
                        
                        if(abs(ratioInner - innerThreshhold) > 0.12)
                            errorIn = [errorIn; i, j, ratioInner];
                        end
                        
                        if(abs(ratioOuter - outerThreshhold) > 0.12)
                            errorOut = [errorOut; i, j, ratioOuter];
                        end
                    end
                end
            end
            this.verifyEmpty(errorIn, "No " + distro + " distribution given for dimensions" );
            this.verifyEmpty(errorOut, "No " + distro + " distribution given for dimensions" );
        end
    end
end

