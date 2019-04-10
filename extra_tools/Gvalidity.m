function [ result ] = Gvalidity(k,G,Admed,Admean,Adstd,memb)

% GVALIDITY calculates dataset (G) and cluster (oi) overlap indices: strict, relaxed and minimum 

%------------------------------------------------------------------------------------------------------
% GVALIDITY v1.0 (Oct 2016)
% Author: Félix Iglesias <felix.iglesias.vazquez@nt.tuwien.ac.at>
% License: GPLv3 (2016)
%
% Copyright (C) 2016  Félix Iglesias, TU Wien
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

result.Gstr=0;
result.Grex=0;
result.Gmin=0;

for i=1:k
    rad(i)=Admean(i)+2*Adstd(i);
    rad2(i)=Admed(i);
    radm(i)=rad(i)*memb(i);
    radm2(i)=rad2(i)*memb(i);
    
    oist(1)=1;
    oirx(1)=1;
    l=1;  
    for j=1:k
        if j~=i
            oist(l)=G(i,j)-(rad(i))-(Admean(j)+2*Adstd(j));
            oirx(l)=G(i,j)-Admed(i)-Admed(j);
            l=l+1;
        end
    end
    
    result.oi_st(i)=min(oist);
    result.oi_rx(i)=min(oirx);
    result.oi_mn(i)=min(oist)/(Admean(i)+2*Adstd(i));
    
    result.Gstr=result.Gstr+result.oi_st(i)*memb(i);
    result.Grex=result.Grex+result.oi_rx(i)*memb(i);
end

result.Gstr=result.Gstr/sum(radm);
result.Grex=result.Grex/sum(radm2);
result.Gmin=min(result.oi_mn);

end

