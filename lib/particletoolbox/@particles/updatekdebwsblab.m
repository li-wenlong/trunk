function varargout = kdebws( p, varargin )
% This function 

kernelType = 'Gauss';
bwselection = 'rot';
covmtype = 'sparse';

dims = [1,2]';

nvarargin = length(varargin);
argnum = 1;
while argnum<=nvarargin

        switch lower(varargin{argnum})
            case {'kerneltype'}
                if argnum + 1 <= nvarargin
                    kernelType = varargin{argnum+1};
                    argnum = argnum + 2;
                end
            case {'bwselection'}
                if argnum + 1 <= nvarargin
                    bwselection = varargin{argnum+1};
                    argnum = argnum + 2;
                end
            case {'dims','dimensions'}
                if argnum + 1 <= nvarargin
                    dims = varargin{argnum+1}(:);
                    argnum = argnum + 2;
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

if ~isempty( nonzerolabels )
    
    numcomps = length( nonzerolabels );
    
    if ~isempty( p.blabels )
        ubl = unique( p.blmap,'legacy' ); 
        for j=1:length(ubl)
            dims4bl{j} = find( p.blmap == ubl(j) ); % These are the fields of clusters
            subclusterlabels{j} = unique( p.blabels( ubl(j), :) ,'legacy' );
          %  disp(sprintf('Number of subcluster labels for field %d  is %d',j,length( subclusterlabels{j}  )));
            for k=1:length( subclusterlabels{j}  )
                subclusterind{j}{k} = find( p.blabels( ubl(j), :) ==  subclusterlabels{j}(k) );
            end
        end
        
    end
    
    
    for i = 1:numcomps
        ind_ = find( p.labels == nonzerolabels( i ) );
        
        compw(i) = sum( p.weights(ind_) );
        
        [d Nc] = size( p.states(:, ind_ ) );
        if strcmp( covmtype, 'sparse' )
            kde_ = kde( p.states(:, ind_ ) , bwselection,  reshape( p.weights(ind_),  1, Nc )/compw(i) , kernelType  ); % Weights are scaled at constructor
            p.bws( :, ind_ ) = getBW( kde_ );
        elseif strcmp( covmtype, 'nonsparse' )
            % Only for Gaussian Kernels and using rot for now
            if isempty( p.blabels )
                % if blabels are empty, then perform the update by not
                % caring about it
                [bws_ , states_, Ss ]= grotcovmat( p.states( dims , ind_ ), 'weights', p.weights(ind_) ); % states_ might be regularised
                p.states( dims , ind_ ) = states_;
                p.bws( dims, dims, ind_ ) = bws_ ;  
                p.C( dims, dims, ind_ ) = bws_ ;  
                p.S( dims, dims, ind_ ) = Ss ;  
            else
                % Find subclusters of state fields based on the birth labels 
                % and then update bws
                for j=1:length(ubl)
                    dims_ = dims4bl{j};
                    % If dims_ are the required dimensions
                    if norm(dims-dims_)>eps
                        continue;
                    end 
                    for k=1:length( subclusterlabels{j}  )
                        scind = subclusterind{j}{k};
                        interind = intersect( scind, ind_ );
                        if isempty(interind)
                            continue;
                        end
                        [bws_ , states_, Ss, iswarning ]= grotcovmat( p.states(  dims, interind ), 'weights', p.weights(interind),'warningswitch',0 ); % states_ might be regularised
                        if iswarning == 0
                            p.states( dims , interind ) = states_;
                            p.bws( dims, dims, interind ) = bws_ ;
                            p.C( dims, dims, interind ) = bws_ ;
                            p.S( dims, dims, interind ) = Ss ;
                        end
                    end
                end
            end
            
        end
        
    end
    
end


if nargout == 0
    if ~isempty( inputname(1) )
        assignin( 'caller',inputname(1), p );
    else
        error('Could not overwrite the instance; make sure that the argument is not in an array!');
    end
else
    varargout{1} = p;
end