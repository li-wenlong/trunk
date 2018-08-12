function [ combdist,locdists, cardists] = calcOSPAseries( Xt, Xh, varargin )  



combdist = [];
locdists = [];
cardists = [];

a = 250;
b = 1;

if nargin>=3
    a = varargin{1};
end

if nargin>=4
    b = varargin{2};
end

if iscell( Xt )
    for i=1:min( length(Xt), length(Xh) )
        Xte = Xt{i};
        Xhe = Xh{i};
        if isempty( Xh )
            [ combdist1, locdist1, cardist1 ] =new_dist([],  Xte, a, b);
        else
            [ combdist1, locdist1, cardist1 ] =new_dist( Xhe, Xte, a, b);
        end
        combdist(i) = combdist1;
        locdists(i) = locdist1;
        cardists(i) = cardist1;
        
    end
else
    Xte = Xt;
    Xhe = Xh;
    if isempty( Xh )
        [ combdist1, locdist1, cardist1 ] =new_dist([],  Xte, a, b);
    else
        [ combdist1, locdist1, cardist1 ] =new_dist( Xhe, Xte, a, b);
    end
    combdist(1) = combdist1;
    locdists(1) = locdist1;
    cardists(1) = cardist1;
    
    
end
    
