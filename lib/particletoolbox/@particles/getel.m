function p2 = getel( p1, s )

if ~isnumeric(s)
    if iscell(s)
       for i=1:length(s)
           p2(i) = getel(p1,s{i});
       end
       return;
    else
       error('The argument should be an index array!');
    end
end

p2 = particles;
p2.states = p1.states(:, s(:) );
p2.weights = p1.weights( s(:) );
p2.labels = p1.labels( s(:) );

if ~isempty( p1.blmap )
    p2.blmap = p1.blmap;
end
if ~isempty( p1.blabels )
    p2.blabels = p1.blabels(:, s(:) );
end

p2.ispersistent = p1.ispersistent( s(:) );
p2.histlen = p1.histlen( s(:) );
if ndims( p1.bws ) == 2 && ~isempty(p1.bws)
    p2.bws = p1.bws(:, s(:));
elseif ndims( p1.bws ) == 3 && ~isempty(p1.bws)
    p2.bws = p1.bws(:, :, s(:));
    if ndims( p1.C ) == 3 && ~isempty( p1.C )
        p2.C = p1.C(:, :, s(:));
    end
    if ndims( p1.S )==3 && ~isempty( p1.S )
        p2.S = p1.S(:, :, s(:));
    end
end


