function clpdf = getclpdf(this)

if isa( this.clutter, 'poisclut1' )
    area_ = (pi*this.maxrange^2);
    clpdf = 1/area_;
else 
    clpdf = this.clutter.getclpdf;
end

