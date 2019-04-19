%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
% function [nIntersections] = calculateNIntersections(nClusters, nOutliers, dimensions, alphaN)
%
% Description: Calculates the number of intersections per dimension
%
% Inputs:
%   nClusters: the number of clusters
%   nOutliers: the number of outliers
%   dimensions: the number of dimensions
%   alphaN: Vector with length of dimensions holding the alpha values
%
% Outputs:
%   nIntersections: Number of intersections per dimension
%
% Author:     Denis Ojdanic <denis.ojdanic@yahoo.com>
% Supervisor: Félix Iglesias Vázquez <felix.iglesias@nt.tuwien.ac.at>
% Date: 21.02.2019
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
function [nIntersections] = calculateNIntersections(nClusters, nOutliers, dimensions, alpha, alphaFactor)
    
    if nClusters > 1 && nOutliers > 1
        nIntersections = floor( 1 + nClusters / log(nClusters) + nOutliers / log(nOutliers) ); % equation 1 from paper
    elseif nClusters > 1 && nOutliers <= 1
        nIntersections = floor( 1 + nClusters / log(nClusters));
    elseif nClusters <= 1 && nOutliers > 1
        nIntersections = floor( 1 + nOutliers / log(nOutliers));
    else 
        nIntersections = 1 + 2 * (nOutliers >= 1); 
    end

    nIntersections = nIntersections * ones(1, dimensions);
    
    for i = 1 : dimensions
        if alpha(i) > 0  % use alpha as an absolute value
            nIntersections(i) = round(alpha(i));
        else % use alpha as the C constant specified in the paper eq 1
            nIntersections(i) = round(alphaFactor(i) * nIntersections(i));
        end
    end
    positions = cumprod(nIntersections, 'reverse');
    if(positions(1) < (nClusters + nOutliers))
        error('calculateNIntersections:ConfigurationError', "Not enough intersections = %d to place nClusters + nOutliers = %d. Check alpha value.", positions(1), nClusters + nOutliers);
    end
end