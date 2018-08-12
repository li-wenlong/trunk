function [numap, varargout] = getnumactplats(this)

numap = [];
times = [];
for i=1:length( this.actplatsbuffer)
    numap(i) = length( this.actplatsbuffer(i).actplats  );
    times(i) = this.actplatsbuffer(i).time;
end

if nargout>=1
    varargout{1} = times;
end