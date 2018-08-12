% Range-bearing map modelling the output of a correlator bank matched to
% the time delay (range) of a pulse (train) transmitted possibly by a
% rotating antenna.
% 
%
%
classdef rbintmap1 < sensor
    properties
        minrange; % The four parameters specifying the field of fiew
        maxrange;
        minalpha;
        maxalpha;
        dwelltime;
        betasquare; % Complex noise power
        signalpower;
        deltarange; % range resolution
        deltabearing; % Bearing angle resolution
        numrows;
        numcols;
        colcentres;
        rowcentres;
    end
    methods
        function s = rbintmap1(varargin)
            s = s@sensor( rbintmap1cfg );
            if nargin>=1
                if isa( varargin{1}, 'rbintmap1cfg' )
                    % initialize with this config
                    
                    s.init( varargin{1} );
                else
                    error('Unknown variable input');
                end
            else
                s.cfg = rbintmap1cfg;
                s.init;
            end
        end 
    end
end
