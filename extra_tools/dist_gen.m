function [ dist ] = dist_gen( seed, n, scale_factor, multimodes, skewf )
%DIST_GEN generates empirical distributions
%in a format compatible with MDCgen

%------------------------------------------------------------------------------------------------------
% DIST_GEN v1.0 (Jun 2017)
% Author: Félix Iglesias <felix.iglesias.vazquez@nt.tuwien.ac.at>
% License: GPLv3 (2017)
%
% Copyright (C) 2017  Félix Iglesias, TU Wien
%
% This program is free software: you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation, either version 3 of the License, or
% (at your option) any later version.
%
% This program is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details.
%
% You should have received a copy of the GNU General Public License
% along with this program.  If not, see <http://www.gnu.org/licenses/>.
%------------------------------------------------------------------------------------------------------

%
% -------- inputs -------------
% seed: random seed
% n: number of distributions
% scale_factor: size of the distribution regards the whole space
% multimodes: max. number of multimodes
% skewf: skewness factor
% -------- outputs -------------
% dist.n: number of distributions
% dist.d(i).edges: histogram edges
% dist.d(i).edges: histogram values

if exist('seed')==0, seed=1;end
if exist('n')==0, n=1;end
if exist('scale_factor')==0, scale_factor=1;end
if exist('multimodes')==0, multimodes=1;end
if exist('skewf')==0, skewf=0;end

if length(skewf)>1
   if length(skewf)~=n, error('Wrong [skewness] length. It must be a scalar or a n-array.');end
else
   skewf=skewf*ones(1,n); 
end

if length(multimodes)>1
   if length(multimodes)~=n, error('Wrong [multimodes] length. It must be a scalar or a n-array.');end
else
   multimodes=multimodes*ones(1,n); 
end

if length(scale_factor)>1
   if length(scale_factor)~=n, error('Wrong [scale_factor] length. It must be a scalar or a n-array.');end
else
   scale_factor=scale_factor*ones(1,n); 
end


rng(seed);

for i=1:n
    elements=multimodes(i)*round(1000*rand(1,multimodes(i)))+100;
    loc_mode=1000*(rand(1,multimodes(i))-0.5);
    width_mode=100*rand(1,multimodes(i));
    x=[];aux=[];
    for j=1:multimodes(i)
        x=[x;loc_mode(j)+width_mode(j)*randn(elements(j),1)];
        aux=[width_mode(j)*randn(elements(j),1)*(1+abs(skewf(i)))];
        if (skewf(i)>0)
            aux=aux(aux>0);
            aux= loc_mode(j)+aux;
        elseif (skewf(i)<0)
            aux=aux(aux<0);
            aux= loc_mode(j)+aux;
        else
            aux=[];
        end
        x=[x;aux];
    end
    [values,edges] = histcounts(x,'Normalization', 'probability');
    edges=edges-edges(floor(end/2));
    edges=edges/edges(end);    
    
    xc=[];
    for j=1:length(edges)-1
        xc(j)=edges(j)+(edges(j+1)-edges(j))/2;
    end
    
    figure(i);
    bar(xc,values);

    dist.d(i).values=values;
    dist.d(i).edges=edges;
end
dist.n=n;
end

