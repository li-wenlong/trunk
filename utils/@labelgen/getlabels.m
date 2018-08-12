function varargout = getlabels( lgen, varargin )

nvarargin = length(varargin);
argnum = 1;
lmap = [];
numlabels = 1;
while argnum<=nvarargin
    if isa( lower(varargin{argnum}), 'char')
        switch lower(varargin{argnum})
            case {'labelmap'}
                if argnum + 1 <= nvarargin
                    lmap = varargin{argnum+1}(:);
                end
            case {'numlabels'}
                if argnum + 1 <= nvarargin
                    numlabels = varargin{argnum+1}(1);
                    argnum = argnum + 1;
                end
                
            case {''}
               
                
            otherwise
                error('Wrong input string');
        end
    end
     argnum = argnum + 1;
end

if lgen.firstcall == 0
    c = datenum(clock);
    lsig = 15;
    for i=1:15
        if 10^i>c
            lsig = i;
            break;
        end
    end
    rsig = 1;
    while( rem(c*10^rsig, 10 ) ~=0 )
        rsig = rsig + 1;
    end
    exponent = rsig + lsig;
    const = datenum(clock)*(10^(rsig-1));
    
    lgen.counter =  const;
    lgen.firstcall = 1;
end

if isempty( lmap  )
    la = lgen.counter + ([1:numlabels]*(10^(lgen.exponent ) )) ; % + const;
    lgen.counter = lgen.counter + ([numlabels]*(10^(lgen.exponent ) )); % + const;
else
    ulabels = unique( lmap,'legacy' );
    numulabels = length( ulabels );
    for j=1:numulabels
        ind = find( lmap == ulabels(j) );
        la(ind) = lgen.counter +  ([j]*(10^(lgen.exponent ) )) ;% + const;
    end
    lgen.counter = lgen.counter +  ([numulabels]*(10^(lgen.exponent ) )); % + const;
end



if nargout <=1
    if ~isempty( inputname(1) )
        assignin('caller',inputname(1),lgen);
    else
        error('Could not overwrite the instance; make sure that the argument is not in an array!');
    end
    varargout{1} = la;
else
    varargout{2} = lgen;
    varargout{1} = la;
end