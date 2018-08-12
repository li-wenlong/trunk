function varargout = drawc( phd, varargin )

[axisHandle, figureHandle] = phd.s.drawc(varargin{:}, 'scale', phd.mu );


if nargout>=1
    varargout{1} = axisHandle;
end
if nargout>=2
    varargout{2} = figureHandle;
end