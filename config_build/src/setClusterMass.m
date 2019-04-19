%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
% [pointsPerCluster, nClusters] = setClusterMass(nClusters, minimumClusterMass, nDatapoints)
%
% Description: 
%   The function sets the cluster masses depending on the configuration.
%
% Inputs:
%   nClusters: As a single scalar it specifies the number of clusters. As
%              an array each array entry specifies the number of datapoints 
%              per cluster. The length of the array indicates the number of 
%              clusters.
%   minimumClusterMass: minimum number of datapoints per cluster  
%   nDatapoints: number of datapoints
%
% Outputs:
%   pointsPerCluster: Array where each entry represents an cluster and the 
%                     the value the number of datapoints per cluster          
%
% Author:     Denis Ojdanic <denis.ojdanic@yahoo.com>
% Supervisor: Félix Iglesias Vázquez <felix.iglesias@nt.tuwien.ac.at>
% Date: 20.02.2019
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
function [pointsPerCluster] = setClusterMass(nClusters, clusterMass, minimumClusterMass, nDatapoints)

CLUSTER_MASS_COEFFICIENT = 3;

if (nClusters <= 0)
       error('setClusterMass:ConfigurationError', 'nClusters = %d has to be a positive non zero integer.', nClusters);
end

clusterMassLength = length(clusterMass);
if ( clusterMassLength > 1 ) % if datapoints per cluster specified
   
   if (clusterMassLength ~= nClusters)
       error('setClusterMass:ConfigurationError', 'ClusterMass length= %d does not match nClusters = %d.', clusterMassLength, nClusters);
   end
    
   if ( sum(clusterMass) == nDatapoints )
       pointsPerCluster = clusterMass; 
   else
       error('setClusterMass:ConfigurationError', 'Sum of clusterMass datapoints = %d does not match total number of datapoints = %d.', sum(clusterMass), nDatapoints);
   end
else
    % -------------- Generating cluster masses (points per cluster)
    datapointsPerClusterInProcent = rand(1, nClusters);
    totalMass = sum(datapointsPerClusterInProcent);
    
    pointsPerCluster = floor(nDatapoints * datapointsPerClusterInProcent / totalMass);
    
    sumPointsInClusters = sum(pointsPerCluster);
    if sumPointsInClusters < nDatapoints
        [~, indexMin] = min(pointsPerCluster);
        pointsPerCluster(indexMin) = pointsPerCluster(indexMin) + (nDatapoints - sumPointsInClusters);
    end
    % -------------- Guarantee '|k_i| >= M/(coeff*k)'
    if minimumClusterMass <= (nDatapoints / nClusters)
        if minimumClusterMass == 0
            per = 1 / (CLUSTER_MASS_COEFFICIENT * nClusters);
            minPointsPerCluster = round(per * nDatapoints);
        else
            minPointsPerCluster = minimumClusterMass;
        end
    else
        error('setClusterMass:ConfigurationError', 'minimumClusterMass = %d for nClusters = %d exceeds maximim number of datapoints = %d.', minimumClusterMass, nClusters, nDatapoints);
    end
    
    [smallestCluster, indexMin] = min(pointsPerCluster);

    while (smallestCluster < minPointsPerCluster)
        missingPoints =  minPointsPerCluster - pointsPerCluster(indexMin) ;
        pointsPerCluster(indexMin) = minPointsPerCluster;
        
        while(missingPoints > 0)
            
            [~, indexMax] = max(pointsPerCluster);
            remainingPoints = pointsPerCluster(indexMax) - missingPoints;
            if (remainingPoints > minPointsPerCluster)
                pointsPerCluster(indexMax) = remainingPoints;
                missingPoints = 0;
            else
                pointsToGive = pointsPerCluster(indexMax) - minPointsPerCluster;
                pointsPerCluster(indexMax) = pointsPerCluster(indexMax) - pointsToGive; 
                missingPoints = missingPoints - pointsToGive;
            end
        end
        [smallestCluster, indexMin] = min(pointsPerCluster);
    end
end