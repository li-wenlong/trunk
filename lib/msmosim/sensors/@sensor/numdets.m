function varargout = numdets(these, varargin)

numdetsarray = [];
for i=1:length(these)
    numdetsarray = [numdetsarray;these(i).srbuffer.numdet];
end


% Return the resultant object
if nargout > 0
    varargout{1} = numdetsarray;
end