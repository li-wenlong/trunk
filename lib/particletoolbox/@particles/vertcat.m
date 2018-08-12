function p1 = vertcat( p1, varargin )

for cnt=1:length(varargin)
    if isa( varargin{cnt}, 'particles' )
        p1.states = [p1.states; varargin{cnt}.states  ];
        
        numblabels = size( p1.blabels, 1);
        p1.blabels = [p1.blabels; varargin{cnt}.blabels ];
        p1.blmap = [p1.blmap; varargin{cnt}.blmap + numblabels ];
        
        p1.bws = [p1.bws,  zeros( size(p1.bws,1) , size(varargin{cnt}.bws,2 ), size(varargin{cnt}.bws,3 ) )  ; ...
            zeros( size(varargin{cnt}.bws,2 ), size(p1.bws,1),size(p1.bws,3) )  , varargin{cnt}.bws ];
        p1.C = [p1.C, zeros(size(p1.C,1),size(varargin{cnt}.C,2),size(varargin{cnt}.C,3) );...
            zeros(size(varargin{cnt}.C,2), size(p1.C,1),size(varargin{cnt}.C,3) )  , varargin{cnt}.C ];
        p1.S = [p1.S, zeros(size(p1.S,1), size(varargin{cnt}.S,2), size(p1.S,3))  ; ...
             zeros(size(varargin{cnt}.S,2), size(p1.S,1), size(p1.S,3))  , varargin{cnt}.S ];
    else
        error('The arguments must be of type particles!');
    end
end