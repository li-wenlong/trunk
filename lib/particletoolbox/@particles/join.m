function p1 = join( varargin )

baseone = 0;
for cnt=1:length(varargin)
    if baseone == 0 && ~isempty( varargin{cnt})
        p1 = varargin{cnt};
        baseone = 1;
        continue;
    end
    
    if baseone == 0
        continue;
    end
    
    if isempty( varargin{cnt} )
        continue;
    end
    
    
    if isa( varargin{cnt}, 'particles' )
        p1.states = [p1.states, varargin{cnt}.states  ];
        p1.weights = [ p1.weights; varargin{cnt}.weights  ];
        p1.labels = [p1.labels; varargin{cnt}.labels  ];
        
        % numblabels = size( p1.blabels, 1);
        p1.blabels = [p1.blabels, varargin{cnt}.blabels ];
        % p1.blmap = [p1.blmap; varargin{cnt}.blmap + numblabels ];
        
        p1.ispersistent = [p1.ispersistent; varargin{cnt}.ispersistent  ];
        p1.histlen = [p1.histlen; varargin{cnt}.histlen  ];
        if ndims( p1.bws )==2
            p1.bws = [p1.bws, varargin{cnt}.bws ];
        elseif ndims( p1.bws )==3
            p1.bws = cat(3, p1.bws, varargin{cnt}.bws );
            p1.C = cat(3, p1.C, varargin{cnt}.C );
            p1.S = cat(3, p1.S, varargin{cnt}.S );
        else
           error('bw size not supported!') ;
        end
    else
        error('The arguments must be of type particles!');
    end
end
