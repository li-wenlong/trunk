function [combdists, locdists, cardists ] = calculateOSPAs(Xt, ins, a, b )

combdists = [];
locdists = [];
cardists = [];

for i=1:length( ins )
    Xh = ins{i};
    if isempty( Xh )
        [ combdist1, locdist1, cardist1 ] =new_dist([],  Xt, a, b);
    else
        if size(Xt,1) == 2
            [ combdist1, locdist1, cardist1 ] =new_dist( Xh([1,2],:),  Xt, a, b);
        elseif size(Xt,1) == 4
            [ combdist1, locdist1, cardist1 ] =new_dist( Xh([1,2,3,4],:),  Xt, a, b);
        else
           error('Unmatching dimensionalities!') 
        end
    end
    combdists = [ combdists, combdist1];
    locdists = [ locdists, locdist1];
    cardists = [ cardists, cardist1 ];
    
end