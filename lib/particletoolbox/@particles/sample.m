function x = sample( this, varargin )

numsamples = 1;
if nargin>=2
    numsamples = varargin{1}(1);
end

numcomps = size( this.states,2 );
dim = size( this.states, 1);
x = zeros(dim,numsamples);

gauss_mat = randn(dim,numsamples);

comps = randint( this.weights, numsamples );
for i=1:numcomps
    ind = find(comps == i);
    if ~isempty(ind)
        reqnum= length(ind);
        
        sigs = eig( this.bws(:,:,i) );
        try
            R = chol( this.bws(:,:,i) )';
            
        catch
            R = zeros(xdim,xdim) ;
        end
        x(:,ind) = repmat( this.states(:,i),1, length(ind) ) + ( R )*gauss_mat(:,ind);
        
    end
end
