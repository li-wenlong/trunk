function i = getpdprofile(this, r )

i = zeros(size(r));

eind = find( r<=this.threshold );
if ~isempty( eind )
    i(eind) = ( -r(eind).*this.a + this.b );
end
uind = setdiff([1:max(size(r))] ,eind);
if ~isempty( uind )
    i(uind ) = this.pdfar;
end
zind = find( r> this.range );
if ~isempty( zind )
    i(zind) = 0;
end