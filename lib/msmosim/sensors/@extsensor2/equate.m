function this = equate( this, that )

fnames = fieldnames( this );
for j=1:length( fnames )
    eval( [ 'this.', fnames{j},'= that.',fnames{j},';'] );
end
