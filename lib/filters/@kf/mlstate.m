function varargout = mlstate( this, sensor )

isquit = 0;
if ~isempty( this.post )
   % quit 
    isquit = 1;
end
if isquit
    if nargout == 0
        if ~isempty( inputname(1) )
            assignin('caller',inputname(1),this);
        else
            error('Could not overwrite the instance; make sure that the argument is not in an array!');
        end
    else
        varargout{1} = this;
    end
    return;
end

% Check whether there are at least one sensor measurement
senlist = zeros(1,length(sensor));
for i=1:length(this.Z)
    if length( this.Z(i).Z ) ~=0
        senlist(i) = 1;
        isquit = 0;
    end
end

if isquit
    this.post = [];
    if nargout == 0
        if ~isempty( inputname(1) )
            assignin('caller',inputname(1),this);
        else
            error('Could not overwrite the instance; make sure that the argument is not in an array!');
        end
    else
        varargout{1} = this;
    end
    return;
end

[ gk1 ] = sensor.mlstate( this.Z ); % Use the ML estimate of the first sensor (i.e. the measurement in the reference coordinate frame)

for zcnt = 1:length( gk1 )
    gkinit(zcnt) = cpdf( diag( [gk1(zcnt), this.veldist] ) );
end

this.initstate = gkinit;

if nargout == 0
    if ~isempty( inputname(1) )
        assignin('caller',inputname(1),this);
    else
        error('Could not overwrite the instance; make sure that the argument is not in an array!');
    end
else
    varargout{1} = this;
end
