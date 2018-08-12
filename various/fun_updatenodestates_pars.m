function mygraph = fun_updatenodestates( mygraph, messagebox, inodes )

%% Update the node states:
for i=1:length( mygraph.nodes )
    nodei = mygraph.nodes(i).id;
    numsamples = mygraph.nodes(i).state.getnumpoints;
    if ~isempty( find( inodes == nodei ) )
        continue;
    end
    
    inmes = particles;
    for j=1:length( mygraph.nodes(i).parents )
        nodej = mygraph.nodes(i).parents(j);
        % inmes(j) = messagebox{nodej, i };
        if isempty(messagebox{nodej, i })
            continue;
        end
        inmes(j) = messagebox{nodej, i };
        
    end
    st = prodisgausspair( inmes );
    mygraph.nodes(i).state =st; % equally weighted particles
end