function varargout = isdetdonlynear(these)

isarray = [];
for i=1:length(these)
    isarray = [isarray;these(i).detonlynear];
end


% Return the resultant object
if nargout > 0
    varargout{1} = isarray;
end
