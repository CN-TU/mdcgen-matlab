classdef MDCGenTest < matlab.unittest.TestCase
   
    
    properties
        params;
        result;
        referenceResult;
    end
    
    methods(TestMethodSetup)
        function setup(this)
            warning off
            addpath(genpath('../src'));
            addpath(genpath('../../config_build/src'));
            this.params = [];
            this.params.nClusters = 2;
            this.params.nOutliers = 1; 
            this.params.nDimensions = 2;
            this.params.nDatapoints = 100;    
            this.params.distribution = 1;
            this.params.multivariate = 1;
        end
    end
    
    methods (Test)
               
        %%% R001 %%%
        function testReproduceDataSet(this)
            givenSeedIsSetTo(18, this);
            givenMDCGenIsCalled(this);
            this.referenceResult = this.result;
            
            givenSeedIsSetTo(18, this);
            whenMDCGenIsCalled(this);
            thenOutputDatasetsAreEqual(this);
        end
        
        %%% R002 %%%
        function testDataSetDimensions(this)
            givenDimensionIsSetTo(100, this);
            whenMDCGenIsCalled(this);
            thenOutputDatasetDimensionShoudBe(100, this);   
        end
        
        %%% R003 %%%
        %%% R017 %%%
        function testNumberDataPoints(this)
            givenNDatapointsIsSetTo(300, this);
            givenNOutliersIsSetTo(0, this);
            whenMDCGenIsCalled(this);
            thenOutputDatasetNPointsShoudBe(300, this);   
        end
     
        %%% R004 %%%
        %%% R019 %%%
        function testNumberOfOutliers(this)
            givenNOutliersIsSetTo(5, this);
            givenNDatapointsIsSetTo(100, this);
            whenMDCGenIsCalled(this);
            thenOutputDatasetNPointsShoudBe(105, this);
            thenNumberOfLabeledOutliersShouldBe(5, this);
        end
           
        %%% R005 %%%
        %%% R018 %%%
        function testNumberOfClusters(this)
            givenNClustersIsSetTo(5, this);
            whenMDCGenIsCalled(this);
            thenNumberOfLabeledClustersShouldBe(5, this);
        end
        
        %%% R006 %%%
        function testClusterMass(this)
            givenNDatapointsIsSetTo(50, this);
            givenNClustersIsSetTo(3, this);
            givenClusterMassIsSetTo([10,20,20], this);
            whenMDCGenIsCalled(this);
            thenClusterMassShouldBe([10, 20, 20], this);       
        end
        
        %%% R008 %%%
        function testNoisyDimensions(this)
            givenNClustersIsSetTo(1, this);
            givenNOutliersIsSetTo(0,this);
            
            givenMDCGenIsCalled(this);
            this.referenceResult = this.result;
            
            givenNoiseIsSetTo(2, this);
            whenMDCGenIsCalled(this);
            thenDimensionShouldBeNoisy(this);
        end
        
        %%% R007 %%%
        function testRotation(this)
            givenNDatapointsIsSetTo(1000, this);
            givenNOutliersIsSetTo(0,this);
            givenNClustersIsSetTo(1, this);

            givenMDCGenIsCalled(this);
            this.referenceResult = this.result;

            givenRotationIsSetTo(1, this)         
            whenMDCGenIsCalled(this);
            thenClusterShouldBeRotated(this);
        end
        
        %%% R014 %%%
        function testClusterOverlap(this)
            this.params.distribution = 1;
            this.params.multivariate = -1;
            this.params.nDatapoints = 1000;
            this.params.compactness = [0.2, 0.25];
             
            whenMDCGenIsCalled(this);
            thenClustersAreOverlapping(this);
        end
        
        %%% R020 %%%
        function testValidityCheck(this)
            this.params.validity.Silhouette=1;
            this.params.validity.Gindices=1;
 
            
            whenMDCGenIsCalled(this);
            thenValidityChecksShouldBeEnabled(this);
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
        
        function givenMDCGenIsCalled(this)
           whenMDCGenIsCalled(this);
        end
        
        function whenMDCGenIsCalled(this)
            this.result = mdcgen(this.params);
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
        
        function thenClustersAreOverlapping(this)
            clusterOverapping = false;
            data = this.result.dataPoints;
            label = this.result.label;

            clusterPoints1 = data(label == 1, :);
            clusterPoints2 = data(label == 2, :);
            
            left1 = min(clusterPoints1(:,1));
            right1 = max(clusterPoints1(:,1));
            left2 = min(clusterPoints2(:,1));
            right2 = max(clusterPoints2(:,1));
            
            if(left2 < left1 && right2 < right1)
                if(right2 > left1)
                    clusterOverapping = true;
                end
            end 
            this.verifyTrue(clusterOverapping, "Clusters are not overlapping");
        end
        
        function thenValidityChecksShouldBeEnabled(this)
            this.verifyEqual(this.result.perf.Silhouette, 0.854, 'RelTol', 0.1, "Silhouette does not match");    
            this.verifyEqual(this.result.perf.Gstr, 3.661, 'RelTol', 0.1, "Gindices does not match");    
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

