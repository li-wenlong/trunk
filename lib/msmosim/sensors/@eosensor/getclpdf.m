function clpdf = getclpdf(this, varargin)

if isa( this.clutter, 'poisclut1' )
    area_ = (pi*this.maxrange^2);
    clpdf = ones(1,length(varargin{1}))*1/area_;
elseif isa( this.clutter, 'poisclut2' )
    clpdf = ones(1,length(varargin{1}))*this.clutter.getclpdf;
elseif isa( this.clutter, 'poislldclut') 
    clpdf = this.clutter.getclpdf(varargin{:});
elseif isa( this.clutter, 'eobinomclut' )
    clpdf = ones(1,length(varargin{1}))*this.clutter.getclpdf;
end
clpdf = clpdf(:);

