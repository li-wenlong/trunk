classdef scheduler
    properties
        pattern = {};
        initime = 1;
        counter = 1;
        firstcall = 0;
    end
   methods
       function s = scheduler(varargin)
           if nargin>=1
                if ~isempty(  varargin{1} )
                    % initialize as usual
                    s.init( varargin{:} );
                else 
                    s = scheduler;
                    s = s([]);
                end
           else
                s = s.init(varargin{:});
           end          
       end
       function varargout = init(this, varargin )
           nvarargin = length(varargin);
           argnum = 1;
           while argnum<=nvarargin
               if isa( varargin{argnum} , 'char')
                   switch lower(varargin{argnum})
                       case {'pattern'}
                           if argnum + 1 <= nvarargin
                               this.pattern = varargin{argnum+1};
                               argnum = argnum + 1;
                           end
                       case {'initime'}
                           if argnum + 1 <= nvarargin
                               this.initime = varargin{argnum+1}(1);
                               argnum = argnum + 1;
                           end
                       case {''}
                           
                           
                       otherwise
                           error('Wrong input string');
                   end
               elseif isa( varargin{argnum} , 'numeric')
                   
               end
               argnum = argnum + 1;
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
       function varargout = reset(this)
           this.counter = 1;
           this.firstcall = 0;
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
       
       
   end
end
