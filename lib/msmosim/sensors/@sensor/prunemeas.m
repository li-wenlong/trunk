function varargout = prunemeas(this, pd )
% sensor.prunemeas(pd) removes measurements from targets with probability pd.
% The resulting effective pd is sensor.pd*pd.

srs = this.srbuffer ;% Take sensor reports
srs.prunemeas( pd );
this.srbuffer = srs;
this.pd = this.pd*pd;

if nargout == 0
    if ~isempty( inputname(1) )
        assignin('caller',inputname(1),this);
    else
        error('Could not overwrite the instance; make sure that the argument is not in an array!');
    end
else
    varargout{1} = this;
end
