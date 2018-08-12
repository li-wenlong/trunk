function varargout = getclutter(this, varargin)

numpts = poissrnd( this.lambda );

out = {};
for i=1:length(varargin)
    out{i} = rand( numpts ,1)*varargin{i}(1);
end

varargout{1} = out;

