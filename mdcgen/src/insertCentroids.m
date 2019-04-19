%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
% [centroids, intersectionIndex, dimensionIndex] = insertCentroids(nIntersections, dimensions, nClusters, nOutliers, compactness)
%
% Description: This function puts the centroids of the clusters into 
%              solution space
%
% Inputs:
%   nIntersections: the number of intersections per dimension
%   dimensions:     the number of dimensions
%   nClusters:      the number of clusters
%   nOutliers:      the number of outliers
%   compactness:    compactness coefficient for the clusters
%   
%
% Outputs:
%   centroids:          array with the centroid coordinates
%   intersectionIndex:  array of indices of intersections to locate
%                       clustes/outliers
%   dimensionIndex:     index of main dimensions (other dimensions are 
%                       assigned randomly)
%
% Author:     Denis Ojdanic <denis.ojdanic@yahoo.com>
% Supervisor: Félix Iglesias Vázquez <felix.iglesias@nt.tuwien.ac.at>
% Date: 26.02.2019
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
function [centroids, intersectionIndex, dimensionIndex] = insertCentroids(nIntersections, dimensions, nClusters, nOutliers, compactness)

    aux = nIntersections(1); 
    dimensionIndex = 2; 

    for i = dimensionIndex : dimensions
        aux = nIntersections(i) * aux; 
        
        if aux > ( 2 * nClusters + 2 * nOutliers / nClusters)
            dimensionIndex = i;
            break; 
        end
    end

    intersectionIndex = randperm( prod( nIntersections(1 : dimensionIndex) ) ); 

    clusterIntersectionsList = intersectionIndex(1 : nClusters);
    for i = 1 : nClusters
        clusterIntersection = clusterIntersectionsList(i); 
        
        for j = 1 : dimensionIndex    % for loop selecting the first base dimensions
            centroids(i, j) = mod(clusterIntersection, nIntersections(j)) + 1;  
            clusterIntersection = floor(clusterIntersection / nIntersections(j));   
            centroids(i,j) = centroids(i,j) / (nIntersections(j) + 1);
            
            % add random centroid deviation from the intersection
            centroids(i,j) = centroids(i,j) * (1 + normrnd(0, compactness(i)));
        end
        
        % fill the remaining dimensions
        if dimensions > dimensionIndex
            for j = (dimensionIndex + 1) : dimensions
                 centroids(i,j) = floor(nIntersections(j) * rand() + 1) / (nIntersections(j) + 1);
                 centroids(i,j) = centroids(i,j) * (1 + normrnd(0, compactness(i)) );           
            end
        end
    end
end