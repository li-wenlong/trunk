function [Xh, varargout] = polargate(Xh, varargin)

center = zeros( 2, 1 );

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
            case {'centre','center'}
                if argnum + 1 <= nvarargin
                    center =  varargin{argnum+1};
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

if iscell(Xh)
    for cnt=1:length(Xh)
        Xh_ = Xh{cnt};
        % Convert the x-y fields to polar coordinates
        [ bearings, ranges ] = cart2pol( Xh_(dims([1]),:)-center(1) ,Xh_(dims([2]),:)-center(2) );
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
        
        Xh{cnt} = Xh_(:, incl );
    end
else
      
        % Convert the x-y fields to polar coordinates
        [ bearings, ranges ] = cart2pol( Xh(dims([1]),:)-center(1) ,Xh(dims([2]),:)-center(2) );
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
        
        Xh = Xh(:, incl );
end
if nargout>=2
    varargout{1} = incl;
end




