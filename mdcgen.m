function [ r ] = mdcgen( p, dtb )
% MDC_GENERATOR generates synthetic n-dimensional datasets for clustering

%------------------------------------------------------------------------------------------------------
% MDC_GENERATOR v2.0 (May 2017)
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

% ----------- inputs ------------ 
% p.
%   sd: seed for the generation of random values
%   M: number of samples
%   N: number of dimensions/features
%   k: number of clusters
%   km: minimum cluster mass
%   d: type of distribution
%   dflag: available distributions for randomizing
%   mv: multivariate distributions or distributions defining
%       intra-distances
%   corr: correlated variables (degree)
%   cp: compactness factor (relative to the total space [0,...,1])
%   alphaN: determines grid separation as a factor (positive) or an
%           absolute value (negative)
%   scale: optimizes cluster separation based on grid size
%   rot: cluster rotation
%   out: number of outliers
%   Nnoise: noisy dimensions.
%   validity: type of validity indices 'all', 'Silhouette', 'G-indices'
%
% dtb. 
%   n: number of additional distributions
%   d(i).values: probability dist. function values
%   d(i).edges: probability dist. function bin edges

% ----------- outputs ----------- 
% r.
%   MN: output matrix
%   label: array with labels
%   perf: performance

% -------------- Checking existence of input arguments
if exist('p')==0, p=[];end
if isfield(p,'sd')==0, p.sd= 1; end
if isfield(p,'M')==0, p.M= 2000;end
if isfield(p,'N')==0, p.N= 2;end
if isfield(p,'k')==0, p.k= 5;end
if isfield(p,'km')==0, p.km= 0;end
if isfield(p,'d')==0, p.d= 0;end
if isfield(p,'dflag')==0, p.dflag= 1;end
if isfield(p,'mv')==0, p.mv= 0;end
if isfield(p,'corr')==0, p.corr= 0;end
if isfield(p,'cp')==0, p.cp= 0.1;end
if isfield(p,'alphaN')==0, p.alphaN= 1;end
if isfield(p,'scale')==0, p.scale= 1;end
if isfield(p,'out')==0, p.out= 50;end
if isfield(p,'rot')==0, p.rot= 0;end
if isfield(p,'Nnoise')==0, p.Nnoise= 0;end
if isfield(p,'validity')==0 
    p.validity.Silhouette=0;
    p.validity.Gindices=0;
end
if isfield(p.validity,'Silhouette')==0,  p.validity.Silhouette=0;end
if isfield(p.validity,'Gindices')==0, p.validity.Gindices=0; end 
if exist('dtb')==0, dtb=[];end
if isfield(dtb,'n')==0, dtb.n= 0;end


sd=p.sd;
M=p.M;
N=p.N;
k=p.k;
kmin=p.km;
d=p.d;
dflag=p.dflag;
mv=p.mv;
corr=p.corr;
cp=p.cp;
alphaN=p.alphaN;
scale=p.scale;
out=p.out;
rot=p.rot;
Nnoise=p.Nnoise;
kicoeff=3;

addpath(genpath('extra_tools'))
% -------------- Checking code from third parties
if (sum(corr)>0 && exist('nearestSPD')==0)
    error('"nearestSPD" is required to implement feature correlations. Download it for free from: https://de.mathworks.com/matlabcentral/fileexchange/42885-nearestspd');
end

% -------------- Establishing random seed
rng(sd);

% -------------- Checking consistency and normalizing 'k' and '|k_i|'
if length(k)>1
   if sum(k)~=M, error('Variable mismatch error');
   else, mass=k; k=length(k); end
else
    % -------------- Generating cluster masses
    mass=rand(1,k);
    tot_mass=sum(mass);
    mass=floor(M*mass/tot_mass);
    [vx indx]=max(mass);
    [vn indn]=min(mass);
    if sum(mass)<M
        mass(indn)=mass(indn)+(M-sum(mass));
    end
    % -------------- Guarantee '|k_i| >= M/(coeff*k)'
    if kmin==0
        per=1/(kicoeff*k);
        min_mass=round(per*M);
    else
        min_mass=kmin;
    end
    empty_clust=1;
    while empty_clust
        empty_clust=0;
        [vx indx]=max(mass);
        [vn indn]=min(mass);
        if vn<min_mass
            mass(indn)=mass(indn)+min_mass;
            mass(indx)=mass(indx)-min_mass;
            empty_clust=1;
        end
    end
end

% -------------- Checking consistency and normalizing 'd'
[m,n]=size(d);
if m==1 && n>1 % 'd' is an array
   if length(d)~=k, error('Variable mismatch error'); end
   d = bsxfun(@times, d,ones(N,k));
elseif m==1 && n==1 % 'd' is a scalar
    d=d*ones(N,k);
elseif m~=N || n~=k, error('Variable mismatch error');  % 'd' is a matrix
end    

% -------------- Checking consistency and normalizing 'mv'
if length(mv)>1
   if length(mv)~=k, error('Variable mismatch error'); end
else
    mv=mv*ones(1,k);
end  

% -------------- Checking consistency and normalizing 'dflag'
if length(dflag)>1
   if length(dflag)~=(6+dtb.n), error('Variable mismatch error'); end
else
    dflag=dflag*ones(1,6+dtb.n);
end  
rddist=sum(dflag); % Number of available distributions when 'd=0'
inddist=find(dflag); % Indices of the available distributions when 'd=0'

% -------------- Checking consistency and normalizing 'scale'
if length(scale)>1
   if length(scale)~=k, error('Variable mismatch error'); end
else
    scale=scale*ones(1,k);
end  

% -------------- Checking consistency and normalizing 'corr'
if length(corr)>1
   if length(corr)~=k, error('Variable mismatch error'); end
else
    corr=corr*2*(rand(1,k)-0.5);
end    
if max(corr)>1,  error('Variable mismatch error'); end
if min(corr)<-1,  error('Variable mismatch error'); end

% -------------- Checking consistency and normalizing 'alphaN'
if length(alphaN)>1
   if length(alphaN)~=N, error('Variable mismatch error'); end
else
    alphaN=alphaN*ones(1,N);
end  

% -------------- Setting 'cmax'
if k>1, cmax=floor(1+k/log(k)); else, cmax=1+2*(out>1); end
cmax=cmax*ones(1,N);
for i=1:N
    if alphaN(i)<0, cmax(i)=round(alphaN(i)*-1);
    else, cmax(i)=round(alphaN(i)*cmax(i));
    end
end

% -------------- Checking consistency and normalizing 'cp'
if length(cp)>1
   if length(cp)~=k, error('Variable mismatch error'); end
else
    cp=cp*ones(1,k);
end  
for i=1:k
    %if cp(i)<0, cp(i)=-1*cp(i);end
    if scale(i)>0, cp(i)=cp(i)/max(cmax);
    elseif scale(i)<0, cp(i)=cp(i)/min(cmax); end
end

% -------------- Checking consistency and normalizing 'rot'
if length(rot)>1
   if length(rot)~=k, error('Variable mismatch error'); end
else
    rot=rot*ones(1,k);
end

% -------------- Checking consistency and normalizing 'Nnoise'
[m,n]=size(Nnoise);
Nysc=0; Nyar=0; Nymx=0;
if m==1 && n>1 % 'd' is an array
   if length(Nnoise)>N, error('Variable mismatch error'); end
   Nyar=Nnoise; Nnoise=2;
elseif m==1 && n==1 % 'd' is a scalar
    Nysc=Nnoise; Nnoise=1;
elseif m>N || n~=k, error('Variable mismatch error');  % 'd' is a matrix
else % 'd' is a matrix
    Nymx=Nnoise; Nnoise=3;
end    

%Locating centroids in the hyper-space
aux=cmax(1);
ind=2;
for i=ind:N
    aux=cmax(i)*aux;
    if aux>(2*k+2*out/k)
        ind=i; break; 
    end
end

locis=randperm(prod(cmax(1:ind)));

clin=locis(1:k);
for i=1:k
    res=clin(i);
    for j=1:ind
        c(i,j)=mod(res,cmax(j))+1;
        res=floor(res/cmax(j));   
        c(i,j)=c(i,j)/(cmax(j)+1);
        %c(i,j)=c(i,j)+(rand()-0.5);%*cp(i);
        c(i,j)=c(i,j)*(1+normrnd(0,cp(i)));%*cp(i);
    end
    if N>ind
        for j=(ind+1):N
             c(i,j)=floor(cmax(j)*rand()+1)/(cmax(j)+1);
             %c(i,j)=c(i,j)+(rand()-0.5);%*cp(i);
             c(i,j)=c(i,j)*(1+normrnd(0,cp(i)));%*cp(i);             
        end
    end
end


MN=[];label=[];
cl=1; % cl:class
for i=1:k
    if mv(i)==0, mv(i)=sign(rand()-0.5);end
    if mv(i)==1
        Ni=zeros(mass(i),N);
        for j=1:N
            if d(j,i)==0, d(j,i)=inddist(1+floor(rddist*rand())); end
            switch d(j,i)
                case 1, pd = makedist('Uniform','Lower',-cp(i),'Upper',cp(i)); %Uniform
                case 2, pd = makedist('Normal','mu',0,'sigma',cp(i)); %Normal
                case 3, pd = makedist('Logistic','mu',0,'sigma',cp(i)); %Logistic
                case 4, pd = makedist('Triangular','a',-cp(i),'b',0,'c',cp(i)); %Triangular
                case 5, pd = makedist('Gamma','a',2+8*rand(),'b',cp(i)/5); %Gamma
                case 6, pd = makedist('Normal','mu',0,'sigma',cp(i)); %Rings
                otherwise, Ni(:,j) = make_own_dist(d(j,i)-6, dtb, cp(i),mass(i));
            end
            if d(j,i)<6
                Ni(:,j) = random(pd,mass(i),1);
            elseif d(j,i)==6
                Npi = random(pd,2*mass(i),1); 
                a25=quantile(Npi,0.251);
                a75=quantile(Npi,0.749);
                aux=Npi(Npi<a25 | Npi>a75)';
                aux=aux(1:mass(i));
                Ni(:,j)=aux; 
            end
        end
    else %mv(i)==-1
        if d(1,i)==0, d(:,i)=inddist(1+floor(rddist*rand())); end
        if d(1,i)==6, Nix=rand(2*mass(i),N)-0.5;
        else, Nix=rand(mass(i),N)-0.5; end
        Nix = sqrt(N)*bsxfun(@rdivide, Nix, rms(Nix')');  
        switch d(1,i)
            case 1
                pd = makedist('Uniform','Lower',-cp(i),'Upper',cp(i)); %Uniform
                Ni = random(pd,mass(i),1);
                Ni = bsxfun(@times, Nix, Ni);
            case 2
                pd = makedist('Normal','mu',0,'sigma',cp(i)); %Normal
                Ni = random(pd,mass(i),1);
                Ni = bsxfun(@times, Nix, Ni);
            case 3
                pd = makedist('Logistic','mu',0,'sigma',cp(i)); %Logistic
                Ni = random(pd,mass(i),1);
                Ni = bsxfun(@times, Nix, Ni);
            case 4
                pd = makedist('Triangular','a',-cp(i),'b',0,'c',cp(i)); %Triangular
                Ni = random(pd,mass(i),1);
                Ni = bsxfun(@times, Nix, Ni);
            case 5
                pd = makedist('Gamma','a',2+8*rand(),'b',cp(i)/5); %Gamma
                Ni = random(pd,mass(i),1);
                Ni = bsxfun(@times, Nix, Ni);
            case 6 
                pd = makedist('Normal','mu',0,'sigma',cp(i)); %Rings
                Npi = random(pd,2*mass(i),1);
                Npi = bsxfun(@times, Nix, Npi);
                aux=rms(Npi');
                medaux=median(aux);
                Ni=Npi(aux>medaux,:);   
            otherwise
                Ni = make_own_dist(d(1,i)-6, dtb, cp(i),mass(i)); 
                Ni = Ni';
                Ni = bsxfun(@times, Nix, Ni);
        end
    end
   
    % -------------- Calculating covariance matrix for cluster 'i'
    if corr(i)~=0
        covNi=ones(N);
        for l=1:N
            for ll=l:N
                aux=corr(i)*2*(rand()-0.5);
                if l~=ll
                    covNi(l,ll)=aux;
                    covNi(ll,l)=aux;
                end
            end
        end %so far 'covNi' is the correlation matrix
        covNi=nearestSPD(covNi);
        [~,p] = chol(covNi);
        T=cholcov(covNi);
        if p==0, Ni=Ni*T; end
    end
    
    % -------------- Calculating rotation matrix for cluster 'i'
    if (rot) %random rotation
        rotM=2*(rand(N)-0.5);
        rotM=orth(rotM);
        [m,n]=size(rotM);
        if m==n && n==N % 'rotM' keeps NxN dimensions
            Ni=Ni*rotM;
        end
    end
    
    % -------------- Adding noisy variables
    if Nnoise==3, %matrix
        [m,n]=size(Nymx);
        for j=1:m
            pd = makedist('Uniform','Lower',0,'Upper',1); %Uniform
            Nn = random(pd,mass(i),1);
            if (Nymx(j,i)>0) 
                Ni(:,Nymx(j,i)) = Nn; 
            end
        end
    end
    
    % -------------- Placing clusters in the output space
    Ni = bsxfun(@plus, Ni,c(i,:)); 
    MN=[MN;Ni];
    
    % -------------- Updating labels
    labeli=ones(mass(i),1)*cl;
    label=[label;labeli];
    cl=cl+1;
    
    % -------------- Saving intra-clust dist statistics
    mdDa(i)=median(pdist2(Ni,c(i,:)));    
    mnDa(i)=mean(pdist2(Ni,c(i,:)));  
    sdDa(i)=std(pdist2(Ni,c(i,:)));  
end

% -------------- Saving inter-clust dist matrix
Edmx=dist(c');

% -------------- Outliers
MNmax=1.1*max(max(MN));
MNmin=1.1*min(min(MN));

aux=[];
if out>0
    locis(1:k)=[]; l=1;
    for i=1:out
        res=locis(l);
        for j=1:ind
            s(1,j)=mod(res,cmax(j))+1;
            res=floor(res/cmax(j));
            s(1,j)=s(1,j)/(cmax(j)+1);
%            aux(1,j)=(1/(cmax(j)+1))*rand()-(1/(2*(cmax(j)+1)));
            %aux(1,j)=(1/(cmax(j)+1))*normrnd(0,0.01);
            s(1,j)=s(1,j)*(1+normrnd(0,0.1));
        end
        if N>ind
            for j=(ind+1):N
                 s(1,j)=floor(cmax(j)*rand()+1)/(cmax(j)+1);
                 %aux(1,j)=(1/(cmax(j)+1))*rand()-(1/(2*(cmax(j)+1)));
                 %aux(1,j)=(1/(cmax(j)+1))*normrnd(0,0.01);
                 s(1,j)=s(1,j)*(1+normrnd(0,0.1));
            end
        end
        No(i,:)=s;%+aux;
        l=l+1;
        if (l>length(locis)), l=1;end
    end
    MN=[MN;No];
    labeli=zeros(out,1);
    label=[label;labeli];
end

if Nnoise==2, %array
    [m,n]=size(Nyar);
    for i=1:n
        pd = makedist('Uniform','Lower',0,'Upper',1); %Uniform
        Ni = random(pd,(M+out),1);
        if (Nyar(i)>0), MN(:,Nyar(i)) = Ni; end
    end
elseif Nnoise==1, %scalar
    pd = makedist('Uniform','Lower',0,'Upper',1); %Uniform
    Ni = random(pd,(M+out),Nysc);
    MN = [MN, Ni];
end

r.MN=MN;
r.label=label;
if (p.validity.Gindices), [ r.perf ] = Gvalidity(k,Edmx,mdDa,mnDa,sdDa,mass); end
if (p.validity.Silhouette), r.perf.Silhouette=mean(silhouette(MN,label,'Euclidean')); end

end

function [ X ] = make_own_dist( di, dtb, cp, m )
    values=dtb.d(di).values;
    edges=dtb.d(di).edges*cp;
    bwidths=diff(edges);
    [val2, edg2, bin] = histcounts(rand(1,m),[0 cumsum(values)]);
    X = edges(bin) + rand(1,m).*bwidths(bin);
end
