function p = product( these, varargin )

numcomp = length( these );
numsamples = size( these(1).states, 2);
dim = size( these(1).states, 1);
k = 4;

nvarargin = length(varargin);
argnum = 1;
while argnum<=nvarargin
    if isa( varargin{argnum} , 'char')
        switch lower(varargin{argnum})
            case {'k'}
                if argnum+1<= nvarargin
                    k = varargin{argnum+1};
                    argnum = argnum + 1;
                end
            case {'numsamples'}
                if argnum+1<= nvarargin
                    numsamples = varargin{argnum+1};
                    argnum = argnum + 1;
                end
                
            otherwise
                error('Wrong input string');
        end
    elseif isa( varargin{argnum} , 'numeric')
        sig_ = varargin{argnum};
    end
    argnum = argnum + 1;
end

% generate k*M/comp components from 
numfromcomp = ceil( numsamples*k/numcomp );
x = zeros( dim, numfromcomp*numcomp);

for i=1:numcomp
    x(:,(i-1)*numfromcomp+1:i*numfromcomp) = these(i).sample( numfromcomp );
end

dislist = [];
evals = zeros( numcomp, numfromcomp*numcomp  );
% Now find the weights
for i=1:numcomp
    evals(i,:) = these(i).evaluate( x ,'threshold', -1000);
%     if sum( evals(i,:) )< 1.0e-25
%         disp(sprintf('%i . element is all zero', i));
%         dislist = [dislist,i];
%     end
end

%evals = evals( setdiff([1:numcomp], dislist) ,:);

w = prod(evals,1)./sum(evals,1);

% Resample with replacement
idx = resample( w/sum(w), numsamples);

p = particles( 'states', x(:,idx) );
p.findkdebws;


    

