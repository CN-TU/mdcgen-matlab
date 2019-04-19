%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
% [nAvailableDistributions,indicesAvailableDistributions] = setDistributionFlag(distributionFlag, nUserDistributions)
%
% Description: 
%   The funciton determines which distribution functions are available
%
% Inputs:
%   distributionFlag: As a scalar all distributions are available
%                     cluster independently
%   nUserDistributions: the number of user defined distributions
%
% Outputs:
%   nAvailableDistributions: The number of available distributions
%   indicesAvailableDistributions: array with elements of the distributions 
%                                  that are enabled are set to 1, the 
%                                  disabled distributions to 0
%
% Author:     Denis Ojdanic <denis.ojdanic@yahoo.com>
% Supervisor: Félix Iglesias Vázquez <felix.iglesias@nt.tuwien.ac.at>
% Date: 26.02.2019
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 

function [nAvailableDistributions,indicesAvailableDistributions] = setDistributionFlag(distributionFlag, nUserDistributions)

if length(distributionFlag) > 1
   
   if(distributionFlag(distributionFlag > 1))
       error('setDistributionFlag:ConfigurationError', 'Distribution Flag values may only be 0s and 1s.');
   end
   
   if(distributionFlag(distributionFlag < 0))
       error('setDistributionFlag:ConfigurationError', 'Distribution Flag values may only be 0s and 1s.');
   end
    
   if length(distributionFlag) ~= (6 + nUserDistributions)
        error('setDistributionFlag:ConfigurationError', 'Length of distributionFlag array = %d does not match the number of available distributions = %d.', length(distributionFlag), 6 + nUserDistributions);
   end
else
    distributionFlag = ones(1, 6 + nUserDistributions);
end  

nAvailableDistributions = sum(distributionFlag); 
indicesAvailableDistributions = find(distributionFlag); 

end

