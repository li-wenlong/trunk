function messagebox = fun_findbpmessages( mygraph, mygraph0, epots, theta_ijs, messagebox, bpstep, nomessagelist )


%% Below are the message computations
if bpstep == 1
    % First round of messaging
    newmessagebox = cell( length( mygraph.nodes ) );
    for i=1:length( mygraph.nodes )
        nodei = mygraph.nodes(i).id;
        chi_ = [];
        if ~isempty( nomessagelist)
            chi_ = chi( nomessagelist, nodei );
        end
        for j=1:length( mygraph.nodes(i).children )
            
            nodej = mygraph.nodes(i).children(j);
            if ~isempty( find( nodej == chi_ ) )
                % do not update this edge 
                newmessagebox{i,nodej} = messagebox{i,nodej};                
                continue;
            end
            
            epotential = epots{i, nodej} ;
                       
            epot = particles('states', theta_ijs{i, nodej } ,'weights',epotential, 'labels', i);
            epot.findkdebws('nonsparse');
            
            
            theta_i_tilde = mygraph.nodes(i).state.states;
            
            theta_ij_tilde = epot.sample( mygraph.nodes(i).state.getnumpoints );
            theta_j_tilde = theta_i_tilde + theta_ij_tilde;
            
            m_ij = particles( 'states', theta_j_tilde, 'labels', i);
            m_ij.findkdebws;
      
            newmessagebox{i,nodej} = m_ij;      
        end
    end
     messagebox = newmessagebox;
    % End of first round of messaging
else
    % Second, third,... of messaging
    newmessagebox = cell( length( mygraph.nodes ) );
    for i=1:length( mygraph.nodes )
        nodei = mygraph.nodes(i).id;
         chi_ = [];
        if ~isempty( nomessagelist)
            chi_ = chi( nomessagelist, nodei );
        end
     
        for j=1:length( mygraph.nodes(i).children )
            
               
            nodej = mygraph.nodes(i).children(j);
            if ~isempty( find( nodej == chi_ ) )
                % do not update this edge 
                newmessagebox{i,nodej} = messagebox{i,nodej};
                continue;
            end
       
            epotential = epots{i, nodej} ;
            
            partoaccount = setdiff( mygraph.nodes(i).parents,...
                mygraph.nodes(i).children(j));
            numparmone = length( partoaccount );% number of parents minus one
            
            % check if messages from these parents exist in the box
            disprnt = [];
            for pcnt = 1:numparmone
                if isempty( messagebox{ partoaccount(pcnt),i} )
                    disprnt = [disprnt,  partoaccount(pcnt)];
                end
            end
            partoaccount = setdiff( partoaccount, disprnt );
            numparmone = length( partoaccount );
            
            if numparmone == 0   
                epot = particles('states', theta_ijs{i, nodej } ,'weights',epotential, 'labels', i);
                epot.findkdebws('nonsparse');
                
                
                theta_i_tilde = mygraph.nodes(i).state.states;
                
                theta_ij_tilde = epot.sample( mygraph.nodes(i).state.getnumpoints );
                theta_j_tilde = theta_i_tilde + theta_ij_tilde;
                
                m_ij = particles( 'states', theta_j_tilde, 'labels', i);
                m_ij.findkdebws;
            else
                if isempty(messagebox{partoaccount(1),i})
                    error('Unhandled condition - awkward!!!');
                else
                    inmes = particles;
                    for cnt=1:length( partoaccount )
                        inmes( cnt ) = messagebox{ partoaccount(cnt), i };
                    end
                    
                    st = prodisgausspair( inmes );
                    
                    epot = particles('states', theta_ijs{i, nodej } ,'weights',epotential, 'labels', i);
                    epot.findkdebws('nonsparse');
                    
                    
                    theta_i_tilde = getstates( st );
                    
                    theta_ij_tilde = epot.sample( st.getnumpoints );
                    theta_j_tilde = theta_i_tilde + theta_ij_tilde;
                    
                    m_ij = particles( 'states', theta_j_tilde, 'labels', i);
                    m_ij.findkdebws;
                end
                
            end
            newmessagebox{i,nodej} = m_ij;
            
        end
    end
    messagebox = newmessagebox;
    
end % EO message computations
