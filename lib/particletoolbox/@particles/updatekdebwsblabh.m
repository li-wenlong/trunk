function varargout = updatekdebwsblabh( p, varargin )
% updatekdebwsblabh updates the KDE bandwidths in accordance with a
% birthlabel hierarchy in which the topmost fields of the state vector are
% the roots of the clustering and the bottommost fields determine the
% leaves.

kernelType = 'Gauss';
bwselection = 'rot';
covmtype = 'sparse';
depth = 2;
dims = [1:p.getstatedims];

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
%             case {'depth'}
%                 if argnum + 1 <= nvarargin
%                     depth = varargin{argnum+1}(:);
%                     argnum = argnum + 2;
%                 end
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

% Traverse the 2-depth tree and find indxs
if ~isempty( p.blabels )
    ubl = unique( p.blmap,'legacy' );
    for j=1:length(ubl)
        
        dims4bl{j} = find( p.blmap == ubl(j) ); % These are the fields of clusters
        subclusterlabels{j} = unique( p.blabels( ubl(j), :),'legacy' );
        %  disp(sprintf('Number of subcluster labels for field %d  is %d',j,length( subclusterlabels{j}  )));
        if j==1
        for k=1:length( subclusterlabels{j}  )
            
            subclusterind{j}{k} = find( p.blabels( ubl(j), :) ==  subclusterlabels{j}(k) );            
        end
        elseif j>1
            for jj=1:length( subclusterlabels{j-1} ) % For each parent in the upper level
                for k=1:length( subclusterlabels{j} )
                  pind = find( p.blabels( ubl(j), subclusterind{j-1}{jj} ) ==  subclusterlabels{j}(k) );
                  subclusterind{j}{ (jj-1)*length( subclusterlabels{j} ) + k} = subclusterind{j-1}{jj}(pind);
                end
            end
            
        end
    end
end


for i = 1:length( subclusterind{2} ) % Clusters at level 2
    
        
        ind_ = subclusterind{2}{i}; % This is level 1
        if isempty(ind_ )
            continue;
        end
        
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
                interind = ind_ ;
                [bws_ , states_, Ss, iswarning ]= grotcovmat( p.states(  dims, interind ), 'weights', p.weights(interind),'warningswitch',0 ); % states_ might be regularised
                %if iswarning == 0
                    p.states( dims , interind ) = states_;
                    p.bws( dims, dims, interind ) = bws_ ;
                    p.C( dims, dims, interind ) = bws_ ;
                    p.S( dims, dims, interind ) = Ss ;
                %else
                %    iswarning
                %end
            end
        end
        
end % level 1


if nargout == 0
    if ~isempty( inputname(1) )
        assignin( 'caller',inputname(1), p );
    else
        error('Could not overwrite the instance; make sure that the argument is not in an array!');
    end
else
    varargout{1} = p;
end