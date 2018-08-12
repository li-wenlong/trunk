function [Xh, varargout] = mosestodc( this, varargin )
% MOSESTODC is the method for Multi-object state estimate based on observation driven clustering.


Xh = [];
Cs = {};
indxs = {};
clmass = [];

if isempty(this.postintensity)
    if nargout >= 2
        varargout{1} = Cs;
    end
    if nargout >= 3
        varargout{2} = indxs;
    end
    if nargout >= 4
        varargout{3} = clmass;
    end

    return;
end

% [maxcards, meancards  ]= this.estnumtarg;
numtargest = round( this.mupost );
threshold = 1/numtargest/2;

nvarargin = length(varargin);
argnum = 1;
while argnum<=nvarargin
    if isa( varargin{argnum} , 'char')
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
                legendOn = 1;
                
                
            otherwise
                error('Wrong input string');
        end
    end
    argnum = argnum + 1;
end


if ~isempty( this.postintensity.s.gmm.w )
    [sw, sind] = sort( this.postintensity.s.gmm.w,'descend' );
    for j=1:numtargest
        if sw(j)*this.postintensity.mu>0.5
            Xh = [Xh, this.postintensity.s.gmm.pdfs( sind(j) ).m];
            Cs{j} = this.postintensity.s.gmm.pdfs( sind(j) ).C;
            indxs{j} = sind(j);
            clmass(j) = sw(j);
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
