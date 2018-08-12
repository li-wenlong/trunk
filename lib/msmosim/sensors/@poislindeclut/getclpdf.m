function clpdf = getclpdf(this, varargin )

clpdf = [];
if ~isempty( varargin )
    if isa(varargin{1},'numeric')
        clpdf = this.getintprofile( varargin{1} );
    elseif isa(varargin{1},'rbmeas')
        Zs = varargin{1}.getcat;
        clpdf = this.getintprofile( Zs(1,:) );
    end
end
