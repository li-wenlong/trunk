classdef rbmeas < sensmeas
    properties
        range = 0;
        bearing = 0;
    end
    methods
        function r = rbmeas(varargin)
            r = r@sensmeas(varargin{:});
            if nargin>=1
                if isa(varargin{1},'rbmeas')
                    r.range = varargin{1}.range;
                    r.bearing = varargin{1}.bearing;
                end
            end
            if nargin>=2
                if isnumeric( varargin{1}) && isnumeric(varargin{2})
                    r.bearing = varargin{1};
                    r.range = varargin{2};
                end
            end

        end
        function varargout = gate(these, fovalphamin, fovalphamax, fovrangemin, fovrangemax )
            
            ranges = cell2mat( {these.range}  );
            bearings = mapang( cell2mat( {these.bearing} ) );
            
            
            
            
            incl = find(  bearings <= fovalphamax ) ;
            if ~isempty( incl )
                indx = find( bearings( incl ) >=  fovalphamin );
                incl = incl( indx );
                if ~isempty( incl )
                    indx = find( ranges( incl ) <= fovrangemax );
                    incl = incl( indx );
                    if ~isempty(incl)
                        indx = find( ranges(incl) >= fovrangemin );
                        incl = incl( indx );
                    end
                end
            end
            
            these = these(incl);
            
            % Return the modified
            if nargout == 0
                if ~isempty( inputname(1) )
                    assignin('caller',inputname(1),these);
                else
                    error('Could not overwrite the instance; make sure that the argument is not in an array!');
                end
            else
                
                varargout{1} = these;
                if nargout>=2
                    varargout{2} = incl;
                end
            end
        end

    end
end
