function [H, R] = getpolarinvmodel(this, varargin );

ndims = 4;
nvarargin = length(varargin);
argnum = 1;
while argnum<=nvarargin
    if isa( varargin{argnum} , 'numeric')
        ndims = varargin{argnum};
    end
    argnum = argnum + 1;
end

H = [1, zeros(1,ndims-1)];

if isempty( this.stdoneorange);
    this.calcinvpolarmodel;
end

R = [this.stdang, zeros(1,ndims-1)]';