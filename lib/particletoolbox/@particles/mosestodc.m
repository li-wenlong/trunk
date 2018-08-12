function [Xh, varargout] = mosestodc( p, varargin )
% MOSESTODC is the method for Multi-object state estimate based on observation driven clustering.

numtargest = 1;

threshold = 0.5;

nvarargin = length(varargin);
argnum = 1;
while argnum<=nvarargin 
    if ischar( varargin{argnum} )
        switch lower(varargin{argnum})
            case {'numtargets'}
                if argnum + 1 <= nvarargin
                    numtargest = varargin{argnum+1};
                    argnum = argnum + 1;
                end
            case {'threshold'}
                if argnum + 1 <= nvarargin
                    threshold = varargin{argnum+1}(1);
                    argnum = argnum + 1;
                end
            case {''}
                
            otherwise
                error('Wrong input string');
        end
    else
        
    end
    argnum = argnum + 1;
end

Xh = [];
if isempty(p)
    return;
end

% First, find the MO state estimates based on the labels
[Xh, Cs, indxs, clmass] = p.mosestwlabel('threshold', threshold);

% Find associated blabels to exclude in the estimation of the targets
% unassociated with any of the observations
exblabels = [];
for i=1:length(indxs)
    exblabels = [exblabels; unique( p.getblabels(indxs{i}),'legacy' )];
end
exblabels = unique( exblabels,'legacy' );


if size(Xh,2)<numtargest 
    % Some target(s) are not captured by the observation labelled cluster
    if ~isempty( p.blabels )
        % Second, find the MO state estimates based on the birth labels
        [Xh2, Cs2, indxs2, clmass2] = p.mosestwbirthlab('threshold', threshold, 'exclude', exblabels );
        if ~isempty(Xh2)
            selelements = [1:min( numtargest - size(Xh,2), size(Xh2,2) )];
            Xh = [Xh,Xh2(:, selelements)];
            Cs = [Cs,Cs2(selelements)];
            indxs = [indxs, indxs2(selelements)];
            clmass = [clmass,clmass2(selelements)];
        end
    end
    
end
    
if nargout >= 2
    varargout{1} = Cs;
end

if nargout >= 3
    varargout{2} = indxs;    
end
if nargout >= 4
    varargout{3} = clmass;
end
