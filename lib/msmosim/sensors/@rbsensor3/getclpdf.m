function clpdf = getclpdf(this, varargin)

if isa( this.clutter, 'poisclut1' )
    area_ = (pi*this.maxrange^2);
    clpdf = this.clutter.getlambda*ones(1,length(varargin{1}))*1/area_;
elseif isa( this.clutter, 'poisclut2' )
    clpdf = ones(1,length(varargin{1}))*this.clutter.getclpdf*this.clutter.getlambda;
elseif isa( this.clutter, 'poislldclut') 
    clpdf = this.clutter.getclpdf(varargin{:});
elseif isa( this.clutter, 'poislindeclut') 
    clpdf = this.clutter.getclpdf(varargin{:});
end

