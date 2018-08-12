classdef sreport
    properties
        time
        pstate
        sstate
        Z
        given
    end
    methods
        function s = sreport( varargin )
            nvarargin = length(varargin);
            if nargin >=1
                if ~isempty( varargin{1} )
                    argnum = 1;
                    fnames = s.fieldnames;
                    while argnum<=nvarargin
                        if isa( varargin{argnum} , 'char')
                            ind = findincells( fnames, varargin(argnum) );
                            if ~isempty( ind )                                
                                if argnum + 1 <= nvarargin
                                    s = setfield( s, varargin{argnum} , varargin{argnum+1}(1));
                                    
                                    argnum = argnum + 1;
                                else
                                    error(sprintf('Value for the field %s has not been entered!', varargin{argnum} ));
                                end
                            elseif isa( varargin{argnum} , 'numeric')
                                % undecided course of action
                            end
                        end
                        argnum = argnum + 1;
                        
                    end
                elseif isempty(  varargin{1} )
                    s = s([]);
                end
            else
                % will return an untouched object s
            end
    end
        
    end
end
