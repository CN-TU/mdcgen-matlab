classdef ManualMDCGenTest < matlab.unittest.TestCase
   
    
    properties
        params;
        config;
        result;
        referenceResult;
    end
    
    methods(TestMethodSetup)
        function setup(this)
            warning off
            addpath(genpath('../mdcgen/src'));
            addpath(genpath('../config_build/src'));
            addpath(genpath('../extra_tools'));
            this.params = [];
            this.params.nClusters = 2;
            this.params.nOutliers = 1; 
            this.params.nDimensions = 2;
            this.params.nDatapoints = 1000;    
            this.params.distribution = 1;
            this.params.multivariate = 1;
        end
    end
    
    methods (Test)
        
        %%% R009 %%%
        function testCorrelation(this)
            givenNOutliersIsSetTo(0,this);
            givenNClustersIsSetTo(1, this);
            
            givenMDCGenConfigIsCreated(this);
            givenMDCGenIsCalled(this);
            this.referenceResult = this.result;
            
            figure('Name', 'testCorrelation', 'NumberTitle', 'off');
            hold on
            scatter(this.referenceResult.dataPoints(:,1),this.referenceResult.dataPoints(:,2),10,'fill', 'b');

            givenCorrelatonIsSetTo(1.3, this);
            givenMDCGenConfigIsCreated(this);
            whenMDCGenIsCalled(this);
            
            % The figure should show a reference square in blue and a
            % diagonal square in green. The green square is the dataset
            % with correlation applied.
            scatter(this.result.dataPoints(:,1),this.result.dataPoints(:,2),10,'fill', 'g');
            axis([0 1 0 1])
        end
        
        %%% R012 %%%
        function testMultivariateOrRadialDistribution(this)
            givenNOutliersIsSetTo(0,this);
            givenNClustersIsSetTo(2, this);
            this.params.multivariate = [1, -1];
 
            givenMDCGenConfigIsCreated(this);
            whenMDCGenIsCalled(this);
            
            % The figure should show two clusters, one cluster as a circle
            % (radial shaped) and one cluster asa square (multivariate)
           
            figure('Name', 'testMultivariateOrRadialDistribution', 'NumberTitle', 'off');
            scatter(this.result.dataPoints(:,1),this.result.dataPoints(:,2),10,'fill', 'b');
            axis([0 1 0 1])
        end
        
        %%% R013 %%%
        function testRandomDistributionFunction(this)
            givenNOutliersIsSetTo(0,this);
            givenNClustersIsSetTo(6, this);
            this.params.distribution = 0;
            this.params.multivariate = 0;
 
            givenMDCGenConfigIsCreated(this);
            whenMDCGenIsCalled(this);
            
            % The figure should show different 6 clusters with different
            % shapes (distribution functions)
            figure('Name', 'testRandomDistributionFunction', 'NumberTitle', 'off');
            scatter(this.result.dataPoints(:,1),this.result.dataPoints(:,2),10,'fill', 'b');
            axis([0 1 0 1])
        end
        
        %%% R015 %%%
        function testSubspaceClusterOverlapIndependentInOverall(this)
            this.params.distribution = 1;
            this.params.multivariate = -1;
            this.params.nDimensions = 3;
            this.params.nDatapoints = 1000;
            this.params.compactness = [0.2, 0.25];
 
 
            givenMDCGenConfigIsCreated(this);
            whenMDCGenIsCalled(this);
            
            % The figure representing a 2D space should show overlapping
            % clusters and the figure representing the 3D space or the 
            % overall space should show clusters that are not overlapping
           
            figure('Name', 'testSubspaceClusterOverlap', 'NumberTitle', 'off');
            scatter(subplot(2,2,1),this.result.dataPoints(:,1),this.result.dataPoints(:,2),5,'fill');
            scatter3(subplot(2,2,2),this.result.dataPoints(:,1),this.result.dataPoints(:,2), this.result.dataPoints(:,3),5,'fill');
            axis([0 1 0 1 0 1])
        end
        
        %%% R016 %%%
        function testSubspaceClusterIndependentOverlapInOverallSpace(this)
            this.params.distribution = 1;
            this.params.multivariate = -1;
            this.params.nDimensions = 3;
            this.params.nDatapoints = 1000;
            this.params.compactness = [0.03, 0.2];
            this.params.nNoise = 1;

 
 
            givenMDCGenConfigIsCreated(this);
            whenMDCGenIsCalled(this);
            
            % The figure representing a 2D space should show two clusters.
            % When considering the 3D space the the clusters appear noisy.
            % clusters and the figure representing the 3D space or the 
            % overall space should show clusters that are not overlapping
           
            figure('Name', 'testSubspaceClusterIndependentOverlapInOverallSpace', 'NumberTitle', 'off');
            scatter(subplot(2,2,1),this.result.dataPoints(:,1),this.result.dataPoints(:,2),5,'fill');
            scatter3(subplot(2,2,2),this.result.dataPoints(:,1),this.result.dataPoints(:,2), this.result.dataPoints(:,3),5,'fill');
            axis([0 1 0 1 0 1])
        end

    end
    
    methods
        function givenRotationIsSetTo(rot, this)
           this.params.rotation = rot; 
        end
        
        function givenNoiseIsSetTo(noise, this)
            this.params.nNoise = noise;
        end
        
        function givenCorrelatonIsSetTo(cor, this)
            this.params.correlation = cor;
        end
        
        function givenClusterMassIsSetTo(mass, this)
            this.params.clusterMass = mass;
        end
        function givenSeedIsSetTo(seed, this)
            this.params.seed = seed;
        end
        
        function givenNOutliersIsSetTo(nOut, this)
            this.params.nOutliers = nOut;
        end
        
        function givenNClustersIsSetTo(nClu, this)
            this.params.nClusters = nClu;
        end
        
        function givenNDatapointsIsSetTo(nPoints, this)
            this.params.nDatapoints = nPoints;
        end
        
        function givenDimensionIsSetTo(nDim, this)
            this.params.nDimensions = nDim;
        end
        function givenMDCGenConfigIsCreated(this)
            this.config = createMDCGenConfiguration(this.params);
        end
        
        function givenMDCGenIsCalled(this)
           whenMDCGenIsCalled(this);
        end
        
        function whenMDCGenIsCalled(this)
            this.result = mdcgen(this.config);
        end
        
        function thenOutputDatasetNPointsShoudBe(nPoints, this)
            this.verifyEqual(size(this.result.dataPoints, 1), nPoints, "Output dataset number of points not set correctly"); 
        end
        
        function thenOutputDatasetDimensionShoudBe(nDim, this)
            this.verifyEqual(size(this.result.dataPoints, 2), nDim, "Output dataset dimensions not set correctly"); 
        end
        
        function thenOutputDatasetsAreEqual(this)
            this.verifyEqual(this.result.dataPoints, this.referenceResult.dataPoints, "Output dataset dataPoints do not match");
            this.verifyEqual(this.result.label, this.referenceResult.label, "Output dataset labels do not match");
        end
        
        function thenNumberOfLabeledOutliersShouldBe(nOut, this)
            this.verifyEqual(length(this.result.label(this.result.label == 0)), nOut, "Output dataset number of labeled outliers does not match");
        end
        
        function thenNumberOfLabeledClustersShouldBe(nClu, this)
            labels = unique(this.result.label);
            labels(labels == 0) = [];
            numberClusters = length(labels);
            this.verifyEqual(numberClusters, nClu, "Output dataset number of labeled clusters does not match");
        end
        
        function thenClusterMassShouldBe(exectedClusterMass, this)
            
            clusterPoints = [];
            for i = 1 : this.params.nClusters
                clusterPoints = [clusterPoints, getClusterMass(i, this)];
            end
            
            this.verifyEqual(clusterPoints, exectedClusterMass, "Output dataset number of labeled clusters does not match");     
        end
        
        function thenDimensionShouldBeNoisy(this)
             this.verifyTrue(verifyClusterIsBigger(this), "Data not noisy");
        end
        
        function thenClusterShouldBeRotated(this)
            this.verifyTrue(verifyClusterIsBigger(this), "Data not rotated");
        end
        
        function thenClusterShouldBeCorrelated(this)
            this.verifyTrue(verifyClusterIsBigger(this), "Data not correlated");
        end
        
        function result = verifyClusterIsBigger(this)
            result = false;
            data = this.result.dataPoints;
            refData = this.referenceResult.dataPoints;
            
            if( min(data(:, 1)) < min(refData(:, 1)) && min(data(:, 2)) < min(refData(:, 2)) && max(data(:, 1)) > max(refData(:, 1)) && max(data(:, 2))> max(refData(:, 2)))
                result = true;
            end
        end
      
        function clusterPoints = getClusterMass(clusterLabel, this)
            clusterMass = this.result.label(this.result.label == clusterLabel);
            clusterPoints = length(clusterMass);
        end
    end
end

