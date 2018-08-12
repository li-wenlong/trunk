function S = sue(E)
% SUE simplifies undirected edge set E by discarding possible multiple
% occurances of (i, j) and all the occurances of (j,i)
% S = sue(E)
%
% See SNEI, ISUNDIRECTED

% Murat uney 2017
% Murat Uney 2009

S = zeros(size(E));
edgeXfered = 0;

for i=1:size(E,1)
    if E(i,1)==0 & E(i,2)==0
        continue;
    else
        edgeXfered=edgeXfered+1;
        S(edgeXfered,:) = E(i,:);
        
        % Discard the multiple occurances
       commonInit = find( E(i,1)== E(i:end,1) );
       commonInit = setdiff( commonInit, 1);
       if ~isempty(commonInit)
           % Find common edge ends
           commonEnd = find( E(i,2)== E(i-1+commonInit,2) );
           for j=1:length( commonEnd )
               E(i-1+commonInit(commonEnd(j)), :) = [0,0];
           end
       end
       
       % Discard the multiple (j,i)s
       commonInit = find( E(i,2)== E(i:end,1) );
       commonInit = setdiff(commonInit,1);
       if ~isempty(commonInit)
           % Find common edge ends
           commonEnd = find( E(i,1)== E(i-1+commonInit,2) );
           for j=1:length( commonEnd )
               E(i-1+commonInit(commonEnd(j)), :) = [0,0];
           end
       end
    end
end
S = S(1:edgeXfered,:);