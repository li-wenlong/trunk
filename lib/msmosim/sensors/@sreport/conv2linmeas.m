function varargout = conv2linmeas( these , id )


numdets = [];
for i=1:length(these)
    smeas = these(i).Z.getcat;
    [cartmeasX, cartmeasY] =  pol2cart( smeas(2,:),  smeas(1,:) );
     
    Zlin = linmeas;
    Zlin.Z = [cartmeasX(1), cartmeasY(1)]';
    for j=2:length( these(i). Z )
        z = linmeas;
        z.Z = [cartmeasX(j), cartmeasY(j)]';
        Zlin(end+1) = z;
    end
    these(i).Z = Zlin;
end


if nargout == 0
    if ~isempty( inputname(1) )
        assignin('caller',inputname(1),these);
    else
        error('Could not overwrite the instance; make sure that the argument is not in an array!');
    end
else
    varargout{1} = these;
end
