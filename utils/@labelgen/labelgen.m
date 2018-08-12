classdef labelgen
    properties
        exponent = 15; 
        counter = 1;
        firstcall = 0;
    end
   methods
        function lgen = labelgen
            lgen = lgen.init;
        end
        function varargout = init(lgen)
            c = datenum(clock);
            
            lsig = 15;
            for i=1:15
                if 10^i>c
                    lsig = i;
                    break;
                end
            end
            
            rsig = 1;
            while( rem(c*10^rsig, 10 ) ~=0 )
                rsig = rsig + 1;
            end
            
            lgen.exponent = rsig + lsig;
                            
            
            lgen.counter =  datenum(clock)*(10^(rsig-1));
            if nargout == 0
                if ~isempty( inputname(1) )
                    assignin('caller',inputname(1),lgen);
                else
                    error('Could not overwrite the instance; make sure that the argument is not in an array!');
                end
            else
                varargout{1} = lgen;
            end
        end
        function varargout = reset(lgen)
            lgen = lgen.init;
             if nargout == 0
                if ~isempty( inputname(1) )
                    assignin('caller',inputname(1),lgen);
                else
                    error('Could not overwrite the instance; make sure that the argument is not in an array!');
                end
            else
                varargout{1} = lgen;
            end
        end
        
         
    end
end
