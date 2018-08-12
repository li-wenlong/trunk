function  [Xh, varargout] = mosestwlabel( p, varargin )


Xh = [];
if isempty(p)
    return;
end

threshold = 0.5;
exlabels = [];

nvarargin = length(varargin);
argnum = 1;
while argnum<=nvarargin
    if isa( varargin{argnum} , 'char')
        switch lower(varargin{argnum})
            case {'threshold'}
                if argnum + 1 <= nvarargin
                    threshold = varargin{argnum+1}(1);
                    argnum = argnum + 1;
                end
            case {'exclude'}
                if argnum + 1 <= nvarargin
                    exlabels = varargin{argnum+1};
                    argnum = argnum + 1;
                end   
            case {''}
                legendOn = 1;
                
                
            otherwise
                error('Wrong input string');
        end
    end
    argnum = argnum + 1;
end


ulabels = unique( p.labels,'legacy' );
nzind = find( ulabels~= 0 ) ;
[nonzerolabels ]= ulabels( nzind );

zerolabels = find( p.labels == 0 );

subclusterlabels = unique( p.blabels(1,:),'legacy' );
% Exclude the labels
subclusterlabels = setdiff( subclusterlabels, exlabels);
numsubcl = length( subclusterlabels );

selsubcl = []; % selected sub classes

Cs = {};
Xh = [];
indxs = {};
clmasslist = [];
nest = 0;
for j=1:numsubcl
    subclind = find( p.blabels(1,:)== subclusterlabels(j) );
    indx = intersect( zerolabels, subclind );
    if ~isempty( indx )
        % Check the cluster masses
        clmass = sum( p.weights(indx) );
        if clmass >= threshold
            nest = nest + 1;
            clmasslist(nest) = clmass;
            
            selsubcl(nest) =j;
            indxs{nest} = indx;
            %C = cov(p.states(:,indx)');
            C = wcov( p.states(:,indx), p.weights(indx) );
            Cs{nest} = C;
            Xh(:,nest) = mean( p.states(:, indx) , 2 );
            
        end
        
    end
end

[sclmass, sind] = sort( clmasslist, 'descend' );

Xh = Xh(:,sind);
Cs = Cs(sind);
indxs = indxs(sind);


if nargout >= 2
    varargout{1} = Cs;
end

if nargout >= 3
    varargout{2} = indxs;
end
if nargout >= 4
    varargout{3} = sclmass;
end


