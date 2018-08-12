function st = fun_kdemultusingparticles( these )

inKde = 0;

if iscell( these )
    
    if isa( these{1}, 'kde' )
        inKde = 1;
    end
    
    if inKde
        for i=1:length(these)
            ps(i) = kde2par( these{i} );
        end
    else
        ps = these{:};
    end
else
    if isa( these(1), 'kde' )
        inKde = 1;
    end
    
    if inKde
        for i=1:length(these)
            ps(i) = kde2par( these(:) );
        end
    else
        ps = these(:);
    end
end

mps = prodisgausspair( ps );

if inKde
    st = kde( mps.getstates, 'rot', mps.getweights', 'g' );
else
    st = mps;
end