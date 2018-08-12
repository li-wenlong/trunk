function i = getintprofile(this, r )

i = zeros(size(r));

eind = find( r<=this.threshold );
if ~isempty( eind )
    i(eind) = ( -r(eind).*this.a + this.b );
end
uind = setdiff([1:max(size(r))] ,eind);
if ~isempty( uind )
    i(uind ) = this.intun;
end