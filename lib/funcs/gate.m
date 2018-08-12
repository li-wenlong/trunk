function those = gate( these , sensors, Xhs, ts, tr )

numreps = length( these );
numsens = length( sensors );

if numsens~=numreps
    error('The number of sensor report arrays and the sensors should match!');
end


% init the output
those = these;

for cnt=1:numreps
    srep = these( cnt );
    
    
    % Find matching time instants
    repts =  cell2mat({these{cnt}.time});
    mt = intersect( repts, ts );
    
    % Initialize an array for those reports which get completely pruned
    emplist = [];
    % For each of the matching time steps
    for j=1:length( mt )
        
        % Find the report index
        rind = find( repts == mt( j ) );
        % Find the target index
        tind = find( ts == mt( j ) );
        
        Xh =  Xhs{tind};
        if isempty( Xh )
            continue;
        end
        % Find the likelihoods
        % row m is for the m th observation, col n is for the n th estimate
        Gk = sensors(cnt).likelihood( these{cnt}(rind), Xh );
        
        % Find the observations to prune, i.e., those ones that stay in one
        % of the target gates
        
        measingate = gatemeasurements( Gk, tr );
        
        measoutgate = setdiff( [1:size(Gk,1)], measingate );
        
        if isempty( measoutgate )
            emplist = [emplist, rind ];
        end
        
        those{cnt}(rind).Z = those{cnt}(rind).Z(measoutgate);
        if ~isempty( those{cnt}(rind).given )
            those{cnt}(rind).given = those{cnt}(rind).given(measoutgate);
        end
    end
    
    % Now, remove the empty reports if there is any
    emplist = sort( emplist );
    for j = 1:length( emplist )
        rind = emplist(j) - j + 1;
        those{cnt} = [ those{cnt}(1:rind-1),those{cnt}(rind+1:end) ];
    end
end

end

function measingate = gatemeasurements( Gk, tr )
   measingate = [];
   % Remove those observations which have under the threshold likelihood
   % for each column
   pGk = [];
   incnt = 1;
   allind = [1:size(Gk,1)];
   outlier = [];
   inclist = [];
   
   for i=1:length( allind )
       if isempty( find( Gk >= tr ) )
           outlier = [outlier, i];
       else
           pGk( incnt, : ) = Gk(i,:);
           inclist = [ inclist, i ];
           incnt = incnt + 1;
       end
   end
   
   if ~isempty( pGk )
       % If the prunned Gk is not empty, run the Hungarian, else, there are
       % no measurements in the gates
       
       M = Hungarian( 1./pGk );     
       for i=1:size(M,1)
           if ~isempty( find( M(i,:)==1 ) )
               measingate = [measingate, inclist(i) ];
           end
       end
   end
   
end