function  theta_ijs = fun_updatethetaijs( mygraph, theta_ijs, ul )

% ul: update list
numnodes =  mygraph.getnumnodes;
Ph = zeros( numnodes );% This the processing history not to do processing for (i,j) twice
for i=1:numnodes
    nodei = mygraph.nodes(i).id;
    
    chi_ = []; % Find the children of nodei in cedges
    if ~isempty( ul)
        chi_ = chi( ul, nodei );
    end
    
    for j=1:length( mygraph.nodes(i).children )
        nodej = mygraph.nodes(i).children(j);
        
        if isempty( find( nodej == chi_ ) )
            % (nodei, nodej) is not in the cedges
            % do not update it
            continue;
        end
        
        if Ph( nodei, nodej ) ~= 0
            % Processed before
            continue;
        end
        
        % Get the states in earth fixed coordinate system
        localstate = mygraph.nodes( nodei ).state.states;
        remstate = mygraph.nodes( nodej ).state.states;
        
        % Now, find theta_ij in ith coordinate frame
        % given by \theta_i(k) = localstate(:,k)
        
        losi = - localstate + remstate; % line of sight vector at node i
        
        theta_ij = zeros( size( losi ) );      
        theta_ji = zeros( size( losi ) );
       
        for k=1:size( theta_ij,2 )
            
            R_mat = dcm( localstate(3,k), 0, 0);
            R_mat = R_mat([1,2],[1,2]);
            theta_ij([1:2], k ) = R_mat*losi([1,2], k);
            theta_ij(3, k ) = losi( 3, k );
            
            
            R_mat = dcm( remstate( 3, k ), 0, 0);
            R_mat = R_mat([1,2],[1,2]);
            theta_ji([1:2],k) = R_mat*( -losi( [1,2], k ) );
            theta_ji(3, k ) = -losi( 3, k );
        end
 
        theta_ijs{ nodei, nodej } =  theta_ij;
        theta_ijs{ nodej, nodei } = theta_ji;
        
        
        
        Ph( nodei, nodej ) = 1; Ph( nodej, nodei ) = 1; % Put a tick on the processing history
        
    end
end
            
            




