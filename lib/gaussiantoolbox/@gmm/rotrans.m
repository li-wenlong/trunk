function varargout = rotrans( this, varargin )

this.pdfs = rotrans( this.pdfs, varargin{:} );

if nargout == 0
    if ~isempty( inputname(1) )
        assignin('caller',inputname(1),these);
    else
        error('Could not overwrite the instance; make sure that the argument is not in an array!');
    end
else
    varargout{1} = this;
end

