function c = mdiag(this, those )

if isa( those, 'gmm')
    for i=1:length( those.pdfs )
        c(i) = diag( [this, those.pdfs(i)] );
    end
elseif isa( those, 'gk')
    for i=1:length( those )
        c(i) = diag( [this, those(i)] );
    end
    
end