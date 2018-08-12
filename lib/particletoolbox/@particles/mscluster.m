function [clustCent, varargout] = mscluster( this, varargin )


% Whiten the states

wstates = this.states;
for i=1:size(wstates,2)
    Wp = sqrtm( this.S(:,:,i) );
    wstates(:,i) = Wp*wstates(:,i);
end

bw = 1;
% Find the bandwidth using the labels
ulabels = unique( this.labels,'legacy' );
nzlabels = ulabels( find( ulabels~= 0 ) );
for i=1:length(nzlabels)
    linds = find( this.labels == nzlabels(i) );
    C = wcov( wstates(:, linds ), this.weights( linds ) );
    if rcond(C) > eps
        evals = eigs(C);
    else
        evals = 1;
    end
    
    bw = max( bw, sqrt( max(evals) ) );
end

    
clustCent = [];
Cs = {};
clustMembsCell = {};
clmass = [];
    
[clustCent,point2cluster,clustMembsCell] = MeanShiftCluster( wstates, bw*2 );

for i=1:length( clustMembsCell )
    clustCent(:,i) = mean( this.states(:,clustMembsCell{i} ) , 2);
    Cs{i} = wcov( this.states(:,clustMembsCell{i}), this.weights(clustMembsCell{i}) );
    clmass = [clmass; sum( this.weights( clustMembsCell{i} ) ) ];
end

if nargout>=2
    varargout{1} = Cs;
end
if nargout>=3
    varargout{2} = clustMembsCell;
end
if nargout>=4
    varargout{3} = clmass;
end
if nargout>=5
    varargout{4} = point2cluster;
end
