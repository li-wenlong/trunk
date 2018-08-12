classdef eobinomclut
    properties
        cfg
        n ;
        p ;
     end
     methods
        function c = eobinomclut( varargin )
          if nargin>=1
                if isa( varargin{1}, 'eobinomclutcfg' )
                    % initialize with this config
                    c.init( varargin{1} );
                else
                    error('Unknown variable input');
                end
          else
                c.cfg = eobinomclutcfg;
                c.init;
           end 
        end
        
    end
end