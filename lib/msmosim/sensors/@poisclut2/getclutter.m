function varargout = getclutter(this, varargin)

minnum = 0;
untilarg = length( varargin );
nvarargin = length(varargin);
argnum = 1;
while argnum<=nvarargin
    
    switch lower(varargin{argnum})
        
        case {'minum'}
            if argnum + 1 <= nvarargin
                untilarg = argnum - 1;
                minnum = varargin{argnum+1};
                argnum = argnum + 1;
            end            
        case {''}
            
       
        otherwise
           % error('Wrong input string');
    end
    argnum = argnum + 1;  
end


numpts = max( poissrnd( this.lambda ), minnum);

out = {};
for i=1:untilarg
    out{i} = rand( numpts ,1)*varargin{i}(1);
end

varargout{1} = out;

