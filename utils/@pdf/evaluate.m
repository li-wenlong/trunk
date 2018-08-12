function varargout = evaluate( these, varargin )

isGMM = 0;
isKDE = 1;
isnumsamples = 0;
isReg = 0;
sig_ = 0;

p_ = [];

nvarargin = length(varargin);
argnum = 1;
while argnum<=nvarargin
    if isa( varargin{argnum} , 'char')
        switch lower(varargin{argnum})
            case {'gmm'}
                isGMM = 1;
                isKDE = 0;
            case {'kde'}
                isKDE = 1;
                isGMM = 0;
            case {'regaddnoise'}
                if argnum + 1<= nvarargin
                    isReg = 1;
                    sig_ = varargin{argnum+1};
                    argnum = argnum + 1;
                end
            case {'regularise'}
                isReg = 1;
            otherwise
                error('Wrong input string');
        end
    elseif isa( varargin{argnum} , 'numeric')
        p_ = varargin{argnum};
    end
    argnum = argnum + 1;
end


if isempty(p_) && ~isempty( these.particles )
    p_ = these.particles.getstates;
end

[d, N]=size( p_ );
ep = zeros( length(these), N );
for i=1:length(these)
   
    if isGMM && ~isempty(  these(i).gmm ) 
        ep_ = evaluate( these(i).gmm, p_ );
    elseif isKDE && ~isempty(  these(i).kdes )
        if ~isempty( these(i).kdes )
            ep_ = evaluate( these(i).kdes, p_, 0 );
        else
            if isReg
                ep_ = evaluate( these(i).particles, p_, 'regaddnoise', sig_ );
            else
                ep_ = evaluate( these(i).particles, p_ ); 
            end
        end
        
    end
    ep(i,:) = ep_;
end

varargout{1} = ep;
