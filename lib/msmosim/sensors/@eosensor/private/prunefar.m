function sel = prunefar( zs, ranges)

numZ = size(zs,2);

sel = [1:numZ];

for i=1:numZ
    
    if isempty( find( sel == i ) )
        continue;
    end
    M = zeros(1,numZ);
    % Find those same with this one
    for j=i+1:numZ
        if zs(1,i) == zs(1,j) &&  zs(2,i) == zs(2,j)
            M(j) = 1;
        end
    end
    % 
    ind = find( M(i) == 1);
    if ~isempty( ind )
       cand = [i,ind]; % The candidates among one to be selected
       [minval, minind ] = min( ranges ); % Find the minimum distance one
       
       % Remove all from the selected set of measurements except the min.
       % distance one
       sel = setdiff( sel, [ cand(1:minind-1), cand(minind+1:end) ] );
    end
    
end

sel = sort(sel);
    


            