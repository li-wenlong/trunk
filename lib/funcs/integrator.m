% INTEGRATOR is the discrete time step integration class

% Murat Uney
classdef integrator
    properties
        input = 0
    end
    properties( SetAccess = private )
        state = 0;
        deltat = 1.0e-5;
    end
    methods
        % Constructor
        function i = integrator(varargin)      
            if nargin>=1
                i.init(varargin{:});
            end
        end
        % Initiate
        function varargout = init(this, varargin)
            if nargin>=2
                for i=1:2:length(varargin)
                    if isa( varargin{i},'char')
                        switch lower(varargin{i})
                            case 'state',

                                %this.setstate( varargin{i+1} );
                                this.state = varargin{i+1};

                            case 'deltat',

                                %this.settimestep ( varargin{i+1} );
                                this.deltat = varargin{i+1};
                                
                            case 'dim',
                                if isnumeric( varargin{i+1} )
                                this.state = zeros( varargin{i+1} ,1);
                                this.input = zeros( varargin{i+1} ,1);
                                else
                                   error('The dimensionality should be a scalar!'); 
                                end
                            otherwise,
                                error('Unidentified token in the input!');
                        end
                    else
                        error('Cannot identify the input sequence!');
                    end
                end
            end
            if nargout == 0
                if ~isempty( inputname(1) )
                    assignin('caller',inputname(1),this);
                else
                    error('Could not overwrite the instance; make sure that the argument is not in an array!');
                end
            else
                varargout{1} = this;
            end
        end
        function varargout = settimestep(this, deltat )
            if isnumeric(deltat)
                this.deltat = deltat;
            else
                warning(disp('The argument should be numeric, did not change the time step = %g', i.deltat ));
            end
            if nargout == 0
                if ~isempty( inputname(1) )
                    assignin('caller',inputname(1),this);
                else
                    error('Could not overwrite the instance; make sure that the argument is not in an array!');
                end
            else
                varargout{1} = this;
            end
        end
        % Get output given the input
        function outp = getoutp( this, varargin )
            if nargin>=2
                this.setinput( varargin{1} );
            end
            
            outp = this.state + this.input*this.deltat;
            this.setstate( outp );
            
            if ~isempty( inputname(1) )
                assignin('caller',inputname(1),this);
            else
                error('Could not overwrite the instance; make sure that the argument is not in an array!');
            end
            
        end
        % Set input
        function varargout = setinput( this, inp )
            if isnumeric( inp )
                this.input = inp;
               if nargout == 0
                    if ~isempty( inputname(1) )
                        assignin('caller',inputname(1),this);
                    else
                        error('Could not overwrite the instance; make sure that the argument is not in an array!');
                    end
                else
                    varargout{1} = this;
                end
            else
                warning( disp('The argument should be numeric, did not change the input!'));                
            end
        end
        % Set state
        function varargout = setstate( this, st )
            if isnumeric( st )
                this.state = st;
                if nargout == 0
                    if ~isempty( inputname(1) )
                        assignin('caller',inputname(1),this);
                    else
                        error('Could not overwrite the instance; make sure that the argument is not in an array!');
                    end
                else
                    varargout{1} = this;
                end
            else
                warning( disp('The argument should be numeric, did not change the state!'));                
            end
        end
        
    end
end

