function cEs = getstatearth( these , varargin )

statlabels = {'x','y','vx','vy'};

nvarargin = length(varargin);
argnum = 1;
while argnum<=nvarargin
    if isa( varargin{argnum} , 'cell')
      statlabels = varargin{argnum};
    end
    argnum = argnum + 1;
end

cEs = [];
for i=1:length(these)
    sobjE = pcs2ecs( these(i).pstate, these(i).sstate );
    cEs = [cEs, sobjE.getstate(statlabels) ];
end
