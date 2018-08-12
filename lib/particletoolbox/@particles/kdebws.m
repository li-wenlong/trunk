function varargout = kdebws( p, varargin )
% This function 

kernelType = 'Gauss';
bwselection = 'rot';
covmtype = 'sparse';


nvarargin = length(varargin);
argnum = 1;
while argnum<=nvarargin

        switch lower(varargin{argnum})
            case {'kerneltype'}
                if argnum + 1 <= nvarargin
                    kernelType = varargin{argnum+1};
                    argnum = argnum + 1;
                end
            case {'bwselection'}
                if argnum + 1 <= nvarargin
                    bwselection = varargin{argnum+1};
                    argnum = argnum + 1;
                end
            case {'sparse'}
                covmtype = 'sparse';
                argnum = argnum + 1;
            case {'nonsparse'}
                covmtype = 'nonsparse';
                argnum = argnum + 1;
            otherwise
                 error('Wrong input string');
        end

end

ulabels = unique( p.labels,'legacy' );
nzind = find( ulabels~= 0 ) ;
[nonzerolabels ]= ulabels( nzind );

zerolabels = find( p.labels == 0 );

% Select small bws
if strcmp( covmtype, 'sparse' )
   bws = ones(size(p.states))*eps;
elseif strcmp( covmtype, 'nonsparse' )
   bws = repmat( eye( size(p.states, 1) )*eps,[ 1 , 1, size(p.states, 2) ] );
   Ss = repmat( eye( size(p.states, 1) )*1/eps,[ 1 , 1, size(p.states, 2) ] );
end
        


if ~isempty( nonzerolabels )
    
    numcomps = length( nonzerolabels );
    
    
    for i = 1:numcomps
        ind_ = find( p.labels == nonzerolabels( i ) ); % Find the component elements
        % 
        compw(i) = sum( p.weights(ind_) ); % Find the component weight
        
        [d Nc] = size( p.states(:, ind_ ) );
        if strcmp( covmtype, 'sparse' )
            kde_ = kde( p.states(:, ind_ ) , bwselection,  reshape( p.weights(ind_),  1, Nc )/compw(i) , kernelType  ); % Weights are scaled at constructor
            bws( :, ind_ ) = getBW( kde_ );
        elseif strcmp( covmtype, 'nonsparse' )
            % Only for Gaussian Kernels and using rot now
            [bws( :, :, ind_ ),dummy,Ss(:,:,ind_)] =  grotcovmat( p.states(:, ind_ ), 'weights', p.weights(ind_) );
           
            
        end
        
    end
    % Assign the min. bw to states labeled 0
    if strcmp( covmtype, 'sparse' )


        minbw = min( bws(:,nzind)' );
        bws(:,zerolabels) = repmat( minbw', 1, length(zerolabels)  );
    end
end
% For the zero labels:
if ~isempty( zerolabels )
    if strcmp( covmtype, 'sparse' )
        % Cluster based on the
        compw=[];
        [ shistlen, indx ] = sort( p.histlen( zerolabels ), 'descend' );
        ulen =  sort( unique( shistlen,'legacy' ),'descend' );
        for i = 1:length( ulen )
            pind_ = find( p.histlen(zerolabels) == ulen(i) );


            compw(i) = sum( p.weights( zerolabels( pind_ ) ) );

            [d Nc] = size( p.states(:,  zerolabels( pind_ ) ) );

            if length(pind_)< size( p.states, 1 )
                bws_ = ones( size( p.states, 1 ), length(pind_) );
            else

                kde_ = kde( p.states(:, zerolabels( pind_ ) ) , bwselection,  reshape( p.weights( zerolabels( pind_ ) ),  1, Nc )/compw(i) , kernelType  ); % Weights are scaled at constructor
                bws_ = getBW( kde_ );
            end

            if i==1
                minbw = bws_(:,1);
            else
                if norm( bws_(:,1) ) >= norm( minbw )
                    bws_ = repmat( minbw, 1, size(bws_,2) );
                end

            end
            bws( :, zerolabels( pind_ ) ) = bws_;
        end
    end
end

p.bws = bws;
p.C = bws;
p.S = Ss;

if nargout == 0
    if ~isempty( inputname(1) )
        assignin( 'caller',inputname(1), p );
    else
        error('Could not overwrite the instance; make sure that the argument is not in an array!');
    end
else
    varargout{1} = p;
end