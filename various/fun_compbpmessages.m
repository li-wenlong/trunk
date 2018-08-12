function messagebox = fun_compbpmessages( mygraph, epots, theta_ijs, messagebox, bpstep, nomessagelist )
% fun_compbpmessages() is an upgraded version of
% fun_findbpmessages_pars.m
% uniform prior is assumed

newmessagebox = cell( length( mygraph.nodes ) );
%% Below are the message computations
for i=1:length( mygraph.nodes )
    nodei = mygraph.nodes(i).id;
    chi_ = [];
    if ~isempty( nomessagelist)
        chi_ = chi( nomessagelist, nodei );
    end
    
    for j=1:length( mygraph.nodes(i).children )
        
        nodej = mygraph.nodes(i).children(j);
    
        if ~isempty( find( nodej == chi_ ) )
            % (nodei, nodej) in the nomessagelist
            % do not update it
            newmessagebox{nodei,nodej} = messagebox{nodei,nodej};
            continue;
        end
        
        epotential = epots{ nodei, nodej };
        epot = particles('states', theta_ijs{ nodei, nodej } ,'weights',epotential, 'labels', nodei);
        epot.findkdebws('nonsparse');
            
        
        parnotj = setdiff( mygraph.nodes(i).parents, nodej);
        numparmone = length( parnotj );% number of parents minus one
        
        % check if messages from these parents exist in the box
        pardiss = []; % parents to disregard
        for pcnt = 1:numparmone
            if isempty( messagebox{ parnotj(pcnt), nodei } )
                pardiss = [pardiss,  parnotj(pcnt)];
            end
        end
        % Find parents to take into account
        paraccount = setdiff( parnotj, pardiss );
        numparacc = length( paraccount );
        
        if numparacc == 0
            % number of parents to taken into account is zero
            % The first bp step should also hit here
            
            theta_i_tilde = mygraph.nodes(i).state.states;
            
            
        else
            % number of parents to take into account non-zero
            % numparacc >= 1
            
            inmes = particles;
            for cnt=1:length( paraccount )
                inmes( cnt ) = messagebox{ paraccount(cnt), nodei };
            end
            
            st = prodisgausspair( inmes );
            theta_i_tilde = getstates( st );
        end
        
        theta_ij_tilde = epot.sample( mygraph.nodes(i).state.getnumpoints );
        theta_j_tilde = theta_i_tilde + theta_ij_tilde;
        
        m_ij = particles( 'states', theta_j_tilde, 'labels', nodei );
        m_ij.findkdebws;
        
        newmessagebox{nodei,nodej} = m_ij;
        
    end
end

% EO message computations

 messagebox = newmessagebox;
