function varargout = evaluate( these, varargin )

isGMM = 1;
isKDE = 0;
isnumsamples = 0;

for cnt=1:length(varargin)
    if ischar( varargin{cnt})
        if strcmp( lower( varargin{cnt} ), 'gmm' )
           isGMM = 1;
           isKDE = 0;
        elseif strcmp( lower( varargin{cnt} ), 'kde' )
            isKDE = 1;
            isGMM = 0;
        else
            warning(sprintf('Unidentified token: %s !', varargin{cnt}));
        end
    elseif isnumeric( varargin{cnt} )
        p_ = varargin{cnt};
    else
        error('Wrong input string');
    end
end

[d, N]=size( p_ );
ep = zeros( length(these), N );
for i=1:length(these)
   
    if isGMM
        ep_ = evaluate( these(i).gmm, p_ );
    elseif isKDE
        if d == 2
            A = 0.96;
        else
            A = (4/(2*d+1))^(1/(d+4));
        end
        h1 = A*N^(-1/(d+4));
              
        ep_ = zeros(1,N);
        for kind = 1:length( these(i).kdes )
            % Find the inverse transform
            Lambda_p = these(i).gmm.pdfs(kind).S;
            C_p = these(i).gmm.pdfs(kind).C;
            T = sqrtm( Lambda_p );
            
           % w1 = T*(p_ - repmat( these(i).gmm.pdfs(kind).m,1,N ));
            w1 = T*p_;
 
            ep_ = ep_ + these(i).gmm.w(kind)*(1/sqrt( det( C_p ) ))*evaluate( these(i).kdes(kind), w1 );
        end
    end
    ep(i,:) = ep_;
end

varargout{1} = ep;
