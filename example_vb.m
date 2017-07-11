
%-- MDC_GENERATOR v2.0, example of parameterization

fprintf('----------- execute example ------------\n');
fprintf('example_vb;\n');
fprintf('[ r ] = mdcgen( p );\n');
fprintf('scatter3(r.MN(:,1),r.MN(:,2),r.MN(:,3),5,''fill'');\n');
fprintf('axis([0 1 0 1 0 1])\n');
fprintf('---------------------------------------\n');

%-- sd: ramdom seed for reproducibility (scalar)
p.sd = 2016;

%-- M: number of samples (scalar)
p.M = 2000;

%-- N: number of dimensions/features (scalar)
p.N = 3;

%-- k: number of clusters (scalar) 
%--    or cluster masses (array)
p.k=6; % (scalar)
% p.k = [500, 500, 300, 300, 200, 200]; % (array)
%--(array): 'k' must be consistent with 'M', i.e., 'sum(k)=M'

%-- km: minimum cluster mass (scalar)
%-- if not defined by 'k' or 'km', by default: '|k_i| >= M/(coeff*k)'
% p.km = 30;

%-- d: type of distribution (scalar, array, matrix)
p.d = 0; % (scalar) it affects all distributions
% p.d = [0, 1, 2, 4, 5, 6]; % (1xk-array) it affects clusters separately
% p.d = [0, 0, 1, 1, 2, 2; 3, 3, 4, 4, 5, 5; 6, 6, 0, 0, 1, 1]; % (Nxk-matrix) 
%            it affects cluster features separately
%-- d values:
%--   0 - At random
%--   1 - Uniform
%--   2 - Gaussian
%--   3 - Logistic
%--   4 - Triangular
%--   5 - Gamma
%--   6 - Gap or ring-shaped

%-- dflag: available distributions for randomizing (scalar, array);
% p.dflag = 1; % (scalar) it affects all distributions
%-- p.dflag = [0, 1, 1, 0, 0, 0]; % (1x6-array) it enables distributions
%-- independently. '0' disabled, '1' enabled.

% If additional distributions are added as input parameters (i.e., '[ r ] = mdcgen( p, dist );' ),
% the new distributions take indices starting at '7' for the configuration of 'd' and 'dflag' parameters. 
% For example, if 'dist' embeds with 2 distributions ('dist.n=2'), 'dist.d(1)' and 'dist.d(2)' are 
% respectivelygets linked to indices '7' and '8' for the configuration of 'd' and 'dflag'



%--  mv: multivariate distributions or distributions defining
%--  intra-distances (scalar, array)
p.mv = 0; % (scalar)
%p.mv = [0, 1, -1, 0, 1, -1]; % (1xk-array)
%-- mv values:
%--    0 - At random
%--    1 - distributions define feature values (multivariate)
%--    -1 - distributions define intra-distances

%-- corr: maximum (modulus) correlation between variables (scalar, array)
% p.corr = 0.1; % (scalar)
% p.corr = [0.9, 0.2, 1, 0.4, 0.5, 1]; % (1xk-array)

%-- cp: compactness factor (scalar, array)
%-- 'cp' determines variance cofficients of distributions
% p.cp = 0.1; % (scalar)
% p.cp= [0.1, 0.08, 0.11, 0.05, 0.1, 0.09]; (1xk-array)

%-- alphaN: determines grid hyperplanes (scalar, array)
%-- alphaN values:
%--         '>0' factor of 'floor(1+k/log(k))' 
%--         '<0' absolute value (modulus)
% p.alphaN = 2; % (scalar)
% p.alphaN = [1, 2, 0.5]; (1xN array)

%-- scale: optimizes cluster separation based on grid size (scalar, array)
%-- scale values:
%--         '0' no scale 
%--         '>0' scale based on min distance between grid hyperplanes' 
%--         '<0' scale based on max distance between grid hyperplanes' 
p.scale = 1;
% p.scale = [1, 1, 1, -1, 1, 1]; % (1xk-array)

%-- out: number of outliers (scalar)
p.out = 50;

%-- rot: cluster rotation (scalar, array)
% p.rot = 0; 
% p.rot = [0, 1, 0, 1, 0, 1]; % (1xk-array)

%-- Nnoise: number of noisy dimensions (scalar, array, matrix)
% p.Nnoise=1;
% p.Nnoise = [2, 4]; % (array) values state which dimensions must be noisy 
% p.Nnoise= [0, 0, 1, 2, 0, 3; 1, 0, 2, 0, 0, 0]; % (matrix) k columns, (i,j)-values
% state which dimensions mus be noisy for the j-cluster

%-- validity: type of validity performance (to check generated overlap)
p.validity.Silhouette=1;
p.validity.Gindices=1;

% ----------- outputs ----------- 
% result.
%   MN: output matrix
%   label: array with labels
%   perf: performance 
%       perf.Silhouette: global Silhouette index
%       perf.Gstr: strict global overlap index
%       perf.Grex: relaxed global overlap index
%       perf.Gmin: minimum global overlap index
%       perf.oi_st: strict individual overlap index (cluster)
%       perf.oi_rx: relaxed individual overlap index (cluster)
%       perf.oi_mn: minimum individual overlap index (cluster)

