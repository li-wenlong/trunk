classdef poisclut2
    properties
        cfg
        lambda = 10;
        alpha = 30*pi/180;
        range = 10000;
    end
     methods
        function c = poisclut2( varargin )
          if nargin>=1
                if isa( varargin{1}, 'poisclut2cfg' )
                    % initialize with this config
                    c.init( varargin{1} );
                else
                    error('Unknown variable input');
                end
          else
                c.cfg = poisclut2cfg;
                c.init;
           end 
        end
        
    end
end