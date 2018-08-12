function ps = perspar2pars( these )


% Pull the index of the persistent particles
indx1 = these.getindx( 'p' );

if ~isempty( indx1 )
    ps = particles('states',these(indx1).catstates,'weights',these(indx1).catweights, 'labels', these(indx1).getlastlabel );
    ps.allpersistent;
    ps.subhistlen( these(indx1).gethistlen );
else
    ps = particles;
    ps = ps([]);
end





