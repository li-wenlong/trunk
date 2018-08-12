function sel = prunefar( losP, std )

numZ = size(losP,2);

sel = [1:numZ];

for i=1:numZ
    
    if isempty( find( sel == i ) )
        continue;
    end
    M = zeros(1,numZ);
    % Find the nearby ones.
    for j=i+1:numZ
        if abs(losP(1,i) - losP(1,j)) < std
            M(j) = 1;
        end
    end
    % 
    ind = find( M(i) == 1);
    if ~isempty( ind )
       cand = [i,ind]; % The candidates among one to be selected
       [minval, minind ] = min( losP( 2, cand ) ); % Find the minimum distance one
       
       % Remove all from the selected set of measurements except the min.
       % distance one
       sel = setdiff( sel, [ cand(1:minind-1), cand(minind+1:end) ] );
    end
    
end

sel = sort(sel);
    


            