function pts = gengrid( Ns, limits )

estr = '[';
estr2 = 'pts = [';
for d = 1:length(Ns)
    N = Ns(d);
    lmin = limits( (d-1)*2 + 1 );
    lmax = limits( (d)*2 );
    if lmax<= lmin
        error('limits should be entered in increasing order');
    end
    deltaG = (lmax - lmin )/(N-1);
    % Axis points are
    apts{d} = [lmin:deltaG:lmax];
    estr = [estr,'G{',num2str(d),'},'];
    estr2 = [estr2, 'G{',num2str(d),'}(:),'];
end

estr = [estr(1:end-1),'] = ndgrid( apts{:} );'];
eval( estr );

estr2 = [estr2(1:end-1),']'';' ];
eval( estr2 );


    
    