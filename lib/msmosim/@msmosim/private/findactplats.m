function varargout = findactplats(this)

crrnttime = this.time;
proctime  =  crrnttime + this.deltat;
    
% Find the active platforms
actplats = [];
lints = this.lints;
for i=1:length(this.platforms)
    if crrnttime >= lints(i,1)
        if proctime<= lints(i,2)
            actplats = [actplats, i];
        end
    end
end% Find the active platforms
this.actplats = actplats;

if nargout == 0
    if ~isempty( inputname(1) )
        assignin('caller',inputname(1),this);
    else
        error('Could not overwrite the instance; make sure that the argument is not in an array!');
    end
else
    varargout{1} = this;
end