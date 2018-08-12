function varargout = numdet( these , varargin )


numdets = [];
for i=1:length(these)
    stime = these(i).time;
    
   % totaldets = length( these(i).given(:));
     totaldets = length( these(i).Z );
    clut = length( find(these(i).given(:)==0) );
    numdets(i) = totaldets - clut;
end



if nargout > 0
    varargout{1} = numdets;
    if nargout>1
        varargout{2} = these;
    end
end