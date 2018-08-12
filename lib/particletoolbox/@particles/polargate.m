function varargout = polargate(this, varargin)

fovalphamax = pi;
fovalphamin = -pi;

fovrangemax = 10000;
fovrangemin = 0;

dims = [1,2];

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
            case {'dims','dimensions'}
                if argnum + 1 <= nvarargin
                    dims = varargin{argnum+1}(:);
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

% Convert the x-y fields to polar coordinates
[ bearings, ranges ] = cart2pol( this.states(dims([1]),:) ,this.states(dims([2]),:) );
bearings = mapang( bearings );

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

this = this.getel( incl );


% Return the modified
if nargout == 0
    if ~isempty( inputname(1) )
        assignin('caller',inputname(1),this);
    else
        error('Could not overwrite the instance; make sure that the argument is not in an array!');
    end
else

     varargout{1} = this;
     if nargout >=2
         varargout{2} = incl;
     end
end
