function varargout = gate(this, varargin)

fovalphamax = this.alpha;
fovalphamin = -this.alpha;

fovrangemax = this.maxrange;
fovrangemin = 0;

nvarargin = length(varargin);
argnum = 1;
while argnum<=nvarargin
    if isa( varargin{argnum} , 'char')
        switch lower(varargin{argnum})
            case {'bearing'}
                if argnum + 1 <= nvarargin
                    fovalphamax = varargin{argnum+1}(1);
                    fovalphamin = -fovalphamax;
                    argnum = argnum + 1;
                end
            case {'bearingmin'}
                if argnum + 1 <= nvarargin
                    fovalphamin = varargin{argnum+1}(1);
                    argnum = argnum + 1;
                end
            case {'bearingmax'}
                if argnum + 1 <= nvarargin
                    fovalphamax = varargin{argnum+1}(1);
                    argnum = argnum + 1;
                end
            case {'range','rangemax'}
                if argnum + 1 <= nvarargin
                    fovrangemax = varargin{argnum+1}(1);
                    argnum = argnum + 1;
                end
            case {'rangemin'}
                if argnum + 1 <= nvarargin
                    fovrangemin = varargin{argnum+1}(1);
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

allbuffer = this.srbuffer;
strcnt = 1;
lastin = strcnt;
for cnt = 1:length( allbuffer )
   srep = allbuffer(cnt);
   srep.Z  = srep.Z.gate( fovalphamin, fovalphamax, fovrangemin, fovrangemax );
   if ~isempty(srep.Z)
       this.srbuffer( strcnt ) = srep;
       lastin = strcnt;
       strcnt = strcnt + 1;
   end
end
if ~isempty( this.srbuffer )
this.srbuffer = this.srbuffer(1:lastin);
end
% Return the modified
if nargout == 0
    if ~isempty( inputname(1) )
        assignin('caller',inputname(1),this);
    else
        error('Could not overwrite the instance; make sure that the argument is not in an array!');
    end
else

     varargout{1} = this;
end
