function varargout = resample( these, varargin )

varstr = '';
for i=1:length( varargin )
    varstr = [varstr, ', varargin{', num2str(i) ,'}'];
end

for i=1:length( these )
    eval(['these(i).s = resample( these(i).s', varstr ,');']);
end


if nargout == 0
    if ~isempty( inputname(1) )
        assignin('caller',inputname(1),these);
    else
        error('Could not overwrite the instance; make sure that the argument is not in an array!');
    end
else
    varargout{1} = these;
end