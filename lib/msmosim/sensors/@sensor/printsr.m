function varargout = printsr(these, varargin)


fprintf('\n');
for i=1:length(these)
    fprintf('Sensor report sources for sensor ID %d', these(i).ID);
    these(i).srbuffer.printsr;
    fprintf('\n');
end


% Return the resultant object
if nargout > 0
   
    varargout{1} = these;
end