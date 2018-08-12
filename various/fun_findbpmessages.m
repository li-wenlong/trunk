function messagebox = fun_findbpmessages( mygraph, mygraph0, epots, theta_ijs, messagebox, bpstep, iedge )


%% Below are the message computations
if bpstep == 1
    % First round of messaging
    for i=1:length( mygraph.nodes )
        nodei = mygraph.nodes(i).id;
        chi_ = [];
        if ~isempty( iedge)
            chi_ = chi( iedge, nodei );
        end
        for j=1:length( mygraph.nodes(i).children )
            
            nodej = mygraph.nodes(i).children(j);
            if ~isempty( find( nodej == chi_ ) )
                % do not update this edge 
                newmessagebox{i,nodej} = messagebox{i,nodej};                
                continue;
            end
               
            epotential = epots{i, nodej} ;
            
            theta_js = mygraph.nodes(i).state.states + theta_ijs{i, nodej };
            % m_ij = particles( 'states', theta_js ,'weights',epotential);
            % m_ij.findkdebws;
            % m_ij.resample
            % m_ij.regwkde;
            
            
            m_ij = kde( theta_js, 'rot',epotential,'g' );
            m_ij = resample( m_ij );
            
            messagebox{i,nodej} = m_ij;
            
        end
    end
    % End of first round of messaging
else
    % Second, third,... of messaging
    newmessagebox = cell( length( mygraph.nodes ) );
    for i=1:length( mygraph.nodes )
        nodei = mygraph.nodes(i).id;
         chi_ = [];
        if ~isempty( iedge)
            chi_ = chi( iedge, nodei );
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
                theta_js = mygraph0.nodes(i).state.states + theta_ijs{i, nodej };
                
                m_ij = kde( theta_js, 'rot', epotential,'g' );
                m_ij = resample( m_ij );
                
            else
                if isempty(messagebox{partoaccount(1),i})
                    theta_js = mygraph0.nodes(i).state.states + theta_ijs{i, nodej };
                    
                    m_ij = kde( theta_js, 'rot', epotential,'g' );
                    m_ij = resample( m_ij );
                else
                    st = fun_kdemultusingparticles(messagebox(partoaccount,i));
                    
                    theta_is = getPoints( st );
                    theta_js = theta_is + theta_ijs{i, nodej };
                    
                    
                    m_ij = kde( theta_js, 'rot', epotential,'g' );
                    m_ij = resample( m_ij );
                end
                
            end
            newmessagebox{i,nodej} = m_ij;
            
        end
    end
    messagebox = newmessagebox;
    
end % EO message computations
