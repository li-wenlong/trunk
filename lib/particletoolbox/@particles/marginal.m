function po = marginal( pi, dim )

po = pi;
po.states = po.states( dim,: );
% weights remain the same   weights: [3112x1 double]
po.blmap = po.blmap( dim,: );
% find the blabels that do not exist any more
po.blabels =  po.blabels( sort( unique(po.blmap,'legacy') ), : );

if ~isempty( po.bws )
     if ndims( po.bws )==2
            po.bws = [po.bws( dim, dim ) ];
        elseif ndims( po.bws )==3
            po.bws = po.bws( dim, dim, : );
            po.C = po.C( dim, dim, : );
            po.S = po.S( dim, dim, : );
     end
end