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

[maxcards, meancards  ]= this.estnumtarg;
numtargest = round( meancards(end) );
threshold = 0.5;

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


[Xh, Cs, indxs, clmass ] = this.postintensity.mosestodc('numtargets', numtargest, 'threshold', threshold );
cind = find( clmass > threshold );
if isempty( cind )
    Xh = [];
    Cs = {};
    indxs = {};
    clmass = [];
else
    Xh = Xh(:,cind);
    Cs = Cs(cind);
    indxs = indxs(cind);
    clmass = clmass(cind);
end

if length( indxs )>= 2
    indxs_ = cell2mat(indxs(:));
    indxs_ = indxs_(:);    
    Cs = {wcov( this.postintensity.s.particles.states(:, indxs_), this.postintensity.s.particles.weights(indxs_) )};
    Xh = mean( this.postintensity.s.particles.states(:, indxs_) , 2 );
    indxs = { indxs_ };    
    clmass = sum(clmass);
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
