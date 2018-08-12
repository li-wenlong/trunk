function varargout = resample( these, varargin )

[d N] = size( these.states );
L = N;

nvarargin = length(varargin);
argnum = 1;
while argnum<=nvarargin
    if isa( varargin{argnum} , 'char')
        switch lower(varargin{argnum})
            case {'inpstr1'}
                if argnum + 1 <= nvarargin
                    inpvar1 = varargin{argnum+1}(1);
                    argnum = argnum + 1;
                end
            case {''}
                
                
            otherwise
                error('Wrong input string');
        end
    elseif isa( varargin{argnum} , 'numeric')
        L = varargin{1};
    end
    argnum = argnum + 1;
end

idx = resample2( these.weights/sum(these.weights), L);

these = these.getel( idx );
these.weights = ones(size(these.weights))/length(idx);

if nargout == 0
    if ~isempty( inputname(1) )
        assignin('caller',inputname(1),these);
    else
        error('Could not overwrite the instance; make sure that the argument is not in an array!');
    end
else
    varargout{1} = these;
    if nargout>1
        varargout{2} = idx;
    end
end
