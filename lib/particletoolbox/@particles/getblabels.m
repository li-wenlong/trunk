function labels_ = getlabels(par, varargin)

inds = [1:size(par.blabels,2)]';

nvarargin = length(varargin);
argnum = 1;
while argnum<=nvarargin 
    if ischar( varargin{argnum} )
        %switch lower(varargin{argnum})
                           
         %   otherwise
                error('Wrong input string');
        %end
    else
        inds =  varargin{argnum};       
    end
    argnum = argnum + 1;
end

if ~isempty( par.blabels )
    labels_ = par.blabels( par.blmap , inds );
else
    labels_ = zeros( length(par.blmap), length(inds) );
end
            