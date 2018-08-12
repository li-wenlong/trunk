classdef poisclut1
    properties
        cfg
        lambda = 10;
    end
     methods
        function c = poisclut1( varargin )
          if nargin>=1
                if isa( varargin{1}, 'poisclut1cfg' )
                    % initialize with this config
                    c.init( varargin{1} );
                else
                    error('Unknown variable input');
                end
          else
                c.cfg = poisclut1cfg;
                c.init;
           end 
        end
        
    end
end