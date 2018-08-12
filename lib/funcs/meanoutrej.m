function [m, varargout] = meanoutrej(A, varargin)

stdfactor = 3;
printnumout = 0;
nvarargin = length(varargin);
islowerbound = 1;
isoutliers = 0;
outl = {};
ismaxnumout = 0;
maxnumout = 10;
argnum = 1;
while argnum<=nvarargin
    
    switch lower(varargin{argnum})
        case {'stdfactor'}
            if argnum + 1 <= nvarargin
                stdfactor = varargin{argnum+1};
                argnum = argnum + 1;
            end
         case {'maxnumout'}
            if argnum + 1 <= nvarargin
                maxnumout = varargin{argnum+1};
                ismaxnumout = 1;
                argnum = argnum + 1;
            end
        case {'outliers'}
            if argnum + 1 <= nvarargin
                outl = varargin{argnum+1};
                isoutliers = 1;
                argnum = argnum + 1;
            end
        case {'nolowerbound'}
             islowerbound  = 0;
         case {'printnumout'}
             printnumout = 1;
             
        otherwise
            error('Wrong input string');
    end
    argnum = argnum + 1;
end


numsteps = size(A,2);


nout = [];
for i=1:numsteps
    if isoutliers
        numel = length(  A(:,i) );
        nonoind =  setdiff( [1:numel]', outl{i} );
         % revise the mean value
        m(i) = sum( A(nonoind,i))/length(nonoind);
        nout(i) = length(outl{i});
        
    else
        numel = length(  A(:,i) );
        
        m(i) = sum( A(:,i))/numel;
        
        stdval = std( A(:,i)  );
        oind = find( A(:,i) > m(i)  + stdfactor*stdval); % outliers 1; those greater than mean plust K*std
        oind2 = [];
        if islowerbound
            oind2 = find( A(:,i) < m(i)  - stdfactor*stdval); % outliers 2; those smaller than mean plust K*std
        end
        outl{i} =  [oind;oind2];
        
        if ismaxnumout
            if length( outl{i} )>maxnumout
                costs = A( outl{i}, i);
                [scosts, sindx ] = sort( costs );
                outl{i} = outl{i}(sindx(1:maxnumout));
            end
            
        end
        
        
        nonoind =  setdiff( [1:numel]', outl{i} );
        
        % revise the mean value
        m(i) = sum( A(nonoind,i))/length(nonoind);
        nout(i) = length(outl{i});
    end
end

if  printnumout
    fprintf('Num. of outliers:')
    for i=1:numsteps
        fprintf('%d \t ( of %d)', nout(i), size( A,1) );
    end
    fprintf('\n');
end
    

if nargout>=2
    varargout{1} = nout;
end

if nargout>=3
    varargout{2} = outl;
end