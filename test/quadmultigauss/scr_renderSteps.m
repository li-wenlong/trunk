

save2avi = 1;


%% Save DEBUG_PMRF_CARRAY in files
% numsteps = length(DEBUG_PMRF_CARRAY);
% 
% for cnt=1:numsteps
%     mygraph = DEBUG_PMRF_CARRAY{cnt};
%     save(['resgraph_step_',num2str(cnt),'.mat'],'mygraph');
% end


global DEBUG_MISC

global DEBUG_PMRF DEBUG_PMRF_CARRAY DEBUG_VERBOSE
DEBUG_PMRF = 1;
DEBUG_VERBOSE = 1;
DEBUG_MISC = 1;
stepnos = [1:20];

Thetas = [[0 0];[1000 0];[1000 1000];[0 1000];[-1000 1000];...
    [-1000 0];[-1000 -1000];[0 -1000];[1000 -1000];...
    [2000 -1000];[2000 0];[2000 1000];[2000 2000];...
    [1000 2000];[0 2000];[-1000 2000]];
fhandle = figure;
set( gcf, 'color', [1 1 1] );
axis([-1500 2500 -1500 2500])
    

for cnt = 1:length( stepnos )
    
    load(['resgraph_step_',num2str(stepnos(cnt)),'.mat'],'mygraph' );
   % mygraph = DEBUG_PMRF_CARRAY{stepnos(cnt)};
    % get the graph
    E = mygraph.E;
    V = mygraph.V;
    
    % Colormap
    mymap = linspecer(length( V ));
    
    figure( fhandle )
    cla;
    
    xlabel('East (m)','FontSize',14)
    ylabel('North (m)','FontSize',14)
    axis([-1500 2500 -1500 2500])
    
    drawgeograph( Thetas, E,  'AxisHandle', gca, 'Linewidth',1,'Color','b' )
    hold on
    grid on
    for i=1:length( V )
        col = mymap(i,:);
        
        if ~isempty( mygraph.nodes(i).state )
            xy = mygraph.nodes(i).state.states;
            l2 = plot( xy(1,:), xy(2,:), 'color',col,'marker','x','linestyle','none','MarkerSize',8,'Linewidth',2 );
        end
        
        drawnow;
    end
    
    xlabel('East (m)','FontSize',14)
   ylabel('North (m)','FontSize',14)
   title(['iteration = ', num2str(cnt)],'FontSize',14)
   
   drawnow;
   
   
end

    


