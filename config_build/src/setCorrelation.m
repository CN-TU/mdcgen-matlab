%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
%[correlation] = setCorrelation(correlationIn, nClusters)
%
% Description: 
%   The function sets the correlation property
%
% Inputs:
%   correlationIn: As a scalar applied to all clusters, as a vector for each
%                  cluster independently
%   nClusters: the number of the clusters
%
% Outputs:
%   correlation: An initialized array with the length equal to nClusters.
%
% Author:     Denis Ojdanic <denis.ojdanic@yahoo.com>
% Supervisor: Félix Iglesias Vázquez <felix.iglesias@nt.tuwien.ac.at>
% Date: 26.02.2019
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
function [correlation] = setCorrelation(correlationIn, nClusters)
    

    if length(correlationIn) > 1
        if length(correlationIn) ~= nClusters
            error('setCorrelation:ConfigurationError', 'Length of correlation array = %d does not match the number of clusters = %d.', length(correlationIn), nClusters);
        end
        correlation = correlationIn;
    else
        correlation = correlationIn * 2 * ( rand(1, nClusters) - 0.5 );
    end

    if max(correlation) > 1
        error('setCorrelation:ConfigurationError', 'Correlation value = %d is bigger than 1.', max(correlation));
    end

    if min(correlation) < -1
        error('setCorrelation:ConfigurationError', 'Correlation value = %d is smaller than -1.', min(correlation));
    end

end