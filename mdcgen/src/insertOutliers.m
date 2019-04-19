%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
% [outliers] = insertOutliers(intersectionIndex, dimensionIndex, nIntersections, nClusters, nOutliers, nDimensions)
%
% Description: This function puts outliers into the solution space
%
% Inputs:
%   intersectionIndex: 
%   dimensionIndex: 
%   nIntersections: the number of intersections per dimension
%   nClusters: the number of clusters
%   nOutliers: the number of outliers
%   nDimensions: the number of dimensions
%   
%
% Outputs:
%   outliers: outlier coordinates in the solution space
%   
%
% Author:     Denis Ojdanic <denis.ojdanic@yahoo.com>
% Supervisor: Félix Iglesias Vázquez <felix.iglesias@nt.tuwien.ac.at>
% Date: 07.03.2019
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
function [outliers] = insertOutliers(intersectionIndex, dimensionIndex, nIntersections, nClusters, nOutliers, nDimensions)

intersectionIndex(1 : nClusters) = [];
    intersectionCount = 1;
    outliers = zeros(nOutliers, nDimensions);
    
    for iOutlier = 1 : nOutliers
        
        res = intersectionIndex(intersectionCount);
        for jDimension = 1 : dimensionIndex
            outliers(iOutlier, jDimension) = mod(res, nIntersections(jDimension)) + 1;
            res = floor(res / nIntersections(jDimension));
            outliers(iOutlier, jDimension) = outliers(iOutlier, jDimension) / (nIntersections(jDimension) + 1);
            %aux(1,j)=(1/(cmax(j)+1))*rand()-(1/(2*(cmax(j)+1)));
            %aux(1,j)=(1/(cmax(j)+1))*normrnd(0,0.01);
            outliers(iOutlier, jDimension) = outliers(iOutlier, jDimension) * (1 + normrnd(0, 0.1));
        end
        if nDimensions > dimensionIndex
            for jDimension = (dimensionIndex + 1) : nDimensions
                 outliers(iOutlier, jDimension) = floor(nIntersections(jDimension) * rand() + 1) / (nIntersections(jDimension) + 1);
                 %aux(1,j)=(1/(cmax(j)+1))*rand()-(1/(2*(cmax(j)+1)));
                 %aux(1,j)=(1/(cmax(j)+1))*normrnd(0,0.01);
                 outliers(iOutlier, jDimension) = outliers(iOutlier, jDimension) * (1 + normrnd(0, 0.1));
            end
        end
       
        intersectionCount = intersectionCount + 1;
        if (intersectionCount > length(intersectionIndex))
            intersectionCount=1;
        end
    end
    
end

